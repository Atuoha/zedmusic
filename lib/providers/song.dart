import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongData extends ChangeNotifier {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final player = AudioPlayer();

  late SongModel playingSong;
  bool isPlaying = false;
  bool isPaused = false;

  setPlayingSong(SongModel song) {
    playingSong = song;
    isPlaying = true;
    isPaused = false;
    notifyListeners();
  }

  setIsPlaying(bool status) {
    isPlaying = status;
    isPaused = !status;
    notifyListeners();
  }

  bool isSongInPlaylist(int songId,
      int playlistId,) {
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

  List<SongModel> songList = [];
  var currentSongIndex = 0;

  setCurrentSongIndex(songIndex) {
    currentSongIndex = songIndex;
    notifyListeners();
  }

  setSongs(List<SongModel> songs) {
    songList = songs;
    notifyListeners();
  }

  final List<SongModel> _favoritesSongs = [];


  // managing auth type
  var authType = 0; // 0 will be for EMAIL AND PASSWORD which is default while 1 will be GOOGLE AUTH
  updateAuthType() {
    authType = 1; // 1 representing auth using GOOGLE
    notifyListeners();
  }

  resetAuthType(){
    authType = 0; // 0 representing auth using EMAIL AND PASSWORD
    notifyListeners();
  }

}
