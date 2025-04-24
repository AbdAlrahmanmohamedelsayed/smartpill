import 'package:intl/intl.dart';

class VitalsMeasurement {
  final double oxygenLevel;
  final int heartRate;
  final DateTime timestamp;

  VitalsMeasurement(
      {required this.oxygenLevel,
      required this.heartRate,
      required this.timestamp});

  String get formattedDate => DateFormat('yyyy-MM-dd').format(timestamp);
  String get formattedTime => DateFormat('HH:mm:ss').format(timestamp);
}
