import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/features/screens/onboarding/widgets/custom_image.dart';

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
              fontWeight: FontWeight.bold)),
      trailingFunction: () {
        Navigator.pushNamed(context, PageRoutesName.signup);
      },
      controllerColor: theme.primaryColor,
      totalPage: 4,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      centerBackground: true,
      background: [
        CustomImage(imagePath: 'assets/images/onboard_1.jpg'),
        CustomImage(imagePath: 'assets/images/onboard_2.jpg'),
        CustomImage(imagePath: 'assets/images/onboard_3.jpg'),
        CustomImage(imagePath: 'assets/images/onboard_4.jpg'),
      ],
      speed: 1.9,
      pageBodies: [
        FadeInRight(
          delay: const Duration(seconds: 1),
          child: Container(
            alignment: Alignment.center,
            width: media.size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 480,
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
                const SizedBox(
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
                const SizedBox(
                  height: 480,
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
                const SizedBox(
                  height: 480,
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
                    'Where everything is possible and customize your onboarding.',
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
                const SizedBox(
                  height: 480,
                ),
                Text(
                  'Stay in touch with your loved ones',
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
                    'Share medication status with family members or caregivers in real time..',
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
