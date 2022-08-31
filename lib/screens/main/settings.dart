import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zedmusic/constants/colors.dart';

import '../../components/kListTile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var notificationStatus = true;




  _notifications() {
    // TODO: Notifications
    if (kDebugMode) {
      print('Notifications');
    }
  }

  _equalizer() {
    // TODO: Equalizer
    if (kDebugMode) {
      print('Equalizer');
    }
  }

  _terms() {
    // TODO: Terms of service
    if (kDebugMode) {
      print('Terms of service');
    }
  }

  _version() {
    // TODO: Version display
    if (kDebugMode) {
      print('Version');
    }
  }

  _displayLanguage() {
    // TODO: Display Language
    if (kDebugMode) {
      print('Display Language');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 18.0,
        left: 18.0,
        top: 45.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset('assets/images/small_logo.png'),
          ),
          const SizedBox(height: 30),
          RichText(
            text: const TextSpan(
              text: 'Set',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: settingsColor,
                fontSize: 22,
              ),
              children: [
                TextSpan(
                  text: 'tings',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: settingsColor,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          KListTile(
            title: 'Notifications',
            leadChild: const Icon(
              Icons.notifications_none,
              size: 30,
              color: ambientBg,
            ),
            action: _notifications,
            trailingChild: Checkbox(
              activeColor: secondaryColor,
              checkColor: Colors.white,
             side: const BorderSide(width: 1, color:Colors.white,),
              value: notificationStatus,
              onChanged: (value) {
                setState(() {
                  notificationStatus = !notificationStatus;
                });
              },
            ),
          ),

          KListTile(
            title: 'Display language',
            leadChild: const Icon(
              Icons.language,
              size: 30,
              color: ambientBg,
            ),
            action: _displayLanguage,
            trailingChild: const Text(''),
          ),
          KListTile(
            title: 'Equalizer',
            leadChild: Image.asset(
              'assets/images/filter.png',
              color: ambientBg,
              width: 30,
            ),
            action: _equalizer,
            trailingChild: const Text(''),
          ),
          KListTile(
            title: 'Terms of service',
            leadChild: const Icon(
              Icons.info_outline,
              size: 30,
              color: ambientBg,
            ),
            action: _terms,
            trailingChild: const Text(''),
          ),

          KListTile(
            title: 'Version 0.1',
            leadChild: const Icon(
              Icons.headset,
              size: 30,
              color: ambientBg,
            ),
            action: _version,
            trailingChild: const Text(''),
          ),
        ],
      ),
    );
  }
}
