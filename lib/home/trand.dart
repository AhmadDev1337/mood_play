// ignore_for_file: unused_import, unnecessary_null_comparison, prefer_const_constructors, unnecessary_string_interpolations, unused_field, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class JsonData {
  final String imgUrl;
  final String videoId;
  final String name;
  final String author;
  final String actors;
  final String score;
  final String review;
  final String view;
  final String desc;

  JsonData({
    required this.imgUrl,
    required this.videoId,
    required this.name,
    required this.author,
    required this.actors,
    required this.score,
    required this.review,
    required this.view,
    required this.desc,
  });
}

class TrandFilm extends StatefulWidget {
  const TrandFilm({super.key});

  @override
  State<TrandFilm> createState() => _TrandFilmState();
}

class _TrandFilmState extends State<TrandFilm> {
  List<JsonData> jsonDataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const singleJsonUrl = 'https://pastebin.com/raw/Ydbb412j';

    try {
      final response = await http.get(Uri.parse(singleJsonUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        jsonDataList = jsonData.map<JsonData>((data) {
          return JsonData(
            imgUrl: data['imgUrl'],
            videoId: data['videoId'],
            name: data['name'],
            author: data['author'],
            actors: data['actors'],
            score: data['score'],
            review: data['review'],
            view: data['view'],
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
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 10, right: 10),
            children: [
              for (var jsonData in jsonDataList)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(jsonData: jsonData),
                      ),
                    );
                  },
                  child: buildJsonContainer(jsonData),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildIconText(IconData icon, Color color, String text) {
  return Container(
    padding: EdgeInsets.all(5),
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
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        )
      ],
    ),
  );
}

Widget buildJsonContainer(JsonData jsonData) {
  return Stack(
    children: [
      SizedBox(
        width: 125,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  if (jsonData.imgUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        jsonData.imgUrl,
                        width: 110,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      jsonData.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 15,
        left: 15,
        child: _buildIconText(
            IconlyLight.star, Colors.orange[300]!, '${jsonData.score}'),
      ),
    ],
  );
}

class DetailPage extends StatefulWidget {
  final JsonData jsonData;

  const DetailPage({Key? key, required this.jsonData}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final double _confidence = 1.0;
  bool isOpen = false;
  late YoutubePlayerController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showPlayDialog(BuildContext context, String videoId) {
    final controller = YoutubePlayerController(
      initialVideoId: videoId,
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(0),
          child: YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            aspectRatio: 16 / 9,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imgUrl = widget.jsonData.imgUrl;
    final videoId = widget.jsonData.videoId;
    final name = widget.jsonData.name;
    final author = widget.jsonData.author;
    final actors = widget.jsonData.actors;
    final score = widget.jsonData.score;
    final review = widget.jsonData.review;
    final view = widget.jsonData.view;
    final desc = widget.jsonData.desc;

    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imgUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: ListView(
                children: [
                  SizedBox(
                    height: 355,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.add, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Add List",
                              style: TextStyle(
                                color: Colors.grey,
                              ))
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _showPlayDialog(context, videoId);
                        },
                        child: Container(
                          width: 120,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Color(0xFFE1261C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconlyLight.video,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text("Play",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Icon(IconlyLight.info_circle, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Inform",
                              style: TextStyle(
                                color: Colors.grey,
                              ))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            height: 1.2,
                            color: Color(0xFFF2F2F2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        author,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        actors,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIconText(
                            Icons.star,
                            Colors.orange[300]!,
                            '$score($review)',
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          _buildIconText(
                            IconlyLight.show,
                            Colors.grey,
                            '$view Read',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ExpansionTile(
                        title: Container(
                          padding: EdgeInsets.all(10),
                          color: Color(0xFFE1261C),
                          child: Text('Synopsis :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              desc,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(color: Color(0xFFF2F2F2)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, Color color, String text) {
    return Row(
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
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    );
  }
}
