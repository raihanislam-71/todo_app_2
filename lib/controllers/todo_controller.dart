import 'package:get/get.dart';

import '../data/models/todo_model.dart';
import '../data/services/todo_api_service.dart';
import '../views/widgets/common/custom_snackbar.dart';

class TodoController extends GetxController {
  final TodoApiService _service = TodoApiService();
  final todos = <TodoModel>[].obs;
  final isLoading = false.obs;
  final selectedFilter = 'All'.obs;
  final errorMessage = ''.obs;

  // Track IDs of todos created locally (dummyjson /add doesn't persist them)
  final _localTodoIds = <String>{};

  List<TodoModel> get filteredTodos {
    if (selectedFilter.value == 'Completed')
      return todos.where((t) => t.isCompleted).toList();
    if (selectedFilter.value == 'Pending')
      return todos.where((t) => !t.isCompleted).toList();
    return todos.toList();
  }

  int get completedCount => todos.where((t) => t.isCompleted).length;
  int get pendingCount => todos.length - completedCount;

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      todos.assignAll(await _service.fetchTodos());
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String value) => selectedFilter.value = value;

  Future<bool> addTodo(TodoModel todo) async {
    try {
      final created = await _service.createTodo(todo);
      // Preserve priority from original todo since dummyjson API response
      // may not include custom priority field
      final todoWithPriority = created.copyWith(priority: todo.priority);
      // Track this ID as locally created since dummyjson /add doesn't persist it
      _localTodoIds.add(todoWithPriority.id);
      todos.insert(0, todoWithPriority);
      AppSnackbar.showSuccess('Success', 'Task added');
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.showError('Failed', 'Could not add task');
      return false;
    }
  }

  Future<void> toggleTodo(TodoModel todo) async {
    final next = todo.isCompleted ? 'Not Started' : 'Completed';
    try {
      // Handle locally created todos without API call (dummyjson /add IDs don't exist)
      if (_localTodoIds.contains(todo.id)) {
        final index = todos.indexWhere((t) => t.id == todo.id);
        if (index >= 0) {
          todos[index] = todo.copyWith(status: next);
          AppSnackbar.showInfo('Updated', 'Task status changed');
        }
        return;
      }

      final updated = await _service.updateStatus(todo.id, next);
      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index >= 0) {
        todos[index] = updated.copyWith(priority: todo.priority);
        AppSnackbar.showInfo('Updated', 'Task status changed');
      }
    } catch (e) {
      AppSnackbar.showError('Update failed', e.toString());
    }
  }

  Future<void> removeTodo(TodoModel todo) async {
    try {
      // Handle locally created todos without API call (dummyjson /add IDs don't exist)
      if (_localTodoIds.contains(todo.id)) {
        _localTodoIds.remove(todo.id);
        todos.removeWhere((t) => t.id == todo.id);
        AppSnackbar.showError('Deleted', 'Task removed');
        return;
      }

      final deleted = await _service.deleteTodo(todo.id);
      if (deleted) {
        todos.removeWhere((t) => t.id == todo.id);
        AppSnackbar.showError('Deleted', 'Task removed');
      } else {
        AppSnackbar.showError('Delete failed', 'Server did not confirm deletion');
      }
    } catch (e) {
      AppSnackbar.showError('Delete failed', e.toString());
    }
  }
}
