import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String imagePath;
  CustomImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 250),
      child: Container(
          height: 380,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          )),
    );
  }
}
