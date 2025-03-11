class SymptomTip {
  final String symptom;
  final List<String> tips;

  SymptomTip({required this.symptom, required this.tips});

  factory SymptomTip.fromJson(Map<String, dynamic> json) {
    return SymptomTip(
      symptom: json['symptom'] as String,
      tips: List<String>.from(json['tips'] as List),
    );
  }
}

class TipsResponse {
  final List<SymptomTip> symptoms;

  TipsResponse({required this.symptoms});

  factory TipsResponse.fromJson(Map<String, dynamic> json) {
    return TipsResponse(
      symptoms: (json['symptoms'] as List)
          .map((symptom) => SymptomTip.fromJson(symptom))
          .toList(),
    );
  }
}
