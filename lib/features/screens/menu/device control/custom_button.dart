import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String imagePath;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        elevation: 9,
        shadowColor: Colors.black.withOpacity(0.9),
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Image.asset(
            width: 60,
            imagePath,
          ),
          const SizedBox(height: 12),
          Text(text, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
