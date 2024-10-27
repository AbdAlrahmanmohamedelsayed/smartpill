import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/features/screens/settings/widgets/custom_listTile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var media = MediaQuery.of(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          width: media.size.width,
          height: media.size.height * .22,
          alignment: Alignment.center,
          child: Text(
            'Settings',
            style: theme.textTheme.titleLarge,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomListtile(
          onTap: () {
            Navigator.pushNamed(context, PageRoutesName.theme);
          },
          imagePath: 'assets/images/icons/staging.png',
          tittle: 'Theme && languages',
        ),
        const SizedBox(
          height: 20,
        ),
        CustomListtile(
          onTap: () {},
          imagePath: 'assets/images/icons/information.png',
          tittle: 'About As',
        ),
        const SizedBox(
          height: 20,
        ),
        CustomListtile(
          onTap: () {},
          imagePath: 'assets/images/icons/medical-insurance.png',
          tittle: 'Privacy policy',
        ),
      ],
    );
  }
}
