import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zedmusic/screens/splash/splash.dart';
import '../../components/kBackground.dart';
import '../../constants/colors.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushNamed(
        SplashScreen.routeName,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      body: KBackground(
        fade: false,
        child: Image.asset(
          'assets/images/logo.png',
        ),
      ),
    );
  }
}
