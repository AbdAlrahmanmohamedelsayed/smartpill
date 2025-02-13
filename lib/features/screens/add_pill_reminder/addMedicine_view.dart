import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/model/data_medicine.dart';

class AddmedicineView extends StatefulWidget {
  const AddmedicineView({super.key});

  @override
  State<AddmedicineView> createState() => _AddmedicineViewState();
}

class _AddmedicineViewState extends State<AddmedicineView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var screenSize = MediaQuery.of(context).size;

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
                Text(
                  'Fill out the fields and hit the Save Button to add it!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColor.textColorHint,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),

                _buildTextField(
                  controller: _nameController,
                  label: 'Name*',
                  hint: 'Name (e.g. Ibuprofen)',
                ),

                // Dose Field
                _buildTextField(
                  controller: _doseController,
                  label: 'Dose*',
                  hint: 'Dose (e.g. 100mg)',
                  isNumeric: true,
                ),

                // Amount Field
                _buildTextField(
                  controller: _amountController,
                  label: 'Amount*',
                  hint: 'Amount (e.g. 3)',
                  isNumeric: true,
                ),

                SizedBox(height: screenSize.height * 0.02),
                Text('Reminders*', style: theme.textTheme.bodyMedium),
                SizedBox(height: screenSize.height * 0.02),

                // Date Field
                _buildDateField(),

                SizedBox(height: screenSize.height * 0.03),

                // Save Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.accentGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: _saveMedicine,
                  child: Text(
                    'Save',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isNumeric = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter $label'
              : null,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }

  // Date Picker Field
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 5),
        TextField(
          style: Theme.of(context).textTheme.bodySmall,
          controller: _dateController,
          readOnly: true,
          onTap: () => _selectDateTime(context),
          decoration: InputDecoration(
            hintText: 'dd/mm/yyyy, 00:00 PM',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }

  // Date and Time Picker
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
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
          _selectedDateTime = fullDateTime;
          _dateController.text =
              "${fullDateTime.day}/${fullDateTime.month}/${fullDateTime.year}, ${pickedTime.format(context)}";
        });
      }
    }
  }

  // Save Medicine Data
  void _saveMedicine() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date and time')),
        );
        return;
      }

      final medicine = Medicine(
        name: _nameController.text.trim(),
        dose: _doseController.text.trim(),
        amount: int.parse(_amountController.text.trim()),
        dateTime: _selectedDateTime!,
      );

      int pillsPerDay = (medicine.amount / 7).ceil();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medicine saved! Pills per day: $pillsPerDay')),
      );
    }
  }
}
