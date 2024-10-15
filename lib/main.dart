import 'package:flutter/material.dart';
import 'package:smartpill/core/config/appRouter.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/app_theme_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'graduation project Smart pill',
      theme: AppThemeManager.lightThemeManager,
      initialRoute: PageRoutesName.initial,
      onGenerateRoute: AppRouter.onGenerator,
    );
  }
}
