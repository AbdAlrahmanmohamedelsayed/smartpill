import 'package:dio/dio.dart';
import 'package:smartpill/model/data_medicine.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://localhost:5238/api/Medicine';

  MedicineService() {
    _dio.options.headers["Content-Type"] = "application/json";
    _setupAuthInterceptor();
  }

  // Set up an interceptor to add the token to every request
  void _setupAuthInterceptor() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get token from TokenManager
        final tokenData = await TokenManager.getToken();
        final token = tokenData['token'];

        // Add token to authorization header if available
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
    ));
  }

  Future<bool> addMedicine(MedicinePill medicine) async {
    try {
      final response = await _dio.post(
        '$baseUrl/Add',
        data: medicine.toJson(),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      print('Error adding medicine: ${e.message}');
      return false;
    }
  }

  Future<List<MedicinePill>> getAllMedicines() async {
    try {
      final response = await _dio.get(baseUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => MedicinePill.fromJson(json)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      print('Error getting medicines: ${e.message}');
      return [];
    }
  }

  Future<bool> deleteMedicine(int id) async {
    try {
      final response = await _dio.delete('$baseUrl/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      print('Error deleting medicine: ${e.message}');
      return false;
    }
  }

  Future<bool> updateMedicine(MedicinePill medicine) async {
    try {
      final response = await _dio.put(
        '$baseUrl/${medicine.id}',
        data: medicine.toJson(),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error updating medicine: ${e.message}');
      return false;
    }
  }

  Future<MedicinePill?> getMedicineById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/$id');
      if (response.statusCode == 200) {
        return MedicinePill.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print('Error getting medicine by id: ${e.message}');
      return null;
    }
  }
}

class TokenManager {
  static const String _tokenKey = 'token';
  static const String _emailKey = 'email';

  // Save token and email
  static Future<void> saveToken(String token, String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_emailKey, email);
    } catch (e) {
      print('Error saving token: $e');
      rethrow;
    }
  }

  // Get token and email
  static Future<Map<String, String?>> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'token': prefs.getString(_tokenKey),
        'email': prefs.getString(_emailKey),
      };
    } catch (e) {
      print('Error getting token: $e');
      return {'token': null, 'email': null};
    }
  }

  // Clear token and email
  static Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_emailKey);
    } catch (e) {
      print('Error clearing token: $e');
      rethrow;
    }
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    try {
      final tokenData = await getToken();
      final token = tokenData['token'];
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Error checking authentication: $e');
      return false;
    }
  }
}
