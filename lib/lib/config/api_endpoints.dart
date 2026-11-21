// import 'app_constants.dart';

// class ApiEndpoints {
//   static const taskList = '${AppConstants.baseUrl}/task/list';
//   static const taskAdd = '${AppConstants.baseUrl}/task/add';
//   static const taskUpdate = '${AppConstants.baseUrl}/task/update';
//   static const taskDelete = '${AppConstants.baseUrl}/task/delete';
// }

class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://dummyjson.com';

  // Endpoints
  static const String todos = '$baseUrl/todos'; // GET (all)
  static String todoById(int id) =>
      '$todos/$id'; // GET (one), PUT, PATCH, DELETE
  static const String addTodo = '$todos/add'; // POST (create)
  static const String randomTodo = '$todos/random'; // GET (random one)
  static String randomTodos(int length) =>
      '$todos/random/$length'; // GET (random up to 10)
  static String todosByUser(int userId) =>
      '$todos/user/$userId'; // GET (by user ID)
  static String paginatedTodos({
    int limit = 30,
    int skip = 0,
    String? select,
  }) =>
      '$todos?limit=$limit&skip=$skip${select != null ? '&select=$select' : ''}'; // GET (limit & skip)
  static String sortedTodos({required String sortBy, String order = 'asc'}) =>
      '$todos?sortBy=$sortBy&order=$order'; // GET (sort)
}
