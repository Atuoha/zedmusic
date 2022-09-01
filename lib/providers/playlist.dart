import 'package:flutter/material.dart';
import 'package:zedmusic/models/playlist.dart';
import 'package:zedmusic/models/song.dart';

class PlayListData extends ChangeNotifier {
  PlayList findById(String id) {
    return _playLists.firstWhere((playlist) => playlist.id == id);
  }

  final _playLists = [
    PlayList(
      id: DateTime.now().toString(),
      title: 'Havana',
      imgAsset: '',
      songs: [
        Song(
          id: DateTime.now().toString(),
          artisteName: 'Calibri',
          albumCoverUrl: 'assets/images/albums/a.jpeg',
          title: 'Havanah',
          audio: '',
        )
      ],
    )
  ];
}
