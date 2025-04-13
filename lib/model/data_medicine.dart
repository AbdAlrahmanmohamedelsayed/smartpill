import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicinePill {
  String? id;
  String name;
  String dose;
  int amount;
  int numberOfDays;
  int timesPerDay;
  DateTime startDate;
  DateTime endDate;
  List<TimeOfDay> reminderTimes;

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
      if (id != null && !id!.startsWith('local_')) "id": id,
      "name": name,
      "dose": dose,
      "amount": amount,
      "numberOfDays": numberOfDays,
      "timesPerDay": timesPerDay,
      "startDate": DateFormat('yyyy-MM-dd').format(startDate),
      "endDate": DateFormat('yyyy-MM-dd').format(endDate),
      "reminderTimes":
          reminderTimes.map((time) => _formatTimeTo12Hour(time)).toList(),
    };
  }

  factory MedicinePill.fromJson(Map<String, dynamic> json) {
    return MedicinePill(
      id: json["id"]?.toString(),
      name: json["name"] ?? "",
      dose: json["dose"] ?? "",
      amount: json["amount"] ?? 0,
      numberOfDays: json["numberOfDays"] ?? 0,
      timesPerDay: json["timesPerDay"] ?? 0,
      startDate: json["startDate"] is String
          ? DateTime.parse(json["startDate"])
          : DateTime.now(),
      endDate: json["endDate"] is String
          ? DateTime.parse(json["endDate"])
          : DateTime.now().add(const Duration(days: 1)),
      reminderTimes: _parseReminderTimes(json["reminderTimes"]),
    );
  }

  static List<TimeOfDay> _parseReminderTimes(dynamic times) {
    if (times == null) return [];

    if (times is List) {
      return times.map((time) => _stringToTimeOfDay(time.toString())).toList();
    }
    return [];
  }

  static String _formatTimeTo12Hour(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dateTime); // تحويل إلى 12 ساعة
  }

  static TimeOfDay _stringToTimeOfDay(String timeString) {
    try {
      timeString = timeString.trim();

      bool hasPeriod = timeString.toLowerCase().contains('ص') ||
          timeString.toLowerCase().contains('م') ||
          timeString.toLowerCase().contains('am') ||
          timeString.toLowerCase().contains('pm');

      int hour;
      int minute;

      if (hasPeriod) {
        RegExp regex =
            RegExp(r'(\d+):(\d+)\s*(ص|م|am|pm)', caseSensitive: false);
        var match = regex.firstMatch(timeString);

        if (match != null) {
          hour = int.parse(match.group(1)!);
          minute = int.parse(match.group(2)!);
          String period = match.group(3)!.toLowerCase();

          if ((period == 'م' || period == 'pm') && hour != 12) {
            hour += 12;
          } else if ((period == 'ص' || period == 'am') && hour == 12) {
            hour = 0;
          }
        } else {
          return const TimeOfDay(hour: 8, minute: 0);
        }
      } else {
        List<String> parts = timeString.split(':');
        hour = int.parse(parts[0]);
        minute = int.parse(parts[1]);
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      debugPrint('Error parsing time: $e for string: $timeString');
      return const TimeOfDay(hour: 8, minute: 0);
    }
  }

  MedicinePill copyWith({
    String? id,
    String? name,
    String? dose,
    int? amount,
    int? numberOfDays,
    int? timesPerDay,
    DateTime? startDate,
    DateTime? endDate,
    List<TimeOfDay>? reminderTimes,
  }) {
    return MedicinePill(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      amount: amount ?? this.amount,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reminderTimes: reminderTimes ?? List.from(this.reminderTimes),
    );
  }

  bool isActiveToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !startDate.isAfter(today) && !endDate.isBefore(today);
  }

  int getRemainingDays() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (endDate.isBefore(today)) return 0;
    return endDate.difference(today).inDays + 1;
  }

  int getTotalPillsRemaining() {
    return getRemainingDays() * timesPerDay * amount;
  }

  bool get isLocalOnly => id != null && id!.startsWith('local_');

  @override
  String toString() {
    return 'MedicinePill(id: $id, name: $name, dose: $dose)';
  }
}
