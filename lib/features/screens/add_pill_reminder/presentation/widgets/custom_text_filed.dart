import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class CustomTextFiled extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isNumeric;
  final Function(String)? onChanged;

  CustomTextFiled({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isNumeric = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 5),
        TextFormField(
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter $label'
              : null,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodySmall
                ?.copyWith(fontSize: 18, color: AppColor.textColorHint),
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
}
