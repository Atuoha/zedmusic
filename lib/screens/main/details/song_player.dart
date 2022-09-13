import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../components/kBackground.dart';
import '../../../components/kText.dart';
import '../../../components/seekbar.dart';
import '../../../constants/colors.dart';
import '../../../models/provider_data.dart';
import '../../../providers/song.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SongPlayer extends StatefulWidget {
  SongPlayer({
    Key? key,
    required this.song,
    required this.player,
    required this.songs,
    required this.songData,
  }) : super(key: key);
  SongModel song;
  final AudioPlayer player;
  final List songs;
  final SongData songData;

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

  // PLAY SONG
  _playSong() {
    widget.player.play();
    widget.songData.setIsPlaying(true);
  }

  // PAUSE SONG
  _pauseSong() {
    widget.player.pause();
    widget.songData.setIsPlaying(false);
  }

  // To next song
  _skipNext() {
    if (currentSongIndex != widget.songs.length - 1) {
      currentSongIndex += 1;
    }

    setState(() {
      widget.song = widget.songs[currentSongIndex];
    });

    widget.songData.setPlayingSong(widget.songs[currentSongIndex]);
    widget.player.play();
    widget.songData.setCurrentSongIndex(currentSongIndex);
    widget.songData.setIsPlaying(true);
    widget.songData.player.setAudioSource(
      AudioSource.uri(
        Uri.parse(widget.songs[currentSongIndex].uri),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: '${widget.songs[currentSongIndex].id}',
          // Metadata to display in the notification:
          artist: widget.songs[currentSongIndex].artist,
          duration: Duration(minutes: widget.songs[currentSongIndex].duration!),
          title: widget.songs[currentSongIndex].title,
          album: widget.songs[currentSongIndex].album,
          // artUri: Uri.parse(widget.songs[currentSongIndex].uri!),
        ),
      ),
    );
  }

  // to previous song
  _skipPrevious() {
    if (currentSongIndex != 0) {
      currentSongIndex -= 1;
    }

    setState(() {
      widget.song = widget.songs[currentSongIndex];
    });

    widget.songData.setPlayingSong(widget.songs[currentSongIndex]);
    widget.player.play();
    widget.songData.setCurrentSongIndex(currentSongIndex);
    widget.songData.setIsPlaying(true);
    widget.songData.player.setAudioSource(
      AudioSource.uri(
        Uri.parse(widget.songs[currentSongIndex].uri),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: '${widget.songs[currentSongIndex].id}',
          // Metadata to display in the notification:
          artist: widget.songs[currentSongIndex].artist,
          duration: Duration(minutes: widget.songs[currentSongIndex].duration!),
          title: widget.songs[currentSongIndex].title,
          album: widget.songs[currentSongIndex].album,
          // artUri: Uri.parse(widget.songs[currentSongIndex].uri!),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _returnCurrentIndex();
    widget.player.play();
    print("THE CURRENT INDEX OF THE MUSIC IS: $currentSongIndex");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!isRepeatOne) {
      widget.player.playerStateStream.listen((state) {
        switch (state.processingState) {
          case ProcessingState.completed:
            if (currentSongIndex != widget.songs.length - 1) {
              currentSongIndex += 1;
            }

            setState(() {
              widget.song = widget.songs[currentSongIndex];
            });

            widget.songData.setPlayingSong(widget.songs[currentSongIndex]);
            widget.player.play();
            // widget.songData.setCurrentSongIndex(currentSongIndex);
            widget.songData.setIsPlaying(true);
            widget.songData.player.setAudioSource(
              AudioSource.uri(
                Uri.parse(widget.songs[currentSongIndex].uri),
                tag: MediaItem(
                  // Specify a unique ID for each media item:
                  id: '${widget.songs[currentSongIndex].id}',
                  // Metadata to display in the notification:
                  artist: widget.songs[currentSongIndex].artist,
                  duration: Duration(
                    minutes: widget.songs[currentSongIndex].duration!,
                  ),
                  title: widget.songs[currentSongIndex].title,
                  album: widget.songs[currentSongIndex].album,
                  // artUri: Uri.parse(widget.songs[currentSongIndex].uri!),
                ),
              ),
            );
        }
      });
    } else {
      widget.player.play();
    }

    super.didChangeDependencies();
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
    // var songData = Provider.of<SongData>(context);

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
                        onTap: () => {
                          //setting song current index on provider
                          widget.songData.setCurrentSongIndex(currentSongIndex),
                          Navigator.of(context).pop(),
                        },
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
                          onTap: () => widget.songData.toggleIsFav(widget.song),
                          child: Text(
                            widget.songData.isFav(widget.song.id)
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
                      nullArtworkWidget: const Center(
                        child: Icon(Icons.music_note, size: 80, color: pColor),
                      ),
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
                      onTap: () => widget.songData.toggleIsFav(widget.song),
                      child: Icon(
                        widget.songData.isFav(widget.song.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.songData.isFav(widget.song.id)
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
