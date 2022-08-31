import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zedmusic/screens/auth/auth.dart';
import '../../components/kBackground.dart';
import '../../components/loading.dart';
import '../../constants/colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var contentIndex = 0;
  var isLoading = false;
  var splashContents = [
    {
      'first_line': 'ENJOY THE BEST',
      'second_line': 'MUSIC WITH US',
      'img': 'assets/images/spl_img1.png'
    },
    {
      'first_line': 'SING A SONG',
      'second_line': 'WITH US',
      'img': 'assets/images/spl_img2.png'
    },
    {
      'first_line': 'DOWNLOADS',
      'second_line': 'YOUR MUSIC',
      'img': 'assets/images/spl_img3.png'
    },
  ];

  incrementIndex() {
    if (contentIndex < splashContents.length - 1) {
      setState(() {
        contentIndex++;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      // navigate to auth screen
      Timer(const Duration(seconds: 4), () {
        Navigator.of(context).pushNamed(AuthScreen.routeName);
      });
    }
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
      body: GestureDetector(
        onTap: () => incrementIndex(),
        child: KBackground(
          fade: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 43.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    splashContents[contentIndex]['first_line']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 26,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    splashContents[contentIndex]['second_line']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
                Image.asset(
                  splashContents[contentIndex]['img']!,
                  fit: BoxFit.cover,
                ),
                isLoading
                    ? const Loading()
                    : Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: DotsIndicator(
                            dotsCount: splashContents.length,
                            position: double.parse(contentIndex.toString()),
                            decorator: const DotsDecorator(
                              activeColor: secondaryColor,
                              spacing: EdgeInsets.all(10.0),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
