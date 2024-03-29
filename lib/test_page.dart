// ignore_for_file: unused_field, unnecessary_null_comparison, avoid_print, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, unnecessary_import, deprecated_member_use

import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:video_player/video_player.dart';

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

class MoreFilm extends StatefulWidget {
  const MoreFilm({Key? key}) : super(key: key);

  @override
  State<MoreFilm> createState() => _MoreFilmState();
}

class _MoreFilmState extends State<MoreFilm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<JsonData> jsonDataList = [];

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<JsonData> filteredJsonDataList = [];
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  void _loadNativeAd() {
    _nativeAd = NativeAd(
        adUnitId: "ca-app-pub-8363980854824352/6916794301",
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            log('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Color(0xff0d0d0d),
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Color(0xff0d0d0d),
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Color(0xff0d0d0d),
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Color(0xff0d0d0d),
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Color(0xff0d0d0d),
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  void _startSearch() {
    setState(() {
      isSearching = true;
      _searchController.text = '';
    });
  }

  void _stopSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
      filteredJsonDataList.clear();
    });
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredJsonDataList = jsonDataList
            .where((jsonData) =>
                jsonData.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredJsonDataList = List.from(jsonDataList);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadNativeAd();
  }

  Future<void> fetchData() async {
    const singleJsonUrl = 'https://pastebin.com/raw/FigS0r5G';

    try {
      final response = await http.get(Uri.parse(singleJsonUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        jsonDataList = jsonData.map<JsonData>((data) {
          return JsonData(
            imgUrl: data['imgUrl'],
            logoUrl: data['logoUrl'],
            videoUrl: data['videoUrl'],
            name: data['name'],
            title: data['title'],
            
          );
        }).toList();

        filteredJsonDataList = List.from(jsonDataList);

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

  int calculatePageCount() {
    return (filteredJsonDataList.length / (itemsPerPage * storiesPerRow))
        .ceil();
  }

  List<List<JsonData>> chunkStories() {
    final List<List<JsonData>> chunkedStories = [];
    for (int i = 0; i < filteredJsonDataList.length; i += itemsPerPage) {
      final List<JsonData> chunk = filteredJsonDataList.sublist(
        i,
        i + itemsPerPage,
      );
      chunkedStories.add(chunk);
    }
    return chunkedStories;
  }

  List<JsonData> getStoriesForCurrentPage() {
    final int startIndex = currentPage * itemsPerPage * storiesPerRow;
    final int endIndex = (currentPage + 1) * itemsPerPage * storiesPerRow;
    return filteredJsonDataList.sublist(
        startIndex, endIndex.clamp(0, filteredJsonDataList.length));
  }

  int currentPage = 0;
  final int itemsPerPage = 2;
  final int storiesPerRow = 2;

  void goToNextPage() {
    final int lastPage = calculatePageCount() - 1;
    if (currentPage < lastPage) {
      setState(() {
        currentPage++;
      });
    }
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WeHome",
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "WeHome",
                style: GoogleFonts.acme(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearching ? _stopSearch() : _startSearch();
                    });
                  },
                  child: AnimSearchBar(
                    width: 200,
                    rtl: true,
                    textController: _searchController,
                    onSuffixTap: () {
                      _stopSearch();
                    },
                    onSubmitted: _performSearch,
                    helpText: "Search...",
                    animationDurationInMilli: 735,
                    color: Color(0xFF0D0D0D),
                    searchIconColor: Color(0xFFF2F2F2),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF0D0D0D),
        ),
        backgroundColor: Color(0xFF0D0D0D),
        body: AnimationLimiter(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int pageIndex = 0;
                    pageIndex < calculatePageCount();
                    pageIndex++)
                  if (pageIndex == currentPage)
                    Column(
                      children: [
                        for (int rowIndex = 0;
                            rowIndex < itemsPerPage;
                            rowIndex++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int columnIndex = 0;
                                  columnIndex < storiesPerRow;
                                  columnIndex++)
                                if (rowIndex * storiesPerRow + columnIndex <
                                    getStoriesForCurrentPage().length)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ProfileSongPage(
                                          jsonData: getStoriesForCurrentPage()[
                                              rowIndex * storiesPerRow +
                                                  columnIndex],
                                        ),
                                      ));
                                    },
                                    child: AnimationLimiter(
                                      child:
                                          AnimationConfiguration.synchronized(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        child: SlideAnimation(
                                          curve: Curves.decelerate,
                                          child: FadeInAnimation(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10, top: 10),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF0D0D0D),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(4.0, 4.0),
                                                      blurRadius: 15.0,
                                                      spreadRadius: 1.0,
                                                      color: Color(0xFF0D0D0D),
                                                    ),
                                                    BoxShadow(
                                                      offset:
                                                          Offset(-4.0, -4.0),
                                                      blurRadius: 15.0,
                                                      spreadRadius: 1.0,
                                                      color: Colors.black87,
                                                    ),
                                                  ],
                                                ),
                                                width: 150,
                                                child: Center(
                                                  child: buildJsonContainer(
                                                      getStoriesForCurrentPage()[
                                                          rowIndex *
                                                                  storiesPerRow +
                                                              columnIndex]),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        const SizedBox(height: 50),
                      ],
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (calculatePageCount() > 1 && currentPage > 0)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              color: const Color.fromARGB(255, 44, 40, 40),
                            ),
                            BoxShadow(
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              color: Color.fromARGB(255, 39, 39, 39),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFE1261C),
                        ),
                        child: GestureDetector(
                          onTap: goToPreviousPage,
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF0D0D0D),
                          ),
                        ),
                      ),
                    if (calculatePageCount() > 1 &&
                        currentPage < calculatePageCount() - 1)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              color: const Color.fromARGB(255, 44, 40, 40),
                            ),
                            BoxShadow(
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              color: Color.fromARGB(255, 39, 39, 39),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFE1261C),
                        ),
                        child: GestureDetector(
                          onTap: goToNextPage,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF0D0D0D),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.all(3),
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
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D0D0D),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageWidget(String imgUrl) {
    if (imgUrl != '') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
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
          child: Image.network(
            imgUrl,
            width: 110,
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        width: 110,
        height: 170,
        color: Colors.grey,
      );
    }
  }

  Widget buildJsonContainer(JsonData jsonData) {
    return Stack(
      children: [
        SizedBox(
          width: 135,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageWidget(jsonData.imgUrl),
              Container(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Column(
                  children: [
                    Text(
                      jsonData.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    Text(
                      jsonData.title,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
      ],
    );
  }
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
              jsonData.title.toLowerCase().contains(searchText.toLowerCase()))
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
            logoUrl: data['logoUrl'],
            videoUrl: data['videoUrl'],
            name: data['name'],
            title: data['title'],
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
    final logoUrl = widget.jsonData.logoUrl;
    final videoUrl = widget.jsonData.videoUrl;
    final name = widget.jsonData.name;
    final title = widget.jsonData.title;
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
                      title,
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
                      
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        title,
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
                                  jsonData.name,
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
                                  jsonData.title,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  jsonData.title,
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
