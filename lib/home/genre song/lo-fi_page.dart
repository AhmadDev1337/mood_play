// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LoFiPage extends StatefulWidget {
  @override
  _LoFiPageState createState() => _LoFiPageState();
}

class _LoFiPageState extends State<LoFiPage> {
  List<dynamic> trands = [];
  late List<BannerAd> _bannerAds;
  int _currentAdIndex = 0;

  void _loadBannerAds() {
    _bannerAds = List<BannerAd>.generate(5, (index) {
      final adUnitIds = [
        'ca-app-pub-8363980854824352/5006742410',
        'ca-app-pub-8363980854824352/4374185583',
        'ca-app-pub-8363980854824352/3554059947',
        'ca-app-pub-8363980854824352/2568281338',
        'ca-app-pub-8363980854824352/8005791919'
      ];
      return BannerAd(
        adUnitId: adUnitIds[index],
        request: AdRequest(),
        size: AdSize.mediumRectangle,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            log('Ad onAdLoaded');
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
        itemCount: trands.length < 100 ? trands.length : 100,
        itemBuilder: (context, index) {
          if ((index + 1) % 2 == 0 && index != 0) {
            final ad = _bannerAds[_currentAdIndex];
            _currentAdIndex = (_currentAdIndex + 1) % _bannerAds.length;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VideoPlayerPage(
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
                                width: 15,
                              ),
                              Text(
                                trands[index]['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
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
                Container(
                  height: 50,
                  child: AdWidget(ad: ad),
                ),
                SizedBox(height: 10),
              ],
            );
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoPlayerPage(
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
                            width: 15,
                          ),
                          Text(
                            trands[index]['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
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
                              builder: (context) => VideoPlayerPage(
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

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  double _currentSliderValue = 0.0;
  bool _showControls = true;
  late Timer _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    _hideControlsTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _hideControlsTimer.cancel();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _startHideControlsTimer();
      }
      _showControls = true;
    });
  }

  void _startHideControlsTimer() {
    _hideControlsTimer.cancel();
    _hideControlsTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0d0d0d),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : SpinKitWave(
                    color: Color(0xFFE1261C),
                    size: 25,
                  ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showControls = !_showControls;
                  if (_showControls && !_controller.value.isPlaying) {
                    _startHideControlsTimer();
                  }
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _showControls ? 1.0 : 0.0,
                child: Container(
                  color: Colors.transparent,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _showControls ? 1.0 : 0.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Slider(
                        activeColor: Color(0xFFE1261C),
                        value: _currentSliderValue,
                        min: 0.0,
                        max: _controller.value.duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                          _controller.seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_controller.value.position),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            _formatDuration(_controller.value.duration),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _showControls ? 1.0 : 0.0,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _showControls ? 1.0 : 0.0,
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _showControls ? 1.0 : 0.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
