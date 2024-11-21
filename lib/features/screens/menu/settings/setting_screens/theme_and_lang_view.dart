import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

// ignore: must_be_immutable
class ThemeandLangView extends StatelessWidget {
  List<String> themeList = ['Light', 'Dark'];
  List<String> langList = ['English', 'عربي'];
  ThemeandLangView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var media = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            width: media.size.width,
            height: media.size.height * .22,
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.white,
                    )),
                const SizedBox(
                  width: 40,
                ),
                Text(
                  'Theme && language ',
                  style: theme.textTheme.titleLarge,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                Image.asset(width: 40, 'assets/images/icons/theme.png'),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Theme Mode:',
                  style: theme.textTheme.bodyLarge,
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: CustomDropdown<String>(
              decoration: CustomDropdownDecoration(
                closedBorderRadius: BorderRadius.circular(10),
                closedBorder:
                    Border.all(width: 3, color: theme.primaryColorDark),
                headerStyle: theme.textTheme.bodySmall,
                closedFillColor: Colors.white,
                expandedFillColor: Colors.white,
                closedSuffixIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                expandedSuffixIcon: const Icon(
                  Icons.arrow_drop_up,
                  color: Colors.black,
                ),
              ),
              hintText: 'Select Theme App',
              items: themeList,
              // initialItem: themeList[0],
              onChanged: (value) {},
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                Image.asset(width: 40, 'assets/images/icons/languages.png'),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Language App:',
                  style: theme.textTheme.bodyLarge,
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: CustomDropdown<String>(
              decoration: CustomDropdownDecoration(
                closedBorderRadius: BorderRadius.circular(10),
                closedBorder:
                    Border.all(width: 3, color: theme.primaryColorDark),
                headerStyle: theme.textTheme.bodySmall,
                closedFillColor: Colors.white,
                expandedFillColor: Colors.white,
                closedSuffixIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                expandedSuffixIcon: const Icon(
                  Icons.arrow_drop_up,
                  color: Colors.black,
                ),
              ),
              hintText: 'Select language App',
              items: langList,
              // initialItem: themeList[0],
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
