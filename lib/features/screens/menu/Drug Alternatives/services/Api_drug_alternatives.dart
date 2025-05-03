import 'package:dio/dio.dart';
import 'package:smartpill/model/DrugAlternative.dart';

class ApiServiceDrugAlternatives {
  // Base URL for the API
  final String baseUrl = 'http://healthcare1.runasp.net/api';

  // Dio instance with default configuration
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
    responseType: ResponseType.json,
  ));
  ApiServiceDrugAlternatives() {
    // Add logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<List<DrugAlternative>> getDrugSuggestions(String query) async {
    try {
      final response = await _dio.get(
        '$baseUrl/MedicineAlternative/suggest?',
        queryParameters: {'name': query},
      );

      if (response.statusCode == 200) {
        // Parse the response data
        final List<dynamic> data = response.data;
        return data.map((item) => DrugAlternative.fromJson(item)).toList();
      } else {
        // Handle error based on status code
        throw DioException(
          requestOptions:
              RequestOptions(path: '$baseUrl/MedicineAlternative/suggest'),
          message: 'Failed to load suggestions: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Handle Dio specific exceptions
      String errorMessage = 'Error fetching suggestions';

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Server is taking too long to respond. Please try again later.';
      } else if (e.response != null) {
        errorMessage = 'Server error: ${e.response?.statusCode}';
      }

      throw Exception(errorMessage);
    } catch (e) {
      // Handle other exceptions
      throw Exception('Error fetching suggestions: ${e.toString()}');
    }
  }

  // Method to fetch drug alternatives for a specified drug
  Future<List<DrugAlternative>> getDrugAlternatives(String drugName) async {
    if (drugName.isEmpty) {
      throw Exception('Drug name cannot be empty');
    }

    try {
      final response = await _dio.get(
        '$baseUrl/MedicineAlternative/alternatives',
        queryParameters: {'name': drugName},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => DrugAlternative.fromJson(item)).toList();
      } else {
        throw DioException(
          requestOptions:
              RequestOptions(path: '$baseUrl/MedicineAlternative/alternatives'),
          message: 'Failed to load alternatives: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Handle Dio specific exceptions
      String errorMessage = 'Error fetching alternatives';

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Server is taking too long to respond. Please try again later.';
      } else if (e.response != null) {
        errorMessage = 'Server error: ${e.response?.statusCode}';
      }

      throw Exception(errorMessage);
    } catch (e) {
      // Handle other exceptions
      throw Exception('Error fetching alternatives: ${e.toString()}');
    }
  }
}
