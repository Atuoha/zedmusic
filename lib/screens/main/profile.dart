import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zedmusic/components/kListTile.dart';

import '../../constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  _editProfile(){
    // TODO: Edit Profile
    if (kDebugMode) {
      print('Edit Profile');
    }
  }

  _settings(){
    // TODO: Settings
    if (kDebugMode) {
      print('Settings');
    }
  }


  _soundEffect(){
    // TODO: Sound Effects
    if (kDebugMode) {
      print('Sound effects');
    }
  }

  _about(){
    // TODO: About app
    if (kDebugMode) {
      print('About app');
    }
  }

  _logout(){
    // TODO: logout
    if (kDebugMode) {
      print('Logout');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 18.0,
        left: 18.0,
        top: 60,
      ),
      child: Column(
        children: [
          RichText(
            text: const TextSpan(
              text: 'Pro',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white70,
                fontSize: 24,
              ),
              children: [
                TextSpan(
                  text: 'file',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Image.asset('assets/images/avatar.png'),
          const SizedBox(height: 10),
          const Text(
            'Turkan Aliyeva',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          KListTile(
            title: 'Edit profile',
            leadChild: const Icon(
              CupertinoIcons.square_pencil,
              size: 30,
              color: ambientBg,
            ),
            action: _editProfile,
            trailingChild: const Text(''),
          ),
          KListTile(
            title: 'Settings',
            leadChild: const Icon(
              Icons.settings,
              size: 30,
              color: ambientBg,
            ),
            action: _settings,
            trailingChild: const Text(''),
          ),
          KListTile(
            title: 'Sound effects',
            leadChild: const Icon(
              Icons.volume_down_outlined,
              size: 30,
              color: ambientBg,
            ),
            action: _soundEffect,
            trailingChild: const Text(''),
          ),
          KListTile(
            title: 'About app',
            leadChild: const Icon(
              Icons.info_outline,
              size: 30,
              color: ambientBg,
            ),
            action: _about,
            trailingChild: const Text(''),
          ),
          KListTile(
            title: 'Log out',
            leadChild: const Icon(
              Icons.logout,
              size: 30,
              color: ambientBg,
            ),
            action: _logout,
            trailingChild: const Text(''),
          ),
        ],
      ),
    );
  }
}
