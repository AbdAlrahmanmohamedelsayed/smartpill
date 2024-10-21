import 'package:flutter/material.dart';
import 'package:smartpill/features/screens/home/home_view.dart';
import 'package:smartpill/features/screens/settings/settings_view.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  int selectedIndex = 0;
  List<Widget> screens = [HomeView(), SettingsView()];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(width: 25, 'assets/images/icons/home.png'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(width: 25, 'assets/images/icons/setting.png'),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
