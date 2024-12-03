import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:smartpill/features/screens/menu/drug_interaction/Service/Api_Constant.dart';
import 'package:smartpill/model/drug_interaction.dart';

class ApiServiceDruginteraction {
  final Dio _dio;

  ApiServiceDruginteraction()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstantDrugInteraction.baseUrl,
            connectTimeout: const Duration(seconds: 10),
          ),
        ) {
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<DrugInteraction> fetchDrugInteraction(
      String drug1, String drug2) async {
    try {
      final response = await _dio.get(
        ApiConstantDrugInteraction.getDrugInteractions,
        queryParameters: {
          'drug1': drug1,
          'drug2': drug2,
        },
      );

      if (response.statusCode == 200) {
        return DrugInteraction.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load data: ${response.statusCode} ${response.statusMessage}');
      }
    } on DioException catch (dioError) {
      print('Dio error: ${dioError.message}');
      rethrow;
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }

  Future<List<String>> searchDrugNames(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      final response = await _dio.get(
        ApiConstantDrugInteraction.getDrugsearch,
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.cast<String>();
        } else {
          throw Exception(
              'Unexpected response format: ${response.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load search results: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      // Log the error and stack trace for debugging
      print('Error fetching drug names: $e');
      print('StackTrace: $stackTrace');
      rethrow; // Re-throw to propagate error
    }
  }
}
