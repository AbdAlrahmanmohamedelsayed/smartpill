import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 20),
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  color: Colors
                      .grey, // استبدل بـ AppColor.textColorHint إذا كانت متاحة
                  fontSize: 18,
                ),
                hintText: "How Are You Feeling At The Moment",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.blue, // استبدل بـ AppColor.primaryColor
                        width: 2.0,
                        style: BorderStyle.solid)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.blue, // استبدل بـ AppColor.primaryColor
                        width: 2.0,
                        style: BorderStyle.solid)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                        style: BorderStyle.solid)),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              size: 32,
            ),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSend(controller.text);
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
