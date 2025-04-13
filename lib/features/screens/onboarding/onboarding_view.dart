import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:lottie/lottie.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var media = MediaQuery.of(context);
    return OnBoardingSlider(
      finishButtonText: 'LogIn',
      onFinish: () {
        Navigator.pushNamed(context, PageRoutesName.login);
      },
      finishButtonStyle: FinishButtonStyle(
          backgroundColor: theme.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      skipTextButton: Text('Skip',
          style:
              theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor)),
      trailing: Text('Register',
          style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 20,
              color: theme.primaryColor,
              fontWeight: FontWeight.w700)),
      trailingFunction: () {
        Navigator.pushNamed(context, PageRoutesName.signup);
      },
      controllerColor: theme.primaryColor,
      totalPage: 4,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      centerBackground: true,
      background: [
        Padding(
          padding: const EdgeInsets.only(top: 45.0),
          child:
              Lottie.asset(width: 250, 'assets/images/Lottie/onboarding1.json'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 45.0),
          child:
              Lottie.asset(width: 250, 'assets/images/Lottie/onboarding2.json'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 45.0),
          child:
              Lottie.asset(width: 250, 'assets/images/Lottie/onboarding3.json'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 45.0),
          child: Lottie.asset(width: 200, 'assets/images/Lottie/on_4.json'),
        ),
      ],
      speed: 1.9,
      pageBodies: [
        FadeInRight(
          delay: const Duration(milliseconds: 500),
          child: Container(
            alignment: Alignment.center,
            width: media.size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: media.size.height * 0.6,
                ),
                Text(
                  'Welcome to Smart Pill...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Smart medicine dispenser helps you organize your medicine schedule in easy and safe ways.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
        FadeInRight(
          delay: const Duration(microseconds: 700),
          child: Container(
            alignment: Alignment.center,
            width: media.size.width,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: media.size.height * 0.6,
                ),
                Text(
                  'Never forget your dose again!.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    'Automatic reminders help you stick to your medication schedule without any worries.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
        FadeInRight(
          delay: const Duration(microseconds: 700),
          child: Container(
            alignment: Alignment.center,
            width: media.size.width,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: media.size.height * 0.6,
                ),
                Text(
                  'Track your health easily',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    'Monitor your medication intake and share reports with your caregiver or doctor.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
        FadeInRight(
          delay: const Duration(microseconds: 700),
          child: Container(
            alignment: Alignment.center,
            width: media.size.width,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: media.size.height * 0.6,
                ),
                Text(
                  'AI-Powered Medication Tips',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    'Get personalized, AI-driven advice tailored to your medication needs.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
