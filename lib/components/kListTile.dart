import 'package:flutter/material.dart';
import '../constants/colors.dart';

class KListTile extends StatelessWidget {
  const KListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.action,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>action,
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
          color: ambientBg,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
