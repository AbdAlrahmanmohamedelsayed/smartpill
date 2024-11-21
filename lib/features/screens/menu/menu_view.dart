import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/widgets/custom_listTile.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var media = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomCenter,
              height: media.size.height * .2,
              width: media.size.width,
              child: Row(
                children: [
                  const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColor.primaryColor,
                      child: Icon(
                          size: 60, color: AppColor.whiteColor, Icons.person)),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Profile Name',
                    style: theme.textTheme.bodyMedium,
                  )
                ],
              ),
            ),
            CustomListtile(
              onTap: () {},
              imagePath: 'assets/images/icons/sharing.png',
              tittle: 'Share Smart Pill',
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              height: 4,
              thickness: 2,
              color: theme.primaryColor,
            ),
            Text(
              'Health',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 12,
            ),
            CustomListtile(
              onTap: () {
                Navigator.pushNamed(context, PageRoutesName.healthMonitoring);
              },
              imagePath: 'assets/images/icons/healthcare.png',
              tittle: 'Health Monitoring',
            ),
            const SizedBox(
              height: 12,
            ),
            CustomListtile(
              onTap: () {
                Navigator.pushNamed(context, PageRoutesName.chatTips);
              },
              imagePath: 'assets/images/icons/advice.png',
              tittle: 'your symptoms guide',
            ),
            const SizedBox(
              height: 12,
            ),
            CustomListtile(
              onTap: () {
                Navigator.pushNamed(context, PageRoutesName.druginteraction);
              },
              imagePath: 'assets/images/icons/druginteraction.png',
              tittle: 'Check drug interaction',
            ),
            const SizedBox(
              height: 15,
            ),
            Divider(
              height: 4,
              thickness: 2,
              color: theme.primaryColor,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomListtile(
              onTap: () {},
              imagePath: 'assets/images/icons/smart-device.png',
              tittle: 'connect device',
            ),
            const SizedBox(
              height: 15,
            ),
            CustomListtile(
              onTap: () {
                Navigator.pushNamed(context, PageRoutesName.testmm);
              },
              imagePath: 'assets/images/icons/smart-device.png',
              tittle: 'Test Test',
            ),
            const SizedBox(
              height: 15,
            ),
            Divider(
              height: 4,
              thickness: 2,
              color: theme.primaryColor,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomListtile(
              onTap: () {
                Navigator.pushNamed(context, PageRoutesName.settingView);
              },
              imagePath: 'assets/images/icons/setting.png',
              tittle: 'Setting App',
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                            width: 3, color: AppColor.primaryColor)),
                    backgroundColor: AppColor.whiteColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 22)),
                onPressed: () {
                  Navigator.pushNamed(context, PageRoutesName.login);
                },
                child: Row(
                  children: [
                    Image.asset(width: 30, 'assets/images/icons/check-out.png'),
                    const SizedBox(
                      width: 22,
                    ),
                    Text(
                      'Logout',
                      style: theme.textTheme.bodyMedium,
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
