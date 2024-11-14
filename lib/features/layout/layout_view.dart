import 'package:flutter/material.dart';
import 'package:smartpill/core/config/page_routes_name.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/home/home_view.dart';
import 'package:smartpill/features/screens/menu/menu_view.dart';
import 'package:smartpill/features/screens/report/report_view.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  int selectedIndex = 0;
  List<Widget> screens = const [HomeView(), ReportView(), MenuView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, PageRoutesName.addMedicine);
              },
              child:
                  Image.asset('assets/images/icons/add_pills.png', width: 35),
            )
          : null,
      bottomNavigationBar: Container(
        height: 100,
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
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            _buildBottomNavigationBarItem(
              iconPath: 'assets/images/icons/home.png',
              label: 'Home',
              isSelected: selectedIndex == 0,
            ),
            _buildBottomNavigationBarItem(
              iconPath: 'assets/images/icons/medical-report.png',
              label: 'Medical Report',
              isSelected: selectedIndex == 1,
            ),
            _buildBottomNavigationBarItem(
              iconPath: 'assets/images/icons/menu.png',
              label: 'More',
              isSelected: selectedIndex == 2,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Image.asset(
          iconPath,
          width: 25,
        ),
      ),
      label: label,
    );
  }
}
