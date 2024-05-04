// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, unused_field, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

import 'all/information_page.dart';
import 'all/mpshort_all_page.dart';
import 'all/mp short/mpshort_page.dart';
import 'all/tranding_all.dart';

class AllPage extends StatefulWidget {
  const AllPage({super.key});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  PageController _pageController = PageController();
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImageCarousel();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchImageCarousel() async {
    final response =
        await http.get(Uri.parse('https://pastebin.com/raw/AZPxStDx'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        imageUrls = List<String>.from(data);
      });
      // Start automatic image change
      startImageSlider();
    } else {
      Scaffold(
        backgroundColor: Colors.white,
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

  void startImageSlider() {
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.page! < imageUrls.length - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 230,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(imageUrls[index],
                            fit: BoxFit.fill);
                      },
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      child: Text(
                        "Advertisement",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
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
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("assets/images/mp short.png", width: 30),
                        SizedBox(width: 10),
                        Text(
                          "MpShort",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
                    child: MpShortAllPage(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
              ),
              child: Text(
                "Tranding",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            AnimationLimiter(
              child: AnimationConfiguration.synchronized(
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  curve: Curves.decelerate,
                  child: FadeInAnimation(
                    child: TrandingAllPage(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Divider(
              height: 0.3,
              color: Colors.grey,
            ),
            InformationPage(),
          ],
        ),
      ),
    );
  }
}
