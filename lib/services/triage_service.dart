import 'dart:convert';
import 'api_service.dart';

class TriageService {
  static Future<List<dynamic>> getAllCases() async {
    final response = await ApiService.get('/triage');
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load triage cases');
    }
  }

  static Future<Map<String, dynamic>> createCase({
    required String name,
    required String village,
    required String symptoms,
    String? severity,
  }) async {
    final response = await ApiService.post('/triage', {
      'name': name,
      'village': village,
      'symptoms': symptoms,
      'severity': ?severity,
    });

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to create triage case');
    }
  }
}
