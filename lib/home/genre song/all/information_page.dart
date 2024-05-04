// ignore_for_file: deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
            child: Text(
              "INFORMATION",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 40, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "First version!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "1.0.0.1",
                  style: TextStyle(
                    color: Color(0xffb4b4b4),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => launchURL(
                    "https://www.instagram.com/ahmad_dev1337/?igsh=MzNINGNkZWQ4Mg=="),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Image.asset(
                    "assets/icons/instagram.png",
                    width: 25,
                    height: 25,
                    color: Color(0xffb4b4b4),
                  ),
                ),
              ),
              InkWell(
                onTap: () => launchURL(
                    "https://www.tiktok.com/@arr_1337?_t=8lvObQ6A8qv&_r=1"),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Image.asset(
                    "assets/icons/tik-tok.png",
                    width: 25,
                    height: 25,
                    color: Color(0xffb4b4b4),
                  ),
                ),
              ),
              InkWell(
                onTap: () => launchURL(
                    "https://www.tiktok.com/@arr_1337?_t=8lvObQ6A8qv&_r=1"),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Image.asset(
                    "assets/icons/twitter.png",
                    width: 25,
                    height: 25,
                    color: Color(0xffb4b4b4),
                  ),
                ),
              ),
              InkWell(
                onTap: () => launchURL(
                    "https://www.tiktok.com/@arr_1337?_t=8lvObQ6A8qv&_r=1"),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Image.asset(
                    "assets/icons/envelope.png",
                    width: 25,
                    height: 25,
                    color: Color(0xffb4b4b4),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(25),
              padding: EdgeInsets.all(15),
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xffb4b4b4),
                ),
              ),
              child: Center(
                child: Text(
                  "Bagikan aplikasi Novely",
                  style: TextStyle(
                    color: Color(0xffb4b4b4),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Center(
            child: Text(
              "Copyright 2024 AdDev, Inc.",
              style: TextStyle(
                color: Color(0xffb4b4b4),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
