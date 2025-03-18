import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xff4A2F88);
  static const Color accentGreen = Color(0xff34D399);
  static const Color accentGold = Color(0xffFFC107);
  static const Color backgroundColor = Color(0xffF2F4F7);
  static const Color whiteColor = Colors.white;
  static const Color textColorPrimary = Color(0xff1A1A1A);
  static const Color textColorSecondary = Color(0xff4B5563);
  static const Color textColorHint = Color(0xff9CA3AF);

  // Alert & Status Colors
  static const Color errorColor = Color(0xffEF4444); // Soft Red for errors
  static const Color successColor =
      accentGreen; // Mint Green for success messages
  static const Color warningColor =
      Color(0xffF59E0B); // Golden-Orange for warnings

  // Button Colors
  static const Color buttonPrimary = primaryColor; // Primary button color
  static const Color buttonSecondary = accentGreen; // Secondary button color

  // Border Colors
  static const Color borderColor =
      Color(0xffD1D5DB); // Soft border color for input fields or cards
}
