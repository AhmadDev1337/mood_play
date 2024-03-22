// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, use_key_in_widget_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'more_film.dart';
import 'recommend.dart';
import 'trand.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://pastebin.com/raw/LUXC26TA'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        imageUrls = List<String>.from(data);
      });
    } else {
      Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: SpinKitWave(
              color: Colors.cyan,
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
        backgroundColor: Color(0xFF000000),
        appBar: AppBar(
          title: Center(
            child: Text(
              "WeHome",
              style: GoogleFonts.acme(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Color(0xFF000000),
        ),
        body: ListView(
          children: [
            Expanded(
              child: SizedBox(
                height: 450,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(50),
                      ),
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
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return Image.network(imageUrls[index],
                                fit: BoxFit.fitHeight);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      left: 170,
                      right: 170,
                      bottom: 20,
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: imageUrls.length,
                        effect: ExpandingDotsEffect(
                          dotWidth: 7.0,
                          dotHeight: 7.0,
                          dotColor: Colors.grey,
                          activeDotColor: Color(0xFFE1261C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MoreFilm()));
                    },
                    child: Text(
                      "more",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimationLimiter(
              child: AnimationConfiguration.synchronized(
                child: SlideAnimation(
                  curve: Curves.decelerate,
                  child: FadeInAnimation(
                    duration: const Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 60),
                    child: RecomFilm(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tranded",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MoreFilm()));
                    },
                    child: Text(
                      "more",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimationLimiter(
              child: AnimationConfiguration.synchronized(
                child: SlideAnimation(
                  curve: Curves.decelerate,
                  child: FadeInAnimation(
                    duration: const Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 60),
                    child: TrandFilm(),
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
