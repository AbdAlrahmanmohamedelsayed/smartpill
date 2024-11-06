import 'package:flutter/material.dart';
import 'package:smartpill/features/screens/home/home_view.dart';
import 'package:smartpill/features/screens/menu/menu_view.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  int selectedIndex = 0;
  List<Widget> screens = [HomeView(), MenuView()];

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);

    return Scaffold(
      body: screens[selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Image.asset(width: 35, 'assets/images/icons/add_pills.png'),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          height: 85,
          color: Colors.white,
          shadowColor: Colors.green,
          notchMargin: 12,
          child: BottomNavigationBar(
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
                icon: Image.asset(width: 25, 'assets/images/icons/menu.png'),
                label: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
