import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../core/constants.dart';

class ApiService {
  static String get _baseUrl => '${AppConstants.baseUrl}/api';

  static Future<http.Response> get(String endpoint) async {
    final token = await AuthService.getToken();
    try {
      return await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          ...AppConstants.apiHeaders,
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(AppConstants.kRequestTimeout);
    } catch (e) {
      throw Exception('Network error or server unavailable: $e');
    }
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await AuthService.getToken();
    try {
      return await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          ...AppConstants.apiHeaders,
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(AppConstants.kRequestTimeout);
    } catch (e) {
      throw Exception('Network error or server unavailable: $e');
    }
  }

  static Future<http.Response> patch(String endpoint, Map<String, dynamic> body) async {
    final token = await AuthService.getToken();
    try {
      return await http.patch(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          ...AppConstants.apiHeaders,
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(AppConstants.kRequestTimeout);
    } catch (e) {
      throw Exception('Network error or server unavailable: $e');
    }
  }
}
