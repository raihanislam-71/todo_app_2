import '../models/todo_model.dart';
import 'api_caller.dart';
import '../../config/api_endpoints.dart';

class TodoApiService {
  Future<List<TodoModel>> fetchTodos() async {
    final result = await ApiCaller.get(ApiEndpoints.todos);
    final list = result['todos'] as List? ?? [];
    return list.map((item) => _fromDummyJson(item as Map<String, dynamic>)).toList();
  }

  Future<TodoModel> createTodo(TodoModel todo) async {
    final result = await ApiCaller.post(
      ApiEndpoints.add,
      body: _toDummyJson(todo),
    );
    return _fromDummyJson(result);
  }

  Future<TodoModel> updateTodo(TodoModel todo) async {
    final result = await ApiCaller.put(
      ApiEndpoints.todoById(todo.id),
      body: _toDummyJson(todo),
    );
    return _fromDummyJson(result);
  }

  Future<TodoModel> updateStatus(String id, String status) async {
    final completed = status.toLowerCase() == 'completed';
    // DummyJSON supports PATCH for partial updates — only send the field being changed
    final result = await ApiCaller.patch(
      ApiEndpoints.todoById(id),
      body: {'completed': completed},
    );
    return _fromDummyJson(result);
  }

  Future<TodoModel> fetchTodoById(String id) async {
    final result = await ApiCaller.get(ApiEndpoints.todoById(id));
    return _fromDummyJson(result);
  }

  Future<bool> deleteTodo(String id) async {
    try {
      await ApiCaller.delete(ApiEndpoints.todoById(id));
      return true;
    } catch (_) {
      return false;
    }
  }

  static TodoModel _fromDummyJson(Map<String, dynamic> json) => TodoModel(
        id: (json['id'] ?? '').toString(),
        title: (json['todo'] ?? 'Untitled').toString(),
        description: (json['description'] ?? '').toString(),
        status: (json['completed'] as bool?) == true ? 'Completed' : 'Not Started',
        priority: (json['priority'] ?? 'Medium').toString(),
        dueDate: null,
        tags: [],
      );

  static Map<String, dynamic> _toDummyJson(TodoModel todo) => {
        'todo': todo.title,
        'completed': todo.isCompleted,
        'priority': todo.priority,
        'userId': 1,
      };
}
