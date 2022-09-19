import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/song.dart';
import '../screens/main/now_playing/song_player.dart';

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({Key? key, required this.songData}) : super(key: key);
  final SongData songData;

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  var currentSongIndex = 0;

  // handle songs
  _handleSongs() {
    widget.songData.songList.asMap().forEach((key, song) {
      if (song.id == widget.songData.playingSong.id) {
        currentSongIndex = key;

        widget.songData.player.playerStateStream.listen((state) {
          switch (state.processingState) {
            case ProcessingState.completed:
              if (widget.songData.songList.length > 1) {
                if (key < widget.songData.songList.length - 1) {
                  Timer(const Duration(seconds: 1), () {
                    widget.songData.player.play();
                  });

                  // setting playing song on provider
                  widget.songData
                      .setPlayingSong(widget.songData.songList[key + 1]);

                  widget.songData.setIsPlaying(true);
                  widget.songData.player.setAudioSource(
                    AudioSource.uri(
                      Uri.parse(widget.songData.songList[key + 1].uri!),
                      tag: MediaItem(
                        // Specify a unique ID for each media item:
                        id: '${widget.songData.songList[key + 1].id}',
                        // Metadata to display in the notification:
                        artist: widget.songData.songList[key + 1].artist,
                        duration: Duration(
                          minutes: widget.songData.songList[key + 1].duration!,
                        ),
                        title: widget.songData.songList[key + 1].title,
                        album: widget.songData.songList[key + 1].album,
                        // artUri: Uri.parse(widget.songs[currentSongIndex].uri!),
                      ),
                    ),
                  );
                }
              }
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _handleSongs();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var songData = Provider.of<SongData>(context);

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
      setState(() {
        songData.player.play();
        songData.setIsPlaying(true);
      });
    }

    // PAUSE SONG
    _pauseSong() {
      setState(() {
        songData.player.pause();
        songData.setIsPlaying(false);
      });
    }

    Size size = MediaQuery.of(context).size;

    return songData.isPlaying || songData.isPaused
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
                        songs: songData.songList,
                        songData: songData,
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
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: pColor,
                      ),
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
