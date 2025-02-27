import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:smartpill/model/Auth_Responce.dart';
import 'package:smartpill/model/Login.dart';
import 'package:smartpill/utils/token_manager.dart';

class ApiManagerAuth {
  // late final Dio _dio;

  // ApiManagerAuth() {
  //   _dio = Dio(
  //     BaseOptions(
  //       baseUrl: "http://localhost:5238/api/Accounts/",
  //       connectTimeout: const Duration(seconds: 10),
  //       receiveTimeout: const Duration(seconds: 10),
  //     ),
  //   );

  //   (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
  //       (HttpClient client) {
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;
  //     return client;
  //   };
  // }

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://loginregister.runasp.net/api/Account",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

  Future<AuthResponce> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: LoginRequest(email: email, password: password).toJson(),
      );

      if (response.statusCode == 200) {
        AuthResponce authResponse = AuthResponce.fromJson(response.data);

        // حفظ التوكن والبريد الإلكتروني
        await TokenManager.saveToken(authResponse.token, email);

        return authResponse;
      } else if (response.statusCode == 401) {
        throw Exception('Failed to login: email or password is incorrect.');
      } else {
        throw Exception(
            'Failed to login. Server responded with: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to login. Error: ${e.response?.statusCode ?? 'Unknown error'}');
    }
  }

  Future<AuthResponce> signUp(
      String userName, String email, String password, String role) async {
    try {
      final response = await _dio.post('/register', data: {
        'username': userName,
        'email': email,
        'password': password,
        'role': role,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponce authResponse = AuthResponce.fromJson(response.data);

        return authResponse;
      } else {
        throw Exception(
            'Failed to sign up. Server responded with: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to sign up. Error: ${e.response?.statusCode ?? 'Unknown error'}');
    }
  }
}
