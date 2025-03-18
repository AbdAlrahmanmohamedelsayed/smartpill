class SymptomTipsGem {
  final String status;
  final String generatedAt;
  final String source;
  final List<SymptomTipGmini> tips; // Added proper type

  SymptomTipsGem({
    required this.status,
    required this.generatedAt,
    required this.source,
    required this.tips,
  });

  factory SymptomTipsGem.fromJson(Map<String, dynamic> json) {
    // Added proper type
    return SymptomTipsGem(
      status: json['status'],
      generatedAt: json['generatedAt'],
      source: json['source'],
      tips: List<SymptomTipGmini>.from(
          json['tips'].map((tip) => SymptomTipGmini.fromJson(tip))),
    );
  }
}

class SymptomTipGmini {
  final String tip;

  SymptomTipGmini({required this.tip});

  factory SymptomTipGmini.fromJson(String json) {
    return SymptomTipGmini(tip: json);
  }
}
