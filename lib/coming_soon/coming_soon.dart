// ignore_for_file: unused_import, unnecessary_null_comparison, prefer_const_constructors, unnecessary_string_interpolations, unused_field, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';

import '../network_offline.dart';

class JsonData {
  final String imgUrl;
  final String name;
  final String author;
  final String actors;
  final String score;
  final String desc;

  JsonData({
    required this.imgUrl,
    required this.name,
    required this.author,
    required this.actors,
    required this.score,
    required this.desc,
  });
}

void main() {
  runApp(MyApp2());
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeHome',
      home: ConnectivityBuilder(
        builder: (ConnectivityStatus status) {
          if (status == ConnectivityStatus.online) {
            return ComingSoonPage();
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

class ComingSoonPage extends StatefulWidget {
  const ComingSoonPage({super.key});

  @override
  State<ComingSoonPage> createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage> {
  List<JsonData> jsonDataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const singleJsonUrl = 'https://pastebin.com/raw/kCq05WL3';

    try {
      final response = await http.get(Uri.parse(singleJsonUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        jsonDataList = jsonData.map<JsonData>((data) {
          return JsonData(
            imgUrl: data['imgUrl'],
            name: data['name'],
            author: data['author'],
            actors: data['actors'],
            score: data['score'],
            desc: data['desc'],
          );
        }).toList();

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
        backgroundColor: Color(0xFF000000),
        appBar: AppBar(
          title: Center(
            child: Text(
              "Coming Soon",
              style: GoogleFonts.acme(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Color(0xFF000000),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 10, right: 10),
          children: [
            for (var jsonData in jsonDataList)
              GestureDetector(
                onTap: () {},
                child: buildJsonContainer(jsonData),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _buildIconText(IconData icon, Color color, String text) {
  return Container(
    padding: EdgeInsets.all(5),
    height: 25,
    width: 55,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
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
                color: Colors.black87),
          )
        ],
      ),
    ),
  );
}

Widget buildJsonContainer(JsonData jsonData) {
  return Stack(
    children: [
      SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (jsonData.imgUrl != null)
              Container(
                padding: EdgeInsets.only(top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    jsonData.imgUrl,
                    width: 110,
                    height: 190,
                  ),
                ),
              ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          jsonData.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        IconlyLight.bookmark,
                        color: Colors.orange[300],
                      )
                    ],
                  ),
                  Text(
                    jsonData.author,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    jsonData.desc,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildIconText(IconlyLight.star, Colors.orange[300]!,
                      '${jsonData.score}'),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
