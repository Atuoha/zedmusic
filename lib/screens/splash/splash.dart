import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';
import 'package:dots_indicator/dots_indicator.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var contentIndex = 0;
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
      'first_line': 'DOWNLOAD',
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
      print('end of screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: GestureDetector(
        onTap: () => incrementIndex(),
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            color: primaryColor,
            image: DecorationImage(
              image: AssetImage('assets/images/pattern.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
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
                Expanded(
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
