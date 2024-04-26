// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, deprecated_member_use

import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class HipHopPage extends StatefulWidget {
  @override
  _HipHopPageState createState() => _HipHopPageState();
}

class _HipHopPageState extends State<HipHopPage> {
  List<dynamic> hiphops = [];
  late List<BannerAd> _bannerAds;
  int _currentAdIndex = 0;
  bool _adsLoaded = false;
  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-8363980854824352/5710886789',
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

  void _loadBannerAds() {
    _bannerAds = List<BannerAd>.generate(20, (index) {
      final adUnitIds = [
        'ca-app-pub-8363980854824352/7761167761',
        'ca-app-pub-8363980854824352/4034509891',
        'ca-app-pub-8363980854824352/4646885426',
        'ca-app-pub-8363980854824352/5330762770',
        'ca-app-pub-8363980854824352/2981653804',
        'ca-app-pub-8363980854824352/3944231748',
        'ca-app-pub-8363980854824352/1430066277',
        'ca-app-pub-8363980854824352/6846044488',
        'ca-app-pub-8363980854824352/1668572134',
        'ca-app-pub-8363980854824352/1593717808',
        'ca-app-pub-8363980854824352/1860993884',
        'ca-app-pub-8363980854824352/5508912084',
        'ca-app-pub-8363980854824352/9547912216',
        'ca-app-pub-8363980854824352/9004986731',
        'ca-app-pub-8363980854824352/2882748749',
        'ca-app-pub-8363980854824352/7628325887',
        'ca-app-pub-8363980854824352/9280636134',
        'ca-app-pub-8363980854824352/2236382495',
        'ca-app-pub-8363980854824352/7225819448',
        'ca-app-pub-8363980854824352/8874793098'
      ];
      return BannerAd(
        adUnitId: adUnitIds[index],
        request: AdRequest(),
        size: AdSize.mediumRectangle,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            log('Ad onAdLoaded');
            setState(() {
              _adsLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError err) {
            log('Ad onAdFailedToLoad: ${err.message}');
            ad.dispose();
          },
        ),
      )..load();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadBannerAds();
    _loadInterstitialAd();
  }

  fetchData() async {
    final response =
        await http.get(Uri.parse('https://pastebin.com/raw/wW84PYHJ'));
    if (response.statusCode == 200) {
      setState(() {
        hiphops = json.decode(response.body)['hiphops'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    for (var ad in _bannerAds) {
      ad.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: hiphops.length < 100 ? hiphops.length : 100,
        itemBuilder: (context, index) {
          if ((index + 1) % 5 == 0 && index != 0) {
            final ad = _bannerAds[_currentAdIndex];
            _currentAdIndex = (_currentAdIndex + 1) % _bannerAds.length;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _loadInterstitialAd();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VideoPlayerLandscapePage(
                        videoUrl: hiphops[index]['videoUrl'],
                      ),
                    ));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade900,
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      hiphops[index]['thumbnail'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              hiphops[index]['titleSong'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _adsLoaded
                    ? Container(
                        height: 50,
                        child: AdWidget(ad: ad),
                      )
                    : SizedBox(height: 0),
              ],
            );
          } else {
            return GestureDetector(
              onTap: () {
                _loadInterstitialAd();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoPlayerLandscapePage(
                    videoUrl: hiphops[index]['videoUrl'],
                  ),
                ));
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade900,
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  hiphops[index]['thumbnail'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          hiphops[index]['titleSong'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
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
