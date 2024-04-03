// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, unused_field, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'pop/Kpop/kpop_album.dart';
import 'pop/Kpop/profile_page.dart';
import 'pop/list_pop.dart';
import 'pop/popular_pop.dart';

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

class PopPage extends StatefulWidget {
  const PopPage({super.key});

  @override
  State<PopPage> createState() => _PopPageState();
}

class _PopPageState extends State<PopPage> {
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "K-Pop",
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
                          builder: (context) => KpopAlbumPage(),
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
                    child: KpopListPage(),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListPopPage(),
                        ),
                      );
                    },
                    child: Text(
                      "more",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
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
                    child: PopularPopPage(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
