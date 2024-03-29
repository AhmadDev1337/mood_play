// ignore_for_file: unused_field, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';

import '../test_page.dart';

class JsonData {
  final String imgUrl;
  final String videoUrl;
  final String name;
  final String author;
  final String actors;
  final String score;
  final String review;
  final String view;
  final String desc;

  JsonData({
    required this.imgUrl,
    required this.videoUrl,
    required this.name,
    required this.author,
    required this.actors,
    required this.score,
    required this.review,
    required this.view,
    required this.desc,
  });
}

class MpShort {
  final String imgUrl;
  final String logoUrl;
  final String videoUrl;
  final String name;
  final String title;

  MpShort({
    required this.imgUrl,
    required this.logoUrl,
    required this.videoUrl,
    required this.name,
    required this.title,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<JsonData> jsonDataList = [];
  List<MpShort> mpShortList = [];

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<JsonData> filteredJsonDataList = [];
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  void _loadNativeAd() {
    _nativeAd = NativeAd(
        adUnitId: "ca-app-pub-8363980854824352/6916794301",
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            log('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Color(0xff0d0d0d),
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Color(0xff0d0d0d),
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Color(0xff0d0d0d),
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Color(0xff0d0d0d),
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Color(0xff0d0d0d),
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

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
    _loadNativeAd();
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
            videoUrl: data['videoUrl'],
            name: data['name'],
            author: data['author'],
            actors: data['actors'],
            score: data['score'],
            review: data['review'],
            view: data['view'],
            desc: data['desc'],
          );
        }).toList();

        filteredJsonDataList = List.from(jsonDataList);

        setState(() {});
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WeHome",
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "MoodPlay",
                style: GoogleFonts.acme(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: GestureDetector(
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
              ),
            ],
          ),
          backgroundColor: Color(0xFF0D0D0D),
        ),
        backgroundColor: Color(0xFF0D0D0D),
        body: AnimationLimiter(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 200,
                    minHeight: 150,
                    maxWidth: 250,
                    maxHeight: 200,
                  ),
                  child: AdWidget(ad: _nativeAd!),
                ),
                SizedBox(height: 20),
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
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey,
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
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
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
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => VideoPage(
                                                      videoUrl:
                                                          jsonData.videoUrl,
                                                    )));
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3),
                                            height: 200,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    jsonData.imgUrl,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              children: [
                                                Image.network(jsonData.imgUrl,
                                                    width: 40, height: 40),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      jsonData.author,
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
                                                      jsonData.actors,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Text(
                                                      jsonData.score,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D0D0D),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageWidget(String imgUrl) {
    if (imgUrl != '') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 131, 129, 129),
              Color.fromARGB(255, 206, 199, 199),
            ],
            stops: [0.0, 0.4],
          ).createShader(bounds),
          child: Image.network(
            imgUrl,
            width: 110,
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        width: 110,
        height: 170,
        color: Colors.grey,
      );
    }
  }

  Widget buildJsonContainer(JsonData jsonData) {
    return Stack(
      children: [
        SizedBox(
          width: 135,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageWidget(jsonData.imgUrl),
              Container(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Column(
                  children: [
                    Text(
                      jsonData.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    Text(
                      jsonData.author,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: _buildIconText(
            IconlyLight.star,
            Colors.orange[300]!,
            jsonData.score,
          ),
        ),
      ],
    );
  }
}
