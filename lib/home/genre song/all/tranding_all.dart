// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use
import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class TrandingAllPage extends StatefulWidget {
  @override
  _TrandingAllPageState createState() => _TrandingAllPageState();
}

class _TrandingAllPageState extends State<TrandingAllPage> {
  List<dynamic> trands = [];
  late List<BannerAd> _bannerAds;
  int _currentAdIndex = 0;
  bool _adsLoaded = false;

  void _loadBannerAds() {
    _bannerAds = List<BannerAd>.generate(20, (index) {
      final adUnitIds = [
        'ca-app-pub-8363980854824352/5006742410',
        'ca-app-pub-8363980854824352/4374185583',
        'ca-app-pub-8363980854824352/3554059947',
        'ca-app-pub-8363980854824352/2568281338',
        'ca-app-pub-8363980854824352/8005791919',
        'ca-app-pub-8363980854824352/7231249377',
        'ca-app-pub-8363980854824352/6544019519',
        'ca-app-pub-8363980854824352/4953604232',
        'ca-app-pub-8363980854824352/4012057658',
        'ca-app-pub-8363980854824352/5213458689',
        'ca-app-pub-8363980854824352/4173841197',
        'ca-app-pub-8363980854824352/2860759529',
        'ca-app-pub-8363980854824352/2587295344',
        'ca-app-pub-8363980854824352/7388195883',
        'ca-app-pub-8363980854824352/6075114211',
        'ca-app-pub-8363980854824352/4634357266',
        'ca-app-pub-8363980854824352/1274213678',
        'ca-app-pub-8363980854824352/3321275598',
        'ca-app-pub-8363980854824352/7151358324',
        'ca-app-pub-8363980854824352/2008193923'
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
  }

  fetchData() async {
    final response =
        await http.get(Uri.parse('https://pastebin.com/raw/FigS0r5G'));
    if (response.statusCode == 200) {
      setState(() {
        trands = json.decode(response.body)['trands'];
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
        itemCount: trands.length < 40 ? trands.length : 40,
        itemBuilder: (context, index) {
          if ((index + 1) % 2 == 0 && index != 0) {
            final ad = _bannerAds[_currentAdIndex];
            _currentAdIndex = (_currentAdIndex + 1) % _bannerAds.length;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VideoPlayerPotraitPage(
                        videoUrl: trands[index]['videoUrl'],
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
                                trands[index]['imgUrl'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailPage(
                              detail: trands[index]['detailPage'],
                            ),
                          ));
                        },
                        child: Padding(
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
                                        trands[index]['logoUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trands[index]['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    trands[index]['name'],
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
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _adsLoaded
                    ? Container(
                        height: 50,
                        child: AdWidget(ad: ad),
                      )
                    : SizedBox(height: 50), // Placeholder for Ad
                SizedBox(height: 10),
              ],
            );
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoPlayerPotraitPage(
                    videoUrl: trands[index]['videoUrl'],
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
                            trands[index]['imgUrl'],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailPage(
                          detail: trands[index]['detailPage'],
                        ),
                      ));
                    },
                    child: Padding(
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
                                    trands[index]['logoUrl'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trands[index]['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                trands[index]['name'],
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

class DetailPage extends StatefulWidget {
  final List<dynamic> detail;

  DetailPage({required this.detail});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String searchText = '';

  List<dynamic> filterDataByTitle(String searchText) {
    return widget.detail.where((data) {
      String title = data['titleSong'].toLowerCase();
      return title.contains(searchText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MoodPlay",
      home: Scaffold(
        backgroundColor: Color(0xff0d0d0d),
        appBar: AppBar(
          backgroundColor: Color(0xff0d0d0d),
          elevation: 0,
          title: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                SizedBox(width: 18),
                Text(
                  "Playlist Song",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search song...',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filterDataByTitle(searchText).length,
                itemBuilder: (BuildContext context, int index) {
                  var filteredData = filterDataByTitle(searchText);
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerLandscapePage(
                                  videoUrl: widget.detail[index]
                                      ['videoUrlSong']),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 130,
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  filteredData[index]['thumbnail'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredData[index]['titleSong'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    filteredData[index]['nameAccount'],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerPotraitPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPotraitPage({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _VideoPlayerPotraitPageState createState() => _VideoPlayerPotraitPageState();
}

class _VideoPlayerPotraitPageState extends State<VideoPlayerPotraitPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      allowFullScreen: true,
      aspectRatio: 9 / 19.5,
      allowMuting: true,
      autoPlay: true,
      looping: true,
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
      allowFullScreen: true,
      aspectRatio: 19.5 / 9,
      allowMuting: true,
      autoPlay: true,
      looping: true,
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
