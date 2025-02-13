import 'package:flutter/material.dart';

class PillReminder{
  final String name;
  final String dosage;
  final String amount;
  final TimeOfDay time;
  PillReminder({
    required this.name,
    required this.dosage,
    required this.amount,
    required this.time,
  });
}
