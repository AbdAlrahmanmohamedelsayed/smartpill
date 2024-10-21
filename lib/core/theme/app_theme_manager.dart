import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class AppThemeManager {
  static Color primary = ColorPallets.primaryColor;
  static ThemeData lightThemeManager = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: primary,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showUnselectedLabels: false,
        selectedItemColor: primary,
        backgroundColor: ColorPallets.Colowhite),
    appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primary)),
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
