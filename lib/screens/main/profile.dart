import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zedmusic/components/kListTile.dart';

import '../../constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _editProfile() {
    // TODO: Edit Profile
    if (kDebugMode) {
      print('Edit Profile');
    }
  }

  _settings() {
    // TODO: Settings
    if (kDebugMode) {
      print('Settings');
    }
  }

  _soundEffect() {
    // TODO: Sound Effects
    if (kDebugMode) {
      print('Sound effects');
    }
  }

  _about() {
    // TODO: About app
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Wrap(
          children: const [
            Icon(
              Icons.music_note,
              size: 30,
              color: primaryColor,
            ),
            SizedBox(width: 5),
            Text(
              'ZedMusic',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: const Text(
          'Music App using a prototype by Turkan Aliyeva on Behance. Code Author: Tony Atuoha',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: btnBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Dismiss',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _logout() {
    // TODO: logout
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Wrap(
          children: const [
            Icon(
              Icons.music_note,
              size: 30,
              color: primaryColor,
            ),
            SizedBox(width: 5),
            Text(
              'ZedMusic',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: const Text(
          'Do you want to logout account?',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: btnBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: btnBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Dismiss',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
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
