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
    return ListTile(
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
    );
  }
}
