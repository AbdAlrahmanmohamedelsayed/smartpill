import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class InputFieldChat extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;

  const InputFieldChat({
    Key? key,
    required this.controller,
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 16),
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: AppColor.textColorHint, fontSize: 16),
                hintText: "How are you feeling?",
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColor.primaryColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColor.primaryColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColor.primaryColor, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon:
                const Icon(Icons.send, size: 28, color: AppColor.primaryColor),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSend(controller.text.trim());
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
