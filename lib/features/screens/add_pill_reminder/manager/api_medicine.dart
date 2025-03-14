import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/model/data_medicine.dart';
import 'package:smartpill/utils/token_manager.dart';

class MedicineService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://10.0.2.2:5238/api/Medicine';

  MedicineService() {
    _dio.options.headers["Content-Type"] = "application/json";
    _setupAuthInterceptor();
  }

  void _setupAuthInterceptor() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final tokenData = await TokenManager.getToken();
        final token = tokenData['token'];

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
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
    } catch (e) {
      debugPrint('Error adding medicine: $e');
      return false;
    }
  }

  // Get all medicines
  Future<List<MedicinePill>> getAllMedicines() async {
    try {
      final response = await _dio.get('$baseUrl/GetAll');
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = response.data;
        return data.map((json) => MedicinePill.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting medicines: $e');
      return [];
    }
  }

  // Delete medicine
  Future<bool> deleteMedicine(String id) async {
    try {
      final response = await _dio.delete('$baseUrl/Delete/$id');
      debugPrint('Delete Response: ${response.statusCode}, ${response.data}');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('Error deleting medicine: $e');
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
    } catch (e) {
      debugPrint('Error updating medicine: $e');
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
      return null;
    } catch (e) {
      debugPrint('Error getting medicine by id: $e');
      return null;
    }
  }
}
