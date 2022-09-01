import 'package:flutter/material.dart';
import '../models/song.dart';

class SongData extends ChangeNotifier {
  toggleIsFav(String id) {
    var song = _songs.firstWhere((song) => song.id == id);
    song.toggleIsFav();
    notifyListeners();
  }

  bool isFav(String id) {
    return _songs.any((song) => song.isFavorite);
  }

  Song findById(String id) {
    return _songs.firstWhere((song) => song.id == id);
  }

  final _songs = [
    Song(
      id: DateTime.now().toString(),
      artisteName: '',
      title: '',
      audio: '',
      albumCoverUrl: '',
    ),

    Song(
      id: DateTime.now().toString(),
      artisteName: '',
      title: '',
      audio: '',
      albumCoverUrl: '',
    ),

  ];
}
