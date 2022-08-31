import 'package:flutter/material.dart';
import '../constants/colors.dart';

class KListTile extends StatelessWidget {
  const KListTile({
    Key? key,
    required this.title,
    required this.action,
    required this.leadChild,
    required this.trailingChild,
  }) : super(key: key);
  final String title;
  final Function action;
  final Widget leadChild;
  final Widget trailingChild;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>action(),
      child: ListTile(
        contentPadding: const EdgeInsets.only(top:12,),
        leading: leadChild,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        trailing: trailingChild,
      ),
    );
  }
}
