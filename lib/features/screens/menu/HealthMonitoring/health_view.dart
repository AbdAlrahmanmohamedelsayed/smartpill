import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/menu/HealthMonitoring/Oxygen/Oxygen_view.dart';
import 'package:smartpill/features/screens/widgets/card_health.dart';

class HealthView extends StatefulWidget {
  const HealthView({super.key});

  @override
  State<HealthView> createState() => _HealthViewState();
}

class _HealthViewState extends State<HealthView> {
  bool isSeletedOxygen = false;
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
        title: const Text('Health Monitoring'),
        leading: const BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: isSeletedOxygen == false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Vital Signs Monitoring:',
                      style: theme.textTheme.bodyMedium),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CardHealth(
                      onTap: () {
                        setState(() {
                          isSeletedOxygen = !isSeletedOxygen;
                        });
                      },
                      pathImage: 'assets/images/icons/oxygen-saturation.png',
                      title: 'Oxygen ',
                    ),
                    CardHealth(
                      onTap: () {},
                      pathImage: 'assets/images/icons/temperature.png',
                      title: 'Temperature ',
                    ),
                  ],
                ),
              ],
            )
          : OxygenView(),
    );
  }
}
