import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:smartpill/features/screens/menu/drug_interaction/Service/Api_Constant.dart';
import 'package:smartpill/model/drug_interaction.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstant.baseUrl,
            connectTimeout: const Duration(seconds: 20),
          ),
        ) {
    // Handle SSL issues if needed
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
        ApiConstant.getDrugInteractions,
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
      // Log and rethrow Dio-specific errors for debugging
      print('Dio error: ${dioError.message}');
      rethrow;
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }
}
