import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/song.dart';
import '../screens/main/details/song_player.dart';

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({Key? key}) : super(key: key);

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  @override
  Widget build(BuildContext context) {

    var songData = Provider.of<SongData>(context);
    var songList = [];

    // PLAY SONG
    _playSong(String? uri) {
      try {
        songData.player.setAudioSource(
          AudioSource.uri(
            Uri.parse(uri!),
          ),
        );
      } on Exception {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: primaryColor,
            content: Text(
              'Song can not play!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }

    // CONTINUE SONG
    _continueSong() {
      songData.player.play();
    }

    // PAUSE SONG
    _pauseSong() {
      songData.player.pause();
    }
    Size size = MediaQuery.of(context).size;


    return songData.isPlaying
        ? Positioned(
      bottom: 0,
      child: Container(
        height: 80,
        width: size.width,
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SongPlayer(
                  song: songData.playingSong,
                  player: songData.player,
                  songs: songList
                ),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: QueryArtworkWidget(
                id: songData.playingSong.id,
                type: ArtworkType.AUDIO,
                artworkFit: BoxFit.cover,
                artworkBorder: BorderRadius.circular(30),
              ),
              title: Text(
                songData.playingSong.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                songData.playingSong.artist!,
                style: TextStyle(
                  color: Colors.grey.shade300,
                ),
              ),
              trailing: GestureDetector(
                onTap: () => {
                  songData.player.playing
                      ? setState(() {
                    _pauseSong();
                  })
                      : setState(() {
                    _continueSong();
                  })
                },
                child: Icon(
                  songData.player.playing
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: ambientBg,
                ),
              ),
            ),
          ),
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}
