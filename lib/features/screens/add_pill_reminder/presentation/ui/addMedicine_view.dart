import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/add_pill_reminder/presentation/widgets/custom_text_filed.dart';
import 'package:smartpill/model/data_medicine.dart';

class AddMedicineView extends StatefulWidget {
  const AddMedicineView({super.key});

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView> {
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Medicine')),
      body: Padding(
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
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: AppColor.accentGreen),
                  onPressed: _saveMedication,
                  child: Text(
                    'Save',
                    style: theme.textTheme.bodyLarge,
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
      DateTime endDate = _selectedStartDate!.add(Duration(days: days));
      _endDateController.text = DateFormat('yyyy-MM-dd').format(endDate);
    }
  }

  void _generateTimeFields(String value) {
    int count = int.tryParse(value) ?? 0;
    setState(() {
      _medicationTimes = List.generate(count, (index) => null);
    });
  }

  void _updateTimesBasedOnFirst() {
    if (_medicationTimes.isNotEmpty && _medicationTimes[0] != null) {
      TimeOfDay firstTime = _medicationTimes[0]!;
      int interval = (15 * 60) ~/ _medicationTimes.length;
      setState(() {
        for (int i = 1; i < _medicationTimes.length; i++) {
          int newMinutes =
              (firstTime.hour * 60 + firstTime.minute) + (i * interval);
          _medicationTimes[i] =
              TimeOfDay(hour: newMinutes ~/ 60, minute: newMinutes % 60);
        }
      });
    }
  }

  Widget _buildMedicationTimesFields() {
    return Column(
      children: List.generate(_medicationTimes.length, (index) {
        return GestureDetector(
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: _medicationTimes[index] ?? TimeOfDay.now(),
            );
            if (pickedTime != null) {
              setState(() {
                _medicationTimes[index] = pickedTime;
                if (index == 0) _updateTimesBasedOnFirst();
              });
            }
          },
          child: AbsorbPointer(
            child: CustomTextFiled(
              controller: TextEditingController(
                text: _medicationTimes[index]?.format(context) ?? '',
              ),
              label: 'Time ${index + 1}',
              hint: 'Select time',
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2027),
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

  void _saveMedication() {
    if (_formKey.currentState!.validate()) {
      MedicinePill medicine = MedicinePill(
        name: _nameController.text,
        dose: _doseController.text,
        amount: int.parse(_amountController.text),
        days: int.parse(_daysController.text),
        timesPerDay: int.parse(_timesPerDayController.text),
        startDate: _selectedStartDate!,
        endDate: DateTime.parse(_endDateController.text),
        medicationTimes:
            _medicationTimes.map((time) => time!.format(context)).toList(),
      );

      print(medicine.toJson());
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'Medication saved successfully!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColor.accentGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )),
      );
    }
  }
}
