import 'package:flutter/material.dart';

class Song extends ChangeNotifier {
  final String id;
  final String title;
  final String artisteName;
  final String albumCoverUrl;
  final String audio;
  bool isFavorite;

  Song({
    required this.id,
    required this.artisteName,
    required this.albumCoverUrl,
    required this.title,
    required this.audio,
    this.isFavorite = false,
  });

  toggleIsFav(){
    isFavorite = !isFavorite;
  }
}
