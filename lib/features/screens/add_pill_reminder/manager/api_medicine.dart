import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/model/data_medicine.dart';
import 'package:smartpill/utils/token_manager.dart';

class MedicineService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://healthcare1.runasp.net/api/Medicine';

  MedicineService() {
    _dio.options.headers["Content-Type"] = "application/json";
    _setupAuthInterceptor();
  }

  void _setupAuthInterceptor() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final tokenData = await TokenManager.getToken();
          final token = tokenData['token'];

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {
          debugPrint('Error fetching token: $e');
        }
        handler.next(options); // Ensure request proceeds
      },
    ));
  }

  // Add medicine
  Future<bool> addMedicine(MedicinePill medicine) async {
    try {
      final response = await _dio.post(
        '$baseUrl/Add',
        data: medicine.toJson(),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      debugPrint('Error adding medicine: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  // Get all medicines
  Future<List<MedicinePill>> getAllMedicines() async {
    try {
      final response = await _dio.get('$baseUrl/GetAll');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => MedicinePill.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      debugPrint('Error getting medicines: ${e.response?.data ?? e.message}');
    }
    return [];
  }

  // Delete medicine
  Future<bool> deleteMedicine(String id) async {
    try {
      final response = await _dio.delete('$baseUrl/Delete/$id');
      debugPrint('Delete Response: ${response.statusCode}, ${response.data}');
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      debugPrint('Error deleting medicine: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  // Update medicine
  Future<bool> updateMedicine(MedicinePill medicine) async {
    try {
      final response = await _dio.put(
        '$baseUrl/Update/${medicine.id}',
        data: medicine.toJson(),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('Error updating medicine: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  // Get medicine by ID
  Future<MedicinePill?> getMedicineById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/Get/$id');
      if (response.statusCode == 200) {
        return MedicinePill.fromJson(response.data);
      }
    } on DioException catch (e) {
      debugPrint(
          'Error getting medicine by id: ${e.response?.data ?? e.message}');
    }
    return null;
  }
}
