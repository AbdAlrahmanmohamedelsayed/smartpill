class MedicinePill {
  final int? id;
  final String name;
  final String dose;
  final int amount;
  final int days;
  final int timesPerDay;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> medicationTimes;

  MedicinePill({
    this.id,
    required this.name,
    required this.dose,
    required this.amount,
    required this.days,
    required this.timesPerDay,
    required this.startDate,
    required this.endDate,
    required this.medicationTimes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'amount': amount,
      'days': days,
      'timesPerDay': timesPerDay,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'medicationTimes': medicationTimes,
    };
  }

  factory MedicinePill.fromJson(Map<String, dynamic> map) {
    return MedicinePill(
      id: map['id'],
      name: map['name'],
      dose: map['dose'],
      amount: map['amount'],
      days: map['days'],
      timesPerDay: map['timesPerDay'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      medicationTimes: List<String>.from(map['medicationTimes']),
    );
  }
}
