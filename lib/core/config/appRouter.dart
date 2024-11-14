import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/features/layout/layout_view.dart';
import 'package:smartpill/features/screens/Auth/log/Login_view.dart';
import 'package:smartpill/features/screens/add_pill_reminder/addMedicine_view.dart';
import 'package:smartpill/features/screens/menu/HealthMonitoring/health_view.dart';
import 'package:smartpill/features/screens/admin/admin_view.dart';
import 'package:smartpill/features/screens/menu/chatTips/Chat_view.dart';
import 'package:smartpill/features/screens/menu/drug_interaction/drug_interaction_view.dart';
import 'package:smartpill/features/screens/onboarding/onboarding_view.dart';
import 'package:smartpill/features/screens/Auth/signup/signUp_view.dart';
import 'package:smartpill/features/screens/menu/settings/setting_screens/theme_and_lang_view.dart';
import 'package:smartpill/features/screens/menu/settings/settings_view.dart';
import 'package:smartpill/features/screens/splash/splashview.dart';

class AppRouter {
  static Route<dynamic> onGenerator(RouteSettings settings) {
    switch (settings.name) {
      case PageRoutesName.initial:
        return MaterialPageRoute(
            builder: (context) => Splashview(), settings: settings);
      case PageRoutesName.onboarding:
        return MaterialPageRoute(
            builder: (context) => OnboardingView(), settings: settings);
      case PageRoutesName.login:
        return MaterialPageRoute(
            builder: (context) => LoginView(), settings: settings);
      case PageRoutesName.signup:
        return MaterialPageRoute(
            builder: (context) => SignupView(), settings: settings);
      case PageRoutesName.layout:
        return MaterialPageRoute(
            builder: (context) => LayoutView(), settings: settings);
      case PageRoutesName.admin:
        return MaterialPageRoute(
            builder: (context) => AdminView(), settings: settings);
      case PageRoutesName.themeapp:
        return MaterialPageRoute(
            builder: (context) => ThemeandLangView(), settings: settings);
      case PageRoutesName.healthMonitoring:
        return MaterialPageRoute(
            builder: (context) => HealthView(), settings: settings);
      case PageRoutesName.druginteraction:
        return MaterialPageRoute(
            builder: (context) => DrugInteractionView(), settings: settings);
      case PageRoutesName.chatTips:
        return MaterialPageRoute(
            builder: (context) => ChatView(), settings: settings);
      case PageRoutesName.addMedicine:
        return MaterialPageRoute(
            builder: (context) => AddmedicineView(), settings: settings);
      case PageRoutesName.settingView:
        return MaterialPageRoute(
            builder: (context) => SettingsView(), settings: settings);
      default:
        return MaterialPageRoute(
            builder: (context) => Splashview(), settings: settings);
    }
  }
}
