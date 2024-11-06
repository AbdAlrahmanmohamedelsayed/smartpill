import 'package:flutter/material.dart';

// class ColorPallets {
//   static const Color primaryColor = Color(0xff4193CC);
//   static const Color redColor = Colors.red;
//   static const Color Colowhite = Colors.white;
// }

class AppColor {
  // Primary Colors
  static const Color primaryColor = Color(0xff77AADD);
  static const Color accentGreen =
      Color(0xff34D399); // Mint Green for success elements
  static const Color accentGold =
      Color(0xffFFC107); // Soft Yellow-Gold for highlights and warnings

  // Neutral Colors
  static const Color backgroundColor =
      Color(0xffF2F4F7); // Very Light Gray for background
  static const Color whiteColor = Colors.white; // White for clean areas

  // Text Colors
  static const Color textColorPrimary =
      Color(0xff1A1A1A); // Deep Gray for main text
  static const Color textColorSecondary =
      Color(0xff4B5563); // Muted Gray for subtitles
  static const Color textColorHint =
      Color(0xff9CA3AF); // Soft Gray for hint or placeholder text

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
