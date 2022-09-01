import 'package:flutter/material.dart';

import '../constants/colors.dart';

class KText extends StatelessWidget {
  const KText({
    Key? key,
    required this.firstText,
    required this.secondText,
  }) : super(key: key);
  final String firstText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style:  const TextStyle(
          color: ambientBg,
          fontWeight: FontWeight.w300,
        ),
        children: [
          TextSpan(
            text: secondText,
            style: const TextStyle(
              color: ambientBg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
