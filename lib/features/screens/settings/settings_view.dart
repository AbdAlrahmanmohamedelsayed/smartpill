import 'package:flutter/material.dart';
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
          width: media.size.width,
          height: media.size.height * .20,
          color: theme.primaryColor,
          alignment: Alignment.center,
          child: Text(
            'Settings',
            style: theme.textTheme.titleLarge,
          ),
        ),
        CustomListtile(
          onTap: () {},
          imagePath: 'assets/images/icons/theme.png',
          tittle: 'Theme Mode',
        ),
        const SizedBox(
          height: 20,
        ),
        CustomListtile(
            onTap: () {},
            imagePath: 'assets/images/icons/languages.png',
            tittle: 'languages'),
        const SizedBox(
          height: 20,
        ),
        CustomListtile(
          onTap: () {},
          imagePath: 'assets/images/icons/information.png',
          tittle: 'About As',
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
