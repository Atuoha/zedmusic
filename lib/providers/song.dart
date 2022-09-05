import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongData extends ChangeNotifier {
  var songsLength = 0;

  final OnAudioQuery audioQuery = OnAudioQuery();

  updateSongsLength(int number) {
    songsLength == number;
    notifyListeners();
  }

  bool isSongInPlaylist(int songId,  int playlistId) {
    var status = false;
    FutureBuilder<List<SongModel>>(
        future: audioQuery.queryAudiosFrom(
          AudiosFromType.PLAYLIST,
          playlistId,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          ignoreCase: true,
        ),
        builder: (context, item) {
          var playListSongs = item.data;

          playListSongs?.forEach((playlistSong) {
            if (playlistSong.id == songId) {
              status = true;
              print(status);
            } else {
              status = false;
              print(status);
            }
          });
          return const Text('');
        });
    return status;
  }

  toggleIsFav(SongModel song) {
    switch (isFav(song.id)) {
      case true:
        _favoritesSongs.removeWhere((songs) => songs.id == song.id);
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
