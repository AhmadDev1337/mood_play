// ignore_for_file: unused_field, unnecessary_null_comparison, avoid_print, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, unnecessary_import, unused_local_variable

import 'dart:convert';
import 'dart:ui';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class JsonData {
  final String imgUrl;
  final String name;
  final String author;
  final String actors;
  final String score;
  final String review;
  final String view;
  final String desc;
  final List<Season> seasons;

  JsonData({
    required this.imgUrl,
    required this.name,
    required this.author,
    required this.actors,
    required this.score,
    required this.review,
    required this.view,
    required this.desc,
    required this.seasons,
  });
}

class Season {
  final int season;
  final List<Video> videos;

  Season({required this.season, required this.videos});
}

class Video {
  final int index;
  final String videoId;

  Video({required this.index, required this.videoId});
}

class KDramaPage extends StatefulWidget {
  const KDramaPage({Key? key}) : super(key: key);

  @override
  State<KDramaPage> createState() => _KDramaPageState();
}

class _KDramaPageState extends State<KDramaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<JsonData> jsonDataList = [];

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<JsonData> filteredJsonDataList = [];

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
  }

  Future<void> fetchData() async {
    const singleJsonUrl = 'https://pastebin.com/raw/RGE55JsV';

    try {
      final response = await http.get(Uri.parse(singleJsonUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        jsonDataList = jsonData.map<JsonData>((data) {
          final List<Season> seasons =
              data['seasons'].map<Season>((seasonData) {
            final List<Video> videos =
                seasonData['videos'].map<Video>((videoData) {
              return Video(
                index: videoData['index'],
                videoId: videoData['videoId'],
              );
            }).toList();

            return Season(season: seasonData['season'], videos: videos);
          }).toList();

          return JsonData(
            imgUrl: data['imgUrl'],
            name: data['name'],
            author: data['author'],
            actors: data['actors'],
            score: data['score'],
            review: data['review'],
            view: data['view'],
            desc: data['desc'],
            seasons: seasons,
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
                SizedBox(height: 60),
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
                                        builder: (context) => DetailPage(
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
                      jsonData.author,
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
        Positioned(
          top: 5,
          left: 5,
          child: _buildIconText(
            IconlyLight.star,
            Colors.orange[300]!,
            jsonData.score,
          ),
        ),
      ],
    );
  }
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

  List<Offset> currentOffsets = <Offset>[];
  List<Offset> offsets = <Offset>[];
  List<List<Offset>> allOffsets = [];
  late YoutubePlayerController _controller;

  Offset? lastPosition;

  late List<String> videoIds;

  @override
  void initState() {
    super.initState();
    videoIds = getVideoIdsForSeason(widget.jsonData.seasons.first);
  }

  List<String> getVideoIdsForSeason(Season season) {
    return season.videos.map((video) => video.videoId).toList();
  }

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
    final name = widget.jsonData.name;
    final author = widget.jsonData.author;
    final actors = widget.jsonData.actors;
    final score = widget.jsonData.score;
    final review = widget.jsonData.review;
    final view = widget.jsonData.view;
    final desc = widget.jsonData.desc;
    final seasons = widget.jsonData.seasons.first;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WeHome",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Center(
            child: Text(
              "WeHome",
              style: GoogleFonts.acme(
                  color: Color(0xFFE1261C),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
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
                        Column(
                          children: [
                            Icon(IconlyLight.star, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Like",
                                style: TextStyle(
                                  color: Colors.grey,
                                ))
                          ],
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
                      ],
                    ),
                    const SizedBox(
                      height: 20,
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
                    for (Season season in widget.jsonData.seasons)
                      ExpansionTile(
                        title: Container(
                          padding: EdgeInsets.all(10),
                          color: Color(0xFFE1261C),
                          child: Text('Season ${season.season}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                        children: <Widget>[
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (Video video in season.videos)
                                GestureDetector(
                                  onTap: () {
                                    _showPlayDialog(context, video.videoId);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xFFE1261C),
                                    ),
                                    child: Text('Eps ${video.index}'),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
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
