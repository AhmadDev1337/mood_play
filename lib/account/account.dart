// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';

import '../network_offline.dart';

void main() {
  runApp(MyApp3());
}

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeHome',
      home: ConnectivityBuilder(
        builder: (ConnectivityStatus status) {
          if (status == ConnectivityStatus.online) {
            return AccountPage();
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

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WeHome",
      home: Scaffold(
        backgroundColor: Color(0xFF000000),
        appBar: AppBar(
          title: Center(
            child: Text(
              "Account",
              style: GoogleFonts.acme(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Color(0xFF000000),
        ),
        body: Column(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Icon(IconlyLight.profile, color: Colors.white),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Icon(IconlyLight.star, color: Colors.white),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Member",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Icon(IconlyLight.logout, color: Colors.white),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Text("version 1.0", style: TextStyle(color: Colors.grey)),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
