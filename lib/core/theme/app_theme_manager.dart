import 'package:flutter/material.dart';

class AppThemeManager {
  static ThemeData lightThemeManager = ThemeData(
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Exo'),
      bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w600,
          fontFamily: 'Exo'),
      bodySmall: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontFamily: 'Exo'),
    ),
  );
}
