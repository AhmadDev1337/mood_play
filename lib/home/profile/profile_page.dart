import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Song {
  final String imgUrl;
  final String logoUrl;
  final String videoUrl;
  final String name;
  final String title;
  final DetailPageData detailPage;

  Song({
    required this.imgUrl,
    required this.logoUrl,
    required this.videoUrl,
    required this.name,
    required this.title,
    required this.detailPage,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      imgUrl: json['imgUrl'],
      logoUrl: json['logoUrl'],
      videoUrl: json['videoUrl'],
      name: json['name'],
      title: json['title'],
      detailPage: DetailPageData.fromJson(json['detailPage']),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://pastebin.com/raw/a5GSZ8L9'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['songs'] is List<dynamic>) {
        // Periksa apakah data adalah list
        final songsJson = jsonData['songs'] as List<dynamic>;
        setState(() {
          songs = songsJson.map((songJson) => Song.fromJson(songJson)).toList();
        });
      } else {
        throw Exception('Failed to load songs data');
      }
    } else {
      Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: SpinKitWave(
              color: Colors.cyan,
              size: 25,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // Atur jumlah item dalam satu baris
        children: List.generate(
          songs.length,
          (index) {
            final song = songs[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(song: song),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          song.imgUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(song.title),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

class DetailPage extends StatelessWidget {
  final Song song;

  const DetailPage({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${song.detailPage.nameAccount}'),
            Image.network(song.detailPage.fotoAccount),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPageData {
  final String nameAccount;
  final String fotoAccount;

  DetailPageData({
    required this.nameAccount,
    required this.fotoAccount,
  });

  factory DetailPageData.fromJson(Map<String, dynamic> json) {
    return DetailPageData(
      nameAccount: json['nameAccount'],
      fotoAccount: json['fotoAccount'],
    );
  }
}
