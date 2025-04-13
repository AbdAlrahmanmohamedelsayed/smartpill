import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartpill/model/SymptomTips.dart';

class ApiService {
  static const String baseUrl =
      'https://flask-chatbot-production-1a6b.up.railway.app';

  Future<TipsResponse> getTips(String text, {int retries = 3}) async {
    Exception? lastException;

    for (int i = 0; i < retries; i++) {
      try {
        final response = await http
            .post(
              Uri.parse('$baseUrl/get_tips'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'text': text,
              }),
            )
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          return TipsResponse.fromJson(jsonData);
        } else {
          throw Exception(
              'Failed to get tips. Status code: ${response.statusCode}');
        }
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        // Wait before retrying
        if (i < retries - 1) {
          await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
        }
      }
    }

    throw lastException ?? Exception('Unknown error occurred');
  }
}
