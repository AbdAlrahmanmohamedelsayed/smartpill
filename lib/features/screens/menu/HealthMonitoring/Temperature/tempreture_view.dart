import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class TempretureView extends StatelessWidget {
  const TempretureView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
        ),
        backgroundColor: AppColor.primaryColor,
        toolbarHeight: 80,
        titleTextStyle: theme.appBarTheme.titleTextStyle
            ?.copyWith(color: AppColor.whiteColor),
        title: const Text('Tempreture'),
        leading: const BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
        child: Column(
          children: [
            Text(
              maxLines: 2,
              '1-Gently place your finger on the sensor Make sure your finger completely covers the sensor to ensure an accurate reading',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              maxLines: 2,
              '2-Stay still during measurement Avoid any movement during the process to get an accurate result.g..',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              height: 300,
              decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ]),
              child:
                  Lottie.asset(width: 400, 'assets/images/Lottie/temper.json'),
            ),
          ],
        ),
      ),
    );
  }
}
