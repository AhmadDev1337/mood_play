// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, prefer_final_fields, file_names
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LoFiPage extends StatefulWidget {
  @override
  _LoFiPageState createState() => _LoFiPageState();
}

class _LoFiPageState extends State<LoFiPage> {
  List<dynamic> lofi = [];
  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-8363980854824352/2878190953',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd!.show();
          log('Ad onAdLoaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadInterstitialAd();
  }

  fetchData() async {
    final response =
        await http.get(Uri.parse('https://pastebin.com/raw/wyPuLqFx'));
    if (response.statusCode == 200) {
      setState(() {
        lofi = json.decode(response.body)['lofi'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: lofi.length < 40 ? lofi.length : 40,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _loadInterstitialAd();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VideoPlayerLandscapePage(
                  videoUrl: lofi[index]['videoUrl'],
                ),
              ));
            },
            child: Column(
              children: [
                Container(
                  height: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          lofi[index]['imgUrl'],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(250),
                          color: Colors.grey.shade900,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(250),
                              child: Image.network(
                                lofi[index]['logoUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        lofi[index]['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerLandscapePage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerLandscapePage({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _VideoPlayerLandscapePageState createState() =>
      _VideoPlayerLandscapePageState();
}

class _VideoPlayerLandscapePageState extends State<VideoPlayerLandscapePage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      allowMuting: true,
      autoPlay: true,
      looping: true,
      aspectRatio: 19.5 / 9,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0d0d0d),
      body: Center(
          child: Chewie(
        controller: _chewieController,
      )),
    );
  }
}
