import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class AddmedicineView extends StatefulWidget {
  const AddmedicineView({super.key});

  @override
  State<AddmedicineView> createState() => _AddmedicineViewState();
}

class _AddmedicineViewState extends State<AddmedicineView> {
  var formkey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  @override
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
                        return 'Plase enter  Medicine Name ';
                      }
                      return null;
                    },
                    controller: TextEditingController(),
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
                        return 'Plase enter  Medicine Name ';
                      }
                      return null;
                    },
                    controller: TextEditingController(),
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
                        return 'Plase enter  Medicine Name ';
                      }
                      return null;
                    },
                    controller: TextEditingController(),
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
                    onTap: () => _selectDateTime(context),
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
                      onPressed: () {},
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

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _dateController.text =
              "${fullDateTime.day}/${fullDateTime.month}/${fullDateTime.year}, ${pickedTime.format(context)}";
        });
      }
    }
  }
}
