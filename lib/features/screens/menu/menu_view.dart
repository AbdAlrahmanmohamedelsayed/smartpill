import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/widgets/custom_listTile.dart';
import 'package:smartpill/utils/token_manager.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  String profileName = 'Profile Name'; // Default value
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final tokenData = await TokenManager.getToken();
      final email = tokenData['email'];

      setState(() {
        if (email != null && email.isNotEmpty) {
          profileName = email;
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error loading profile data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
              alignment: Alignment.center,
              height: media.size.height * .190,
              width: media.size.width,
              child: Row(
                children: [
                  const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColor.primaryColor,
                      child: Icon(
                          size: 55, color: AppColor.whiteColor, Icons.person)),
                  const SizedBox(
                    width: 15,
                  ),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: AppColor.primaryColor,
                        )
                      : Expanded(
                          child: Text(
                            profileName,
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                Navigator.pushNamed(context, PageRoutesName.chatView);
              },
              imagePath: 'assets/images/icons/advice.png',
              tittle: ' symptoms guide',
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
            Text(
              'Device',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomListtile(
              onTap: () {
                Navigator.pushNamed(context, PageRoutesName.connectdivice);
              },
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
              imagePath: 'assets/images/icons/device_control.png',
              tittle: 'device Control  ',
            ),
            const SizedBox(
              height: 15,
            ),
            CustomListtile(
              onTap: () {
                Navigator.pushNamed(context, PageRoutesName.configDevice);
              },
              imagePath: 'assets/images/icons/configuration_device.png',
              tittle: 'configuration device',
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
                onPressed: () async {
                  await TokenManager.clearToken(); // Clear the token
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PageRoutesName.login,
                    (route) => false,
                  );
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
