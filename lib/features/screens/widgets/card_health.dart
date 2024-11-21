import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class CardHealth extends StatelessWidget {
  String pathImage = '';
  String title = '';
  final VoidCallback onTap;
  CardHealth({
    super.key,
    required this.onTap,
    required this.pathImage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var media = MediaQuery.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200,
        width: media.size.width * .40,
        decoration: BoxDecoration(
          color: AppColor.whiteColor, // Moved color here
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              pathImage,
              width: 100,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
