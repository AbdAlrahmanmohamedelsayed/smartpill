import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/widgets/card_health.dart';

class ChatViwe extends StatelessWidget {
  const ChatViwe({super.key});

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
        title: const Text(' Tips'),
        leading: const BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardHealth(
                onTap: () {
                  Navigator.pushNamed(context, PageRoutesName.chatTips);
                },
                pathImage: 'assets/images/icons/tips.png',
                title: 'Tips'),
            const SizedBox(
              width: 20,
            ),
            CardHealth(
                onTap: () {},
                pathImage: 'assets/images/icons/chat-tips-gim.png',
                title: 'Gemini'),
          ],
        ),
      ),
    );
  }
}
