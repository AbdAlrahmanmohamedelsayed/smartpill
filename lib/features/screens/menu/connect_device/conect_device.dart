import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class ConectDevice extends StatelessWidget {
  const ConectDevice({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))),
        backgroundColor: AppColor.primaryColor,
        toolbarHeight: 80,
        titleTextStyle: theme.appBarTheme.titleTextStyle
            ?.copyWith(color: AppColor.whiteColor),
        title: const Text('Connect Device'),
        leading: const BackButton(
          color: AppColor.whiteColor,
        ),
      ),
    );
  }
}
