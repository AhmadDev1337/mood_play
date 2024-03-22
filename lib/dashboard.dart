import 'package:flutter/material.dart';
import 'package:super_bottom_navigation_bar/super_bottom_navigation_bar.dart';
import 'package:iconly/iconly.dart';
import '../account/account.dart';
import 'coming_soon/coming_soon.dart';
import 'home/top_bar_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  final int _selectedIndex = 0;

  final List<Widget> _pages = [
    MyApp1(),
    MyApp2(),
    MyApp3(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WeHome",
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: SuperBottomNavigationBar(
          curve: Curves.easeIn,
          height: 40,
          backgroundColor: const Color(0xFFE1261C),
          items: const [
            SuperBottomNavigationBarItem(
              size: 20,
              selectedIcon: Icons.home,
              unSelectedIcon: IconlyLight.home,
              borderBottomColor: Colors.black,
              backgroundShadowColor: Colors.black12,
              borderBottomWidth: 1,
            ),
            SuperBottomNavigationBarItem(
              size: 20,
              selectedIcon: Icons.new_releases_rounded,
              unSelectedIcon: Icons.new_releases_outlined,
              borderBottomColor: Colors.black,
              backgroundShadowColor: Colors.black12,
              borderBottomWidth: 1,
            ),
            SuperBottomNavigationBarItem(
              size: 20,
              selectedIcon: Icons.person,
              unSelectedIcon: IconlyLight.profile,
              borderBottomColor: Colors.black,
              backgroundShadowColor: Colors.black12,
              borderBottomWidth: 1,
            ),
          ],
          currentIndex: _selectedIndex,
          onSelected: _onItemTapped,
        ),
      ),
    );
  }
}
