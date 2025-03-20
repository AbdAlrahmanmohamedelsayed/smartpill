import 'package:flutter/material.dart';
import 'package:smartpill/features/screens/add_pill_reminder/manager/api_medicine.dart';
import 'package:smartpill/model/data_medicine.dart';

class MedicineProvider extends ChangeNotifier {
  final MedicineService _medicineService = MedicineService();
  List<MedicinePill> _medicines = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MedicinePill> get medicines => List.unmodifiable(_medicines);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MedicineProvider() {
    loadMedicines();
  }

  // Get medicines filtered by date
  List<MedicinePill> getMedicinesByDate(DateTime date) {
    final selectedDate = DateTime(date.year, date.month, date.day);

    return _medicines.where((medicine) {
      final startDate = DateTime(
        medicine.startDate.year,
        medicine.startDate.month,
        medicine.startDate.day,
      );
      final endDate = DateTime(
        medicine.endDate.year,
        medicine.endDate.month,
        medicine.endDate.day,
      );

      return !selectedDate.isBefore(startDate) &&
          !selectedDate.isAfter(endDate);
    }).toList();
  }

  Future<void> loadMedicines() async {
    _setLoading(true);
    try {
      _medicines = await _medicineService.getAllMedicines();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load medicines: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addMedicine(MedicinePill medicine) async {
    return _handleMedicineOperation(
        () async => await _medicineService.addMedicine(medicine));
  }

  Future<bool> updateMedicine(MedicinePill medicine) async {
    return _handleMedicineOperation(
        () async => await _medicineService.updateMedicine(medicine));
  }

  Future<bool> deleteMedicine(String id) async {
    return _handleMedicineOperation(() async {
      bool success = await _medicineService.deleteMedicine(id);
      if (success) {
        debugPrint('Medicine deleted successfully');
        await loadMedicines();
      } else {
        debugPrint('Failed to delete medicine');
      }
      notifyListeners();
      return success;
    });
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _handleMedicineOperation(
      Future<bool> Function() operation) async {
    _setLoading(true);
    try {
      bool success = await operation();
      if (success) {
        await loadMedicines();
      } else {
        _setError('Operation failed: Unknown error');
      }
      return success;
    } catch (e) {
      _setError('Operation failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
