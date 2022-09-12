import 'package:flutter/material.dart';

import '../constants/colors.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  var searchText = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    searchText.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
        ),
        suffixIcon: searchText.text.isNotEmpty
            ? IconButton(
                onPressed: () => setState(() {
                  searchText.text = "";
                }),
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
              )
            : const SizedBox.shrink(),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        fillColor: searchBoxBg,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ambientBg,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
