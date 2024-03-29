import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

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

class ProfileSongPage extends StatefulWidget {
  final JsonData jsonData;

  const ProfileSongPage({Key? key, required this.jsonData}) : super(key: key);

  @override
  State<ProfileSongPage> createState() => _ProfileSongPageState();
}

class _ProfileSongPageState extends State<ProfileSongPage> {
  final double _confidence = 1.0;
  bool isOpen = false;
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<JsonData> jsonDataList = [];
  final TextEditingController _searchController = TextEditingController();
  List<JsonData> filteredJsonDataList = [];
  final String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _filterJson(String searchText) {
    setState(() {
      filteredJsonDataList = jsonDataList
          .where((jsonData) =>
              jsonData.name.toLowerCase().contains(searchText.toLowerCase()) ||
              jsonData.author.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchJsonData() async {
    const singleJsonUrl = 'https://pastebin.com/raw/FigS0r5G';

    try {
      final response = await http.get(Uri.parse(singleJsonUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          jsonDataList = (jsonData as List)
              .map(
                (data) => JsonData(
                  imgUrl: data['imgUrl'],
                  videoUrl: data['videoUrl'],
                  name: data['name'],
                  author: data['author'],
                  actors: data['actors'],
                  score: data['score'],
                  review: data['review'],
                  view: data['view'],
                  desc: data['desc'],
                ),
              )
              .toList();
          filteredJsonDataList = List.from(jsonDataList);
        });
      } else {
        Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Center(
              child: SpinKitWave(
                color: Color.fromARGB(255, 241, 106, 53),
                size: 25,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: SpinKitWave(
              color: Color.fromARGB(255, 241, 106, 53),
              size: 25,
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJsonData();

    _controller = VideoPlayerController.network(widget.jsonData.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  List<Offset> currentOffsets = <Offset>[];
  List<Offset> offsets = <Offset>[];
  List<List<Offset>> allOffsets = [];

  Offset? lastPosition;

  @override
  Widget build(BuildContext context) {
    final imgUrl = widget.jsonData.imgUrl;
    final videoUrl = widget.jsonData.videoUrl;
    final name = widget.jsonData.name;
    final author = widget.jsonData.author;
    final actors = widget.jsonData.actors;
    final score = widget.jsonData.score;
    final review = widget.jsonData.review;
    final view = widget.jsonData.view;
    final desc = widget.jsonData.desc;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MoodPlay",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0d0d0d),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    SizedBox(width: 18),
                    Text(
                      author,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                height: 30,
                child: TextField(
                  onChanged: _filterJson,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search Song...",
                    hintStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xff0d0d0d),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network(
                        imgUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author,
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
                        actors,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        name,
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
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Videos",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredJsonDataList.length,
              itemBuilder: (context, index) {
                final jsonData = filteredJsonDataList[index];

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VideoPage(
                                  videoUrl: jsonData.videoUrl,
                                )));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 130,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                jsonData.imgUrl,
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
                                  jsonData.author,
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
                                  jsonData.actors,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  jsonData.score,
                                  overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final String videoUrl;

  const VideoPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  double _currentSliderValue = 0.0;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _hideControlsTimer?.cancel();
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
    _hideControlsTimer?.cancel();
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
    return MaterialApp(
      title: 'MoodPlay',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                            _controller
                                .seekTo(Duration(seconds: value.toInt()));
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
      ),
    );
  }
}
