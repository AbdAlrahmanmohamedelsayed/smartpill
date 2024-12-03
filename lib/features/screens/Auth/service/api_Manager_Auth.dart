import 'package:dio/dio.dart';
import 'package:smartpill/model/Auth_Responce.dart';
import 'package:smartpill/model/Login.dart';

class ApiManagerAuth {
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
        return AuthResponce.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw Exception('Failed to Login.email or password is wrong');
      } else {
        throw Exception(
            'Failed to SignUp. Server responded with: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Failed to login: email or password is incorrect.');
      } else {
        throw Exception(
            'Failed to SignUp. Server responded with: ${e.response?.statusCode}');
      }
    }
  }

  Future<AuthResponce> SignUp(
      String userName, String email, String password, String role) async {
    try {
      final responce = await _dio.post('/register', data: {
        'username': userName,
        'email': email,
        'password': password,
        'role': role,
      });
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        return AuthResponce.fromJson(responce.data);
      } else {
        throw Exception('Failed to SignUp. : '); //${responce.statusCode}
      }
    } catch (e) {
      throw Exception('Falied to SignUp : $e');
    }
  }
}
