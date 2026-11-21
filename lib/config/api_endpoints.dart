import 'app_constants.dart';

class ApiEndpoints {
  static const todos = '${AppConstants.baseUrl}?limit=0';
  static const add = '${AppConstants.baseUrl}/add';
  static String todoById(String id) => '${AppConstants.baseUrl}/$id';
}
