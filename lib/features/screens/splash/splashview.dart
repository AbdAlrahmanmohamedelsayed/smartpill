import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';

class Splashview extends StatefulWidget {
  const Splashview({super.key});

  @override
  State<Splashview> createState() => _SplashviewState();
}

class _SplashviewState extends State<Splashview> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, PageRoutesName.onboarding);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var media = MediaQuery.of(context);
    return Center(
      child: Container(
        width: media.size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              delay: Duration(seconds: 1),
              child: Image.asset(
                'assets/images/logo.jpg',
                width: 70,
              ),
            ),
            FadeInUp(
              child: Text(
                'Smart Pill',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
