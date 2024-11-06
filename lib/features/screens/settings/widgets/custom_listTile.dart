import 'package:flutter/material.dart';

class CustomListtile extends StatelessWidget {
  final String imagePath;
  final String tittle;
  final VoidCallback onTap;
  const CustomListtile(
      {required this.onTap,
      required this.imagePath,
      required this.tittle,
      super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset(width: 40, imagePath),
        title: Text(
          tittle,
          style: theme.textTheme.bodyMedium,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 22,
        ),
        onTap: onTap,
      ),
    );
  }
}
