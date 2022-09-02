import 'package:flutter/material.dart';

import '../constants/colors.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        fillColor: searchBoxBg,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
