import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../components/kBackground.dart';
import '../../../components/kText.dart';
import '../../../components/seekbar.dart';
import '../../../constants/colors.dart';
import '../../../providerdata.dart';
import '../../../providers/song.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SongPlayer extends StatefulWidget {
  SongPlayer({
    Key? key,
    required this.song,
    required this.player,
    required this.songs,
  }) : super(key: key);
  SongModel song;
  final AudioPlayer player;
  final List songs;

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> with WidgetsBindingObserver {
  final OnAudioQuery audioQuery = OnAudioQuery();

  // this will be holding the current index of the music list array
  var currentSongIndex = 0;

  // Return current song index
  _returnCurrentIndex() {
    widget.songs.asMap().forEach((key, song) {
      if (song.id == widget.song.id) {
        currentSongIndex = key;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _returnCurrentIndex();
    widget.player.play();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      // player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        widget.player.positionStream,
        widget.player.bufferedPositionStream,
        widget.player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    var songData = Provider.of<SongData>(context);

    // PLAY SONG
    _playSong() {
      setState(() {
        widget.player.play();
      });
    }

    // PAUSE SONG
    _pauseSong() {
      setState(() {
        widget.player.pause();
      });
    }

    bool isRepeatOne = false;
    bool isShuffle = false;

    _toggleIsRepeat() {
      setState(() {
        isRepeatOne = !isRepeatOne;
      });

      if (isRepeatOne) {
        setState(() {
          widget.player.setLoopMode(LoopMode.one);
          widget.player.loopMode;
        });
      } else {
        setState(() {
          widget.player.setLoopMode(LoopMode.all);
          widget.player.loopMode;
        });
      }
    }

    _toggleIsShuffle() {
      setState(() {
        isShuffle = !isShuffle;
        widget.player.setShuffleModeEnabled(isShuffle);
      });
      if (isShuffle) {
        widget.player.shuffle();
      }
    }

    // To next song
    _skipNext() {
      if (currentSongIndex != widget.songs.length - 1) {
        setState(() {
          currentSongIndex += 1;
        });
      }

      Timer(const Duration(seconds: 1), () {
        setState(() {
          songData.setPlayingSong(widget.songs[currentSongIndex]);
        });

        setState(() {
          widget.song = widget.songs[currentSongIndex];
          songData.player.setAudioSource(
            AudioSource.uri(
              Uri.parse(widget.songs[currentSongIndex].uri),
            ),
          );
        });
      });

      widget.player.play();
    }

    // to previous song
    _skipPrevious() {
      if (currentSongIndex != 0) {
        setState(() {
          currentSongIndex -= 1;
        });
      }

      Timer(const Duration(microseconds: 1), () {
        setState(() {
          songData.setPlayingSong(widget.songs[currentSongIndex]);
        });

        setState(() {
          widget.song = widget.songs[currentSongIndex];
          songData.player.setAudioSource(
            AudioSource.uri(
              Uri.parse(widget.songs[currentSongIndex].uri),
            ),
          );
        });
      });

      widget.player.play();
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: KBackground(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 18.0,
            top: 45.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          height: 25,
                          width: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 50),
                    Image.asset('assets/images/small_logo.png'),
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          onTap: () => songData.toggleIsFav(widget.song),
                          child: Text(
                            songData.isFav(widget.song.id)
                                ? 'Remove from favorites'
                                : 'Add to favorites',
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => {},
                          child: const Text(
                            'Set as ringtone',
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => {},
                          child: const Text(
                            'Delete Song',
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => {},
                          child: const Text(
                            'Share',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const KText(
                  firstText: 'Pla',
                  secondText: 'yer',
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: Hero(
                    tag: widget.song.id,
                    transitionOnUserGestures: true,
                    child: QueryArtworkWidget(
                      id: widget.song.id,
                      type: ArtworkType.AUDIO,
                      artworkFit: BoxFit.cover,
                      artworkBorder: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width / 1.5,
                      child: Text(
                        widget.song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ambientBg,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => songData.toggleIsFav(widget.song),
                      child: Icon(
                        songData.isFav(widget.song.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: songData.isFav(widget.song.id)
                            ? Colors.red
                            : ambientBg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.song.artist == '<unknown>'
                      ? 'Unknown Artist'
                      : widget.song.artist!,
                  style: const TextStyle(
                    color: searchBoxBg,
                  ),
                ),
                const SizedBox(height: 40),
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: widget.player.seek,
                    );
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _toggleIsRepeat(),
                      child: Icon(
                        isRepeatOne ? Icons.repeat_one_outlined : Icons.repeat,
                        color: accentColor,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _skipPrevious(),
                      child: const Icon(
                        Icons.skip_previous_outlined,
                        color: accentColor,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        widget.player.playing
                            ? setState(() {
                                _pauseSong();
                              })
                            : setState(() {
                                _playSong();
                              })
                      },
                      child: Icon(
                        widget.player.playing
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outlined,
                        color: accentColor,
                        size: 60,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _skipNext(),
                      child: const Icon(
                        Icons.skip_next_outlined,
                        color: accentColor,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _toggleIsShuffle(),
                      child: Icon(
                        Icons.shuffle_outlined,
                        color: isShuffle ? accentColor : Colors.grey.shade500,
                        size: 30,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
