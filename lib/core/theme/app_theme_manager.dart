import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class AppThemeManager {
  static Color primary = AppColor.primaryColor;
  static ThemeData lightThemeManager = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: primary,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showUnselectedLabels: false,
      selectedItemColor: primary,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: StadiumBorder(side: BorderSide(width: 5, color: primary)),
    ),
    appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primary)),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Exo'),
      bodyLarge: TextStyle(
          color: AppColor.textColorPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Exo'),
      bodyMedium: TextStyle(
          color: AppColor.textColorPrimary,
          fontSize: 25,
          fontWeight: FontWeight.w600,
          fontFamily: 'Exo'),
      bodySmall: TextStyle(
          color: AppColor.textColorPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontFamily: 'Exo'),
    ),
  );
}
