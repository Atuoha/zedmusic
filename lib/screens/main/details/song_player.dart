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
  const SongPlayer({Key? key, required this.song}) : super(key: key);
  final SongModel song;

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> with WidgetsBindingObserver {
  final OnAudioQuery audioQuery = OnAudioQuery();

  final player = AudioPlayer();

  // PLAY SONG
  _playSong(String? uri) {
    player.play();
  }

  // PAUSE SONG
  _pauseSong(String? uri) {
    player.pause();
  }

  bool isRepeatOne = false;
  bool isShuffle = false;

  _toggleIsRepeat() {
    setState(() {
      isRepeatOne = !isRepeatOne;
    });

    if (isRepeatOne) {
      setState(() {
        player.setLoopMode(LoopMode.one);
        player.loopMode;
      });
    } else {
      setState(() {
        player.setLoopMode(LoopMode.all);
        player.loopMode;
      });
    }
  }

  _toggleIsShuffle() {
    setState(() {
      isShuffle = !isShuffle;
      player.setShuffleModeEnabled(isShuffle);
    });
    if (isShuffle) {
      player.shuffle();
    }
  }

  _skipNext() {
    if (player.hasNext) {
      player.seekToNext();
    }
  }

  _skipPrevious() {
    if (player.hasPrevious) {
      player.seekToPrevious();
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    try {
      player.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.song.uri!),
        ),
      );
      player.play();
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

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    var songData = Provider.of<SongData>(context);
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
                  child: QueryArtworkWidget(
                    id: widget.song.id,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    artworkBorder: BorderRadius.circular(20),
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

                //TODO: Music Progress and Seeking
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //
                //
                //     Text(
                //       player.position.toString(),
                //       style: const TextStyle(
                //         color: accentColor,
                //       ),
                //     ),
                //     Text(
                //       player.bufferedPosition.toString().substring(0, 7),
                //       style: const TextStyle(
                //         color: accentColor,
                //       ),
                //     ),
                //   ],
                // ),
                // SliderTheme(
                //   data: SliderThemeData(
                //     overlayShape: SliderComponentShape.noOverlay,
                //     trackHeight: 1,
                //   ),
                //   child: Container(
                //     width: 800,
                //     child: Slider(
                //       onChanged: (double value) {},
                //       value: 50,
                //       thumbColor: accentColor,
                //       activeColor: accentColor,
                //       inactiveColor: Colors.grey.shade400,
                //       max: 200,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),

                StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition:
                            positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: player.seek,
                      );
                    }),

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
                        player.playing
                            ? setState(() {
                                _pauseSong(widget.song.uri);
                              })
                            : setState(() {
                                _playSong(widget.song.uri);
                              })
                      },
                      child: Icon(
                        player.playing
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

class _positionDataStream {}
