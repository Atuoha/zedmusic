import 'package:zedmusic/models/song.dart';

class PlayList {
  final String id;
  final String title;
  final String imgAsset;
  final List<Song> songs;

  PlayList({
    required this.id,
    required this.title,
    required this.imgAsset,
    required this.songs,
  });
}
