// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';

import '../network_offline.dart';
import 'dashboard.dart';

import 'kdrama.dart';
import 'series.dart';

void main() {
  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeHome',
      home: ConnectivityBuilder(
        builder: (ConnectivityStatus status) {
          if (status == ConnectivityStatus.online) {
            return TopBarController();
          } else if (status == ConnectivityStatus.offline) {
            return NetworkOfflinePage();
          } else {
            return Scaffold(
              backgroundColor: Color(0xFF0D0D0D),
              body: Container(
                child: Center(
                  child: SpinKitWave(
                    color: Color(0xFFE1261C),
                    size: 25,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class TopBarController extends StatefulWidget {
  @override
  State<TopBarController> createState() => _TopBarControllerState();
}

class _TopBarControllerState extends State<TopBarController> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              HomePage(),
              KDramaPage(),
              const SeriesPage(),
            ],
          ),
          Positioned(
            top: 100,
            left: 30,
            right: 30,
            child: Container(
              height: 45,
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      "Dashboard",
                      style: TextStyle(
                        color: _currentPageIndex == 0
                            ? Color(0xFFE1261C)
                            : Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      "K'Drama",
                      style: TextStyle(
                        color: _currentPageIndex == 1
                            ? Color(0xFFE1261C)
                            : Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      "Series",
                      style: TextStyle(
                        color: _currentPageIndex == 2
                            ? Color(0xFFE1261C)
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
