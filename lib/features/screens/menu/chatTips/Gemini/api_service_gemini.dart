import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartpill/features/screens/menu/chatTips/Gemini/SymptomTips_gemini.dart';
import 'package:smartpill/model/SymptomTips.dart';

class ApiServiceGemini {
  final String baseUrl = 'http://healthcare1.runasp.net/api/Gemini';

  Future<SymptomTipsGem> getTips(String symptom) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get-tips'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          {"symptoms": symptom, "what take when feel headache ": null}),
    );

    if (response.statusCode == 200) {
      return SymptomTipsGem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load tips: ${response.statusCode}');
    }
  }
}
