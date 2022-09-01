import 'package:zedmusic/models/song.dart';

class Downloaded {
  final String id;
  final String title;
  final String imgAsset;
  final List<Song> songs;

  Downloaded({
    required this.id,
    required this.title,
    required this.imgAsset,
    required this.songs,
  });
}
