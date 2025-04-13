import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:smartpill/model/Auth_Responce.dart';
import 'package:smartpill/model/Login.dart';
import 'package:smartpill/utils/token_manager.dart';

class ApiManagerAuth {
  late final Dio _dio;

  ApiManagerAuth() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://healthcare1.runasp.net/api/Accounts",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<AuthResponce> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: LoginRequest(email: email, password: password).toJson(),
      );

      if (response.statusCode == 200) {
        AuthResponce authResponse = AuthResponce.fromJson(response.data);

        // Save token, email, and username
        await TokenManager.saveToken(
            authResponse.token, email, authResponse.displayName);

        return authResponse;
      } else if (response.statusCode == 401) {
        throw Exception('Login failed: Incorrect email or password.');
      } else {
        throw Exception(
            'Login failed. Server responded with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Login failed. Error: ${e.message}, Response: ${e.response?.data}');
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

        // Save token, email, and username after signup
        await TokenManager.saveToken(
            authResponse.token, email, authResponse.displayName);

        return authResponse;
      } else {
        throw Exception(
            'Sign-up failed. Server responded with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Sign-up failed. Error: ${e.message}, Response: ${e.response?.data}');
    }
  }
}
