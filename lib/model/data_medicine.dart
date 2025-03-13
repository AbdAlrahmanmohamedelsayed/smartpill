class MedicinePill {
  final int? id;
  final String name;
  final String dose;
  final int amount;
  final int numberOfDays;
  final int timesPerDay;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> reminderTimes;

  MedicinePill({
    this.id,
    required this.name,
    required this.dose,
    required this.amount,
    required this.numberOfDays,
    required this.timesPerDay,
    required this.startDate,
    required this.endDate,
    required this.reminderTimes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'amount': amount,
      'numberOfDays': numberOfDays,
      'timesPerDay': timesPerDay,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reminderTimes': reminderTimes,
    };
  }

  factory MedicinePill.fromJson(Map<String, dynamic> map) {
    return MedicinePill(
      id: map['id'],
      name: map['name'],
      dose: map['dose'],
      amount: map['amount'],
      numberOfDays: map['numberOfDays'],
      timesPerDay: map['timesPerDay'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      reminderTimes: List<String>.from(map['reminderTimes']),
    );
  }
}
