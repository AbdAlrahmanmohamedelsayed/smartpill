class DrugInteraction {
  final int id;
  final String drug1;
  final String drug2;
  final String interactionType;
  final String effect;

  DrugInteraction({
    required this.id,
    required this.drug1,
    required this.drug2,
    required this.interactionType,
    required this.effect,
  });
  factory DrugInteraction.fromJson(Map<String, dynamic> json) {
    return DrugInteraction(
      id: json['id'],
      drug1: json['drug1'],
      drug2: json['drug2'],
      interactionType: json['interactionType'],
      effect: json['effect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'drug1': drug1,
      'drug2': drug2,
      'interactionType': interactionType,
      'effect': effect,
    };
  }
}
