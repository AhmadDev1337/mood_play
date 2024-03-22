// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NetworkOfflinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200),
            Lottie.asset('assets/animated/lost_connection.json', width: 200),
            SizedBox(
              height: 15,
            ),
            Text(
              "Opsss please check your connection...",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
