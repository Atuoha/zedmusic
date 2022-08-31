import 'package:flutter/material.dart';

class KRichText extends StatelessWidget {
  const KRichText({
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
        style: const TextStyle(
          color: Colors.white70,
        ),
        children: [
          TextSpan(
            text: ' $secondText',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
