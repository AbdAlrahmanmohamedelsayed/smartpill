import 'package:shared_preferences/shared_preferences.dart';

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
