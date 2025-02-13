import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

import '../../../model/PillReminder.dart';

class AddmedicineView extends StatefulWidget {
  final Function(PillReminder) onSave;
  const AddmedicineView({super.key, required this.onSave});

  @override
  State<AddmedicineView> createState() => _AddmedicineViewState();
}

class _AddmedicineViewState extends State<AddmedicineView> {
  DateTime? _selectDateTime;
  var formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _savePillReminder() {
    if (formkey.currentState!.validate()) {
      if (_selectDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date and time')),
        );
        return; // Stop execution if date is not set
      }
      final pillReminder = PillReminder(
        name: _nameController.text,
        dosage: _doseController.text,
        amount: _amountController.text,
        time: TimeOfDay.fromDateTime(_selectDateTime!),
      );
      print("Saving pill reminder: ${pillReminder.name}, ${pillReminder.dosage}, ${pillReminder.amount}, ${pillReminder.time.format(context)}"); // Debug log
      widget.onSave(pillReminder); // Pass the reminder to the parent widget
      print("✅ Step 2: widget.onSave() was called! Returning to HomeView..."); // Debug log
      Navigator.pop(context); // Close the form and go back to the home page
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to avoid memory leaks
    _nameController.dispose();
    _doseController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Medicine')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Fill out the fields and hit the \n Save Button to add it!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColor.textColorHint,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  Text(
                    'Name*',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter Medicine Name ';
                      }
                      return null;
                    },
                    controller: _nameController,
                    cursorColor: theme.primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Name (e.g. Ibuprofen)',
                      hintStyle: theme.textTheme.bodySmall?.copyWith(
                        color: AppColor.textColorHint,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.primaryColor),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  Text(
                    'Dose*',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter Medicine dose ';
                      }
                      return null;
                    },
                    controller: _doseController,
                    cursorColor: theme.primaryColor,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Dose (e.g. 100mg)',
                      hintStyle: theme.textTheme.bodySmall?.copyWith(
                        color: AppColor.textColorHint,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.primaryColor),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  Text(
                    'Amount*',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter Medicine amount ';
                      }
                      return null;
                    },
                    controller: _amountController,
                    cursorColor: theme.primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Dose (e.g. 3)',
                      hintStyle: theme.textTheme.bodySmall?.copyWith(
                        color: AppColor.textColorHint,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.primaryColor),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    'Reminders*',
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    'Date',
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextField(
                    style: theme.textTheme.bodySmall,
                    onTap: () => _selectDateTimePicker(context),
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'dd/mm/yyyy, 00:00 Pm',
                      hintStyle: theme.textTheme.bodySmall?.copyWith(
                        color: AppColor.textColorHint,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.primaryColor),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.accentGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                      onPressed: () {
                        _savePillReminder();
                      },
                      child: Text(
                        'Save',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white),
                      )),
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTimePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          _dateController.text =
          "${_selectDateTime!.day}/${_selectDateTime!.month}/${_selectDateTime!.year}, ${pickedTime.format(context)}";
          print("Date selected: $_selectDateTime");
        });
      }
    }
  }
}
