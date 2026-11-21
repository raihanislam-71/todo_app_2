import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_colors.dart';
import '../data/models/todo_model.dart';
import '../data/services/todo_api_service.dart';

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
      Get.snackbar('Success', 'Task added',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.green,
          colorText: Colors.white);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Failed', 'Could not add task',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.error,
          colorText: Colors.white);
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
          Get.snackbar('Updated', 'Task status changed',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.primary,
              colorText: Colors.white);
        }
        return;
      }

      final updated = await _service.updateStatus(todo.id, next);
      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index >= 0) {
        todos[index] = updated.copyWith(priority: todo.priority);
        Get.snackbar('Updated', 'Task status changed',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.primary,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Update failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.error,
          colorText: Colors.white);
    }
  }

  Future<void> removeTodo(TodoModel todo) async {
    try {
      // Handle locally created todos without API call (dummyjson /add IDs don't exist)
      if (_localTodoIds.contains(todo.id)) {
        _localTodoIds.remove(todo.id);
        todos.removeWhere((t) => t.id == todo.id);
        Get.snackbar('Deleted', 'Task removed',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.error,
            colorText: Colors.white);
        return;
      }

      final deleted = await _service.deleteTodo(todo.id);
      if (deleted) {
        todos.removeWhere((t) => t.id == todo.id);
        Get.snackbar('Deleted', 'Task removed',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.error,
            colorText: Colors.white);
      } else {
        Get.snackbar('Delete failed', 'Server did not confirm deletion',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.error,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Delete failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.error,
          colorText: Colors.white);
    }
  }
}
