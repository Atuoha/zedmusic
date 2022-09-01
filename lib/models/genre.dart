import 'package:zedmusic/models/song.dart';

class Genre {
  final String id;
  final String title;
  final String imgAsset;
  final List<Song> songs;

  Genre({
    required this.id,
    required this.title,
    required this.imgAsset,
    required this.songs,
  });
}
