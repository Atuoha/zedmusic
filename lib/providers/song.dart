import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongData extends ChangeNotifier {
  var songsLength = 0;

  updateSongsLength(int number){
    songsLength == number;
    notifyListeners();
  }


  toggleIsFav(SongModel song) {
    switch (isFav(song.id)) {
      case true:
        _favoritesSongs.remove(song);
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

  getFavorites(){
    return [..._favoritesSongs];
  }

  final List<SongModel> _favoritesSongs = [];
}
