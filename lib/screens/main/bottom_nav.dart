import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zedmusic/screens/main/favorites.dart';
import 'package:zedmusic/screens/main/home.dart';
import 'package:zedmusic/screens/main/profile.dart';
import 'package:zedmusic/screens/main/settings.dart';

import '../../constants/colors.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var currentScreenIndex = 0;
  final _screens = const [
    HomeScreen(),
    FavoritesScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  _changeScreen(int index) {
    setState(() {
      currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: _changeScreen,
          currentIndex: currentScreenIndex,
          selectedItemColor: iconBg,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '',
            ),
          ],
        ),
        body: _screens[currentScreenIndex]);
  }
}
