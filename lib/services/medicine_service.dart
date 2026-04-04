import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/models/medicine.dart';
import '../core/models/medicine_request.dart';

class MedicineService {
  static final String _baseUrl = '${AppConstants.baseUrl}/api/medicine';

  static Future<List<Medicine>> getAllMedicines() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/all'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Medicine.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching medicines: $e');
      return [];
    }
  }

  static Future<List<Medicine>> searchMedicines(String name) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/search/$name'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Medicine.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error searching medicines: $e');
      return [];
    }
  }

  static Future<bool> addMedicine(Medicine medicine) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(medicine.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error adding medicine: $e');
      return false;
    }
  }

  static Future<bool> updateMedicine(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating medicine: $e');
      return false;
    }
  }

  static Future<bool> deleteMedicine(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/delete/$id'));
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting medicine: $e');
      return false;
    }
  }

  // Medicine Request Methods
  static Future<bool> requestMedicine(MedicineRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/request'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error requesting medicine: $e');
      return false;
    }
  }

  static Future<List<MedicineRequest>> getPatientRequests(String uid) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/requests/patient/$uid'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => MedicineRequest.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching patient requests: $e');
      return [];
    }
  }

  static Future<List<MedicineRequest>> getPharmacistRequests({String? pharmacistId, String? status}) async {
    try {
      String query = '';
      if (pharmacistId != null) query += 'pharmacistId=$pharmacistId&';
      if (status != null) query += 'requestStatus=$status&';
      
      final response = await http.get(Uri.parse('$_baseUrl/requests?$query'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => MedicineRequest.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching pharmacist requests: $e');
      return [];
    }
  }

  static Future<bool> updateRequestStatus(String requestId, String status, {String? pharmacistId, String? responseNote}) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/request/$requestId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'requestStatus': status,
          'pharmacistId': pharmacistId,
          'pharmacistResponse': responseNote,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating request status: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> getPharmacistStats(String pharmacistId) async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/api/stats/pharmacist?pharmacistId=$pharmacistId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {};
    } catch (e) {
      print('Error fetching pharmacist stats: $e');
      return {};
    }
  }
}
