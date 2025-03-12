import 'dart:io';
import 'package:flutter/material.dart';

class LayerData {
  String medicineName;
  int totalPills;
  int remainingPills;
  String selectedTone;
  Color layerColor;
  File? medicineImage;

  LayerData({
    required this.medicineName,
    required this.totalPills,
    required this.remainingPills,
    required this.selectedTone,
    required this.layerColor,
    this.medicineImage,
  });
}
