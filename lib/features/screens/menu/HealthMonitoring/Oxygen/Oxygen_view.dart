import 'package:flutter/material.dart';

import 'package:smartpill/core/theme/color_pallets.dart';

class OxygenView extends StatefulWidget {
  const OxygenView({super.key});

  @override
  State<OxygenView> createState() => _OxygenViewState();
}

class _OxygenViewState extends State<OxygenView> {
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
        title: const Text('Oxygen'),
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
              '1-Gently place your finger on the sensor so that it covers it completely.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              maxLines: 2,
              '2-Stay still and do not move while measuring..',
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
              child: Image.asset(width: 260, 'assets/images/icons/oxygen.png'),
            ),
          ],
        ),
      ),
    );
  }
}
