// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'genre song/all_page.dart';
import 'genre song/classic_page.dart';
import 'genre song/hiphop_page.dart';
import 'genre song/jazz_page.dart';
import 'genre song/pop_page.dart';
import 'genre song/rnb_page.dart';
import 'genre song/rock_page.dart';

class BarController extends StatefulWidget {
  const BarController({super.key});

  @override
  State<BarController> createState() => _BarControllerState();
}

class _BarControllerState extends State<BarController> {
  int currentPageIndex = 0;

  final List<String> items = [
    "All",
    "Pop",
    "Classic",
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MoodPlay",
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "MoodPlay",
            style: GoogleFonts.acme(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Color(0xFF0D0D0D),
        ),
        backgroundColor: Color(0xFF0D0D0D),
        body: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: Color(0xFF0D0D0D),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentPageIndex == index
                                  ? Colors.white
                                  : Colors.grey.shade900,
                            ),
                            child: Center(
                              child: Text(
                                items[index],
                                style: TextStyle(
                                    color: currentPageIndex == index
                                        ? Colors.grey.shade900
                                        : Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: PageView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: items.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return buildItemPage(items[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemPage(String item) {
    Widget content;
    if (item == "All") {
      content = AllPage();
    } else if (item == "Pop") {
      content = PopPage();
    } else {
      content = ClassicPage();
    }

    return ListView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      children: [
        content,
      ],
    );
  }
}
