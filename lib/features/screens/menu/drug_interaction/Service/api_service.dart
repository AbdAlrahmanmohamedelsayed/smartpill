import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:smartpill/model/drug_interaction.dart';

class ApiService {
  final Dio dio = Dio();

  ApiService() {
    dio.options = BaseOptions(
      baseUrl: 'https://10.0.2.2:7228/api',
      connectTimeout: const Duration(seconds: 20),
    );

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<DrugInteraction> fetchDrugInteraction(
      String drug1, String drug2) async {
    try {
      final response = await dio.get(
        '/DrugInteraction/interaction',
        queryParameters: {
          'drug1': drug1,
          'drug2': drug2,
        },
      );

      if (response.statusCode == 200) {
        return DrugInteraction.fromJson(response.data);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }
}
