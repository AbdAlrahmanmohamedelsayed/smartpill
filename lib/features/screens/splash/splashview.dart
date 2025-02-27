import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/utils/token_manager.dart';

class Splashview extends StatefulWidget {
  const Splashview({super.key});

  @override
  State<Splashview> createState() => _SplashviewState();
}

class _SplashviewState extends State<Splashview> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, PageRoutesName.onboarding);
    });
  }

  // _navigateToNextScreen();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          width: mediaSize.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(seconds: 1),
                child: Text(
                  'Smart Pill',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.accentGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToNextScreen() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      final tokenData = await TokenManager.getToken();
      final token = tokenData['token'];

      print("Extracted token: $token");

      if (!mounted) return;

      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacementNamed(context, PageRoutesName.home);
      } else {
        Navigator.pushReplacementNamed(context, PageRoutesName.onboarding);
      }
    } catch (e) {
      print('Error in navigation: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, PageRoutesName.onboarding);
      }
    }
  }
}
