import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/features/screens/log/Login_view.dart';
import 'package:smartpill/features/screens/onboarding/onboarding_view.dart';
import 'package:smartpill/features/screens/signup/signUp_view.dart';
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
      default:
        return MaterialPageRoute(
            builder: (context) => Splashview(), settings: settings);
    }
  }
}
