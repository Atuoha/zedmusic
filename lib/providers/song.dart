import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongData extends ChangeNotifier {

  final OnAudioQuery audioQuery = OnAudioQuery();


  bool isSongInPlaylist(int songId, int playlistId) {
    bool status = false;
    return status;
  }

  toggleIsFav(SongModel song) {
    switch (isFav(song.id)) {
      case true:
        _favoritesSongs.removeWhere(
          (songs) => songs.id == song.id,
        );
        break;
      case false:
        _favoritesSongs.add(song);
        break;
    }
    notifyListeners();
  }

  bool isFav(int id) {
    return _favoritesSongs.any(
      (song) => song.id == id,
    );
  }

  getFavorites() {
    return [..._favoritesSongs];
  }

  final List<SongModel> _favoritesSongs = [];
}
