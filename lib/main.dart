// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'home/bar_controller.dart';

AppOpenAd? appOpenAd;

loadAppOpenAd() {
  AppOpenAd.load(
      adUnitId: "ca-app-pub-8363980854824352/4258470246",
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
        appOpenAd = ad;
        appOpenAd!.show();
      }, onAdFailedToLoad: (error) {
        log('Open App ad failed to load: $error');
      }),
      orientation: AppOpenAd.orientationPortrait);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoodPlay',
      home: BarController(),
    );
  }
}
