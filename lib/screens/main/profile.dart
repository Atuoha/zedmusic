import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zedmusic/components/kListTile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
            icon: CupertinoIcons.square_pencil,
            action: () {},
          ),
          KListTile(
            title: 'Settings',
            icon: Icons.settings,
            action: () {},
          ),
          KListTile(
            title: 'Sound effects',
            icon: Icons.volume_down_outlined,
            action: () {},
          ),
          KListTile(
            title: 'About app',
            icon: Icons.info_outline,
            action: () {},
          ),
          KListTile(
            title: 'Log out',
            icon: Icons.logout,
            action: () {},
          ),
        ],
      ),
    );
  }
}
