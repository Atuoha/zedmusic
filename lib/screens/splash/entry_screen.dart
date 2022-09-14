import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zedmusic/screens/splash/splash.dart';
import '../../components/kBackground.dart';
import '../../constants/colors.dart';
import 'package:is_first_run/is_first_run.dart';
import '../auth/auth.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  _startRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    var duration = const Duration(seconds: 4);
    if (ifr != null && !ifr) {
      Timer(duration, _navigateToAuthOrHome);
    } else {
      Timer(duration, _navigateToSplash);
    }
    print(ifr);
  }

  _navigateToSplash() {
    // Routing to Splash
    Navigator.of(context).pushNamed(SplashScreen.routeName);
  }

  _navigateToAuthOrHome() {
    //Routing to AuthScreen or Home
    //TODO: After Authentication, check if the user is authenticated and route to HomeScreen straight
    Navigator.of(context).pushNamed(AuthScreen.routeName);
  }

  @override
  void initState() {
    Permission.storage.request();
    super.initState();
    _startRun();
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
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
