import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpill/core/config/appRouter.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/app_theme_manager.dart';
import 'package:smartpill/features/screens/add_pill_reminder/data/medicine-Provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Graduation Project - Smart Pill',
        theme: AppThemeManager.lightThemeManager,
        initialRoute: PageRoutesName.initial,
        onGenerateRoute: AppRouter.onGenerator,
      ),
    );
  }
}
