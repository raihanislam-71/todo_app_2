import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_constants.dart';

class ApiCaller {
  static Future<Map<String, dynamic>> get(String url) async {
    final response = await http
        .get(Uri.parse(url))
        .timeout(AppConstants.defaultTimeout);
    return _decode(response);
  }

  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http
        .post(Uri.parse(url), headers: _headers, body: jsonEncode(body ?? {}))
        .timeout(AppConstants.defaultTimeout);
    return _decode(response);
  }

  static Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http
        .put(Uri.parse(url), headers: _headers, body: jsonEncode(body ?? {}))
        .timeout(AppConstants.defaultTimeout);
    return _decode(response);
  }

  static Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http
        .patch(Uri.parse(url), headers: _headers, body: jsonEncode(body ?? {}))
        .timeout(AppConstants.defaultTimeout);
    return _decode(response);
  }

  static Future<Map<String, dynamic>> delete(String url) async {
    final response = await http
        .delete(Uri.parse(url))
        .timeout(AppConstants.defaultTimeout);
    return _decode(response);
  }

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, dynamic> _decode(http.Response response) {
    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        decoded['message'] ?? 'Request failed (${response.statusCode})',
      );
    }
    if (decoded is Map<String, dynamic>) return decoded;
    return {'data': decoded};
  }
}
