import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/add_pill_reminder/data/medicine-Provider.dart';
import 'package:smartpill/features/screens/add_pill_reminder/presentation/widgets/custom_text_filed.dart';
import 'package:smartpill/model/data_medicine.dart';

class EditMedicineView extends StatefulWidget {
  final MedicinePill medicine;

  const EditMedicineView({super.key, required this.medicine});

  @override
  State<EditMedicineView> createState() => _EditMedicineViewState();
}

class _EditMedicineViewState extends State<EditMedicineView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _timesPerDayController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _selectedStartDate;
  List<TimeOfDay?> _medicationTimes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.medicine.name;
    _doseController.text = widget.medicine.dose;
    _amountController.text = widget.medicine.amount.toString();
    _daysController.text = widget.medicine.numberOfDays.toString();
    _timesPerDayController.text = widget.medicine.timesPerDay.toString();
    _selectedStartDate = widget.medicine.startDate;
    _dateController.text =
        DateFormat('yyyy-MM-dd').format(widget.medicine.startDate);
    _endDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.medicine.endDate);
    _medicationTimes = List<TimeOfDay?>.from(widget.medicine.reminderTimes);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Medicine')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextFiled(
                        controller: _nameController,
                        label: 'Name*',
                        hint: 'Name (e.g. Ibuprofen)',
                      ),
                      CustomTextFiled(
                        controller: _doseController,
                        label: 'Dose*',
                        hint: 'Dose (e.g. 100mg)',
                        isNumeric: true,
                      ),
                      CustomTextFiled(
                        controller: _amountController,
                        label: 'Amount*',
                        hint: 'Amount (e.g. 3)',
                        isNumeric: true,
                      ),
                      CustomTextFiled(
                        controller: _daysController,
                        label: 'Number of Days*',
                        hint: 'Days (e.g. 7)',
                        isNumeric: true,
                        onChanged: (value) => _updateEndDate(value),
                      ),
                      CustomTextFiled(
                        controller: _timesPerDayController,
                        label: 'Times per Day*',
                        hint: 'Times (e.g. 3)',
                        isNumeric: true,
                        onChanged: (value) => _generateTimeFields(value),
                      ),
                      _buildDateField(),
                      CustomTextFiled(
                        isEnabled: false,
                        controller: _endDateController,
                        label: 'End Date',
                        hint: 'Auto-calculated',
                      ),
                      const SizedBox(height: 20),
                      if (_medicationTimes.isNotEmpty) ...[
                        Text(
                          "Medication Times:",
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        _buildMedicationTimesFields(),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: AppColor.primaryColor),
                        onPressed: _updateMedication,
                        child: Text(
                          'Update',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _updateEndDate(String value) {
    if (_selectedStartDate != null && value.isNotEmpty) {
      int days = int.tryParse(value) ?? 0;
      if (days > 0) {
        DateTime endDate = _selectedStartDate!.add(Duration(days: days));
        _endDateController.text = DateFormat('yyyy-MM-dd').format(endDate);
      }
    }
  }

  void _generateTimeFields(String value) {
    int count = int.tryParse(value) ?? 0;
    if (count > 0) {
      setState(() {
        _medicationTimes = List.generate(count, (index) => null);
        _updateTimesBasedOnFirst();
      });
    }
  }

  void _updateTimesBasedOnFirst() {
    if (_medicationTimes.isNotEmpty) {
      // Set first time to 9:00 AM if not already set
      TimeOfDay firstTime =
          _medicationTimes[0] ?? const TimeOfDay(hour: 9, minute: 0);

      // Calculate interval between doses (15 hours / number of doses)
      double intervalHours = 15.0 / _medicationTimes.length;
      int intervalMinutes = (intervalHours * 60).round();

      setState(() {
        for (int i = 0; i < _medicationTimes.length; i++) {
          int totalMinutes =
              firstTime.hour * 60 + firstTime.minute + (i * intervalMinutes);
          int hour = (totalMinutes ~/ 60) % 24;
          int minute = totalMinutes % 60;

          // Ensure time doesn't go past 11:59 PM
          if (hour < 24) {
            _medicationTimes[i] = TimeOfDay(hour: hour, minute: minute);
          }
        }
      });
    }
  }

  Widget _buildMedicationTimesFields() {
    return Column(
      children: List.generate(_medicationTimes.length, (index) {
        return CustomTimePickerButton(
          label: 'Time ${index + 1}*',
          selectedTime: _medicationTimes[index],
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: _medicationTimes[index] ?? TimeOfDay.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColor.primaryColor,
                      onPrimary: AppColor.whiteColor,
                      surface: AppColor.whiteColor,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColor.primaryColor,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedTime != null) {
              setState(() {
                _medicationTimes[index] = pickedTime;
                // If first time is changed, recalculate all times
                if (index == 0) {
                  _updateTimesBasedOnFirst();
                }
              });
            }
          },
        );
      }),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedStartDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2027),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColor.primaryColor,
                  onPrimary: AppColor.whiteColor,
                  surface: AppColor.whiteColor,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColor.primaryColor,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          setState(() {
            _selectedStartDate = pickedDate;
            _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            _updateEndDate(_daysController.text);
          });
        }
      },
      child: AbsorbPointer(
        child: CustomTextFiled(
          controller: _dateController,
          label: 'Start Date*',
          hint: 'Select start date',
        ),
      ),
    );
  }

  bool _validateTimes() {
    if (_medicationTimes.isEmpty) return false;
    for (TimeOfDay? time in _medicationTimes) {
      if (time == null) return false;
    }
    return true;
  }

  void _updateMedication() async {
    if (_formKey.currentState!.validate() && _validateTimes()) {
      setState(() {
        _isLoading = true;
      });

      MedicinePill updatedMedicine = MedicinePill(
        id: widget.medicine.id,
        name: _nameController.text,
        dose: _doseController.text,
        amount: int.parse(_amountController.text),
        numberOfDays: int.parse(_daysController.text),
        timesPerDay: int.parse(_timesPerDayController.text),
        startDate: _selectedStartDate!,
        endDate: DateTime.parse(_endDateController.text),
        reminderTimes: List<TimeOfDay>.from(_medicationTimes),
      );

      final medicineProvider =
          Provider.of<MedicineProvider>(context, listen: false);
      bool success = await medicineProvider.updateMedicine(updatedMedicine);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pop(context);
              Navigator.pop(context);
            });

            return Dialog(
              surfaceTintColor: AppColor.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Medicine updated successfully!',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColor.accentGreen),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColor.whiteColor,
            content: Text(
              'Failed to update medicine',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColor.errorColor),
            ),
          ),
        );
      }
    }
  }
}

class CustomTimePickerButton extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final String label;
  final VoidCallback? onTap;

  const CustomTimePickerButton({
    super.key,
    required this.selectedTime,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColor.primaryColor.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.primaryColor,
              ),
            ),
            Text(
              selectedTime != null
                  ? selectedTime!.format(context)
                  : 'Select time',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: selectedTime != null
                    ? AppColor.textColorPrimary
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
