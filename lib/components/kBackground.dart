import 'package:flutter/material.dart';
import '../constants/colors.dart';

class KBackground extends StatelessWidget {
  const KBackground({
    Key? key,
    required this.child,
     this.fade = true,
  }) : super(key: key);
  final Widget child;
  final bool fade;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: primaryColor,
        image: DecorationImage(
          image: const AssetImage('assets/images/pattern.png'),
          fit: BoxFit.cover,
          opacity: fade ? 0.1 : 1,
        ),
      ),
      child: child,
    );
  }
}
