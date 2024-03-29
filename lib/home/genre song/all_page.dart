// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, unused_field

import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import '../../test_page.dart';
import '../../contoh_list_akun.dart';
import '../mp short/mpshort_page.dart';
import '../trand.dart';

class JsonData {
  final String imgUrl;
  final String logoUrl;
  final String videoUrl;
  final String name;
  final String title;

  JsonData({
    required this.imgUrl,
    required this.logoUrl,
    required this.videoUrl,
    required this.name,
    required this.title,
  });
}

class AllPage extends StatefulWidget {
  const AllPage({super.key});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<JsonData> jsonDataList = [];
  bool isLoading = true;

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<JsonData> filteredJsonDataList = [];

  void _startSearch() {
    setState(() {
      isSearching = true;
      _searchController.text = '';
    });
  }

  void _stopSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
      filteredJsonDataList.clear();
    });
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredJsonDataList = jsonDataList
            .where((jsonData) =>
                jsonData.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredJsonDataList = List.from(jsonDataList);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const singleJsonUrl = 'https://pastebin.com/raw/FigS0r5G';

    try {
      final response = await http.get(Uri.parse(singleJsonUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        jsonDataList = jsonData.map<JsonData>((data) {
          return JsonData(
            imgUrl: data['imgUrl'],
            logoUrl: data['logoUrl'],
            videoUrl: data['videoUrl'],
            name: data['name'],
            title: data['title'],
          );
        }).toList();

        filteredJsonDataList = List.from(jsonDataList);

        setState(() {
          isLoading = false;
        });
      } else {
        Scaffold(
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
    } catch (e) {
      Scaffold(
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
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: SpinKitWave(
              color: Color(0xFFE1261C),
              size: 25,
            ),
          )
        : AnimationLimiter(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "MpShort",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MpShortPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Text(
                              "view all",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimationLimiter(
                    child: AnimationConfiguration.synchronized(
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        curve: Curves.decelerate,
                        child: FadeInAnimation(
                          child: SongListPage(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Popular",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSearching ? _stopSearch() : _startSearch();
                            });
                          },
                          child: AnimSearchBar(
                            width: 200,
                            rtl: true,
                            textController: _searchController,
                            onSuffixTap: () {
                              _stopSearch();
                            },
                            onSubmitted: _performSearch,
                            helpText: "Search...",
                            animationDurationInMilli: 735,
                            color: Color(0xFF0D0D0D),
                            searchIconColor: Color(0xFFF2F2F2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimationLimiter(
                    child: AnimationConfiguration.synchronized(
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        curve: Curves.decelerate,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFF0D0D0D),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: filteredJsonDataList.length,
                                itemBuilder: (context, index) {
                                  final jsonData = filteredJsonDataList[index];

                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPage(
                                                        videoUrl:
                                                            jsonData.videoUrl,
                                                      )));
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 200,
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      jsonData.imgUrl,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Image.network(
                                                      jsonData.logoUrl,
                                                      width: 40,
                                                      height: 40),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        jsonData.title,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text(
                                                        jsonData.name,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
