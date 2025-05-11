import 'dart:io';
import 'dart:ui'; // لأجل نوع File

class LayerData {
  final String medicineName;
  final int totalPills;
  final int remainingPills;
  final String selectedTone;
  final Color layerColor;
  final File? medicineImage; // ملف الصورة (يمكن أن يكون null)

  LayerData({
    required this.medicineName,
    required this.totalPills,
    required this.remainingPills,
    required this.selectedTone,
    required this.layerColor,
    this.medicineImage, // غير مطلوب (اختياري)
  });

  LayerData copyWith({
    String? medicineName,
    int? totalPills,
    int? remainingPills,
    String? selectedTone,
    Color? layerColor,
    File? medicineImage,
  }) {
    return LayerData(
      medicineName: medicineName ?? this.medicineName,
      totalPills: totalPills ?? this.totalPills,
      remainingPills: remainingPills ?? this.remainingPills,
      selectedTone: selectedTone ?? this.selectedTone,
      layerColor: layerColor ?? this.layerColor,
      medicineImage: medicineImage ?? this.medicineImage,
    );
  }
}
