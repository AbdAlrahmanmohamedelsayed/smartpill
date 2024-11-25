import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class Builddruginputfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const Builddruginputfield({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<Builddruginputfield> createState() => _BuilddruginputfieldState();
}

class _BuilddruginputfieldState extends State<Builddruginputfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a drug name';
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodySmall,
      controller: widget.controller,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        suffixIcon: const Icon(
          Icons.search,
          color: AppColor.primaryColor,
          size: 22,
        ),
        hintText: widget.hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColor.textColorHint),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.primaryColor),
        ),
      ),
    );
  }
}
