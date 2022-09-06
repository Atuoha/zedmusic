import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../components/kBackground.dart';
import '../../../components/kText.dart';
import '../../../constants/colors.dart';
import '../../../providers/song.dart';
import 'package:just_audio/just_audio.dart';

class SongPlayer extends StatelessWidget {
  static const routeName = '/songplayer';

  SongPlayer({Key? key}) : super(key: key);
  final OnAudioQuery audioQuery = OnAudioQuery();
  final player = AudioPlayer();

  // PLAY SONG
  _playSong(String? uri) {
    player.setAudioSource(
      AudioSource.uri(
        Uri.parse(uri!),
      ),
    );
    player.play();
  }

  // PAUSE SONG
  _pauseSong(String? uri) {
    player.setAudioSource(
      AudioSource.uri(
        Uri.parse(uri!),
      ),
    );
    player.pause();
  }

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    SongModel song = data['song'];
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
                          onTap: () => songData.toggleIsFav(song),
                          child: Text(
                            songData.isFav(song.id)
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
                  height: 230,
                  width: double.infinity,
                  child: QueryArtworkWidget(
                    id: song.id,
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
                        song.title,
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
                      onTap: () => songData.toggleIsFav(song),
                      child: Icon(
                        songData.isFav(song.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: songData.isFav(song.id) ? Colors.red : ambientBg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  song.artist!,
                  style: const TextStyle(
                    color: searchBoxBg,
                  ),
                ),
                const SizedBox(height: 20),

                //TODO: Music Progress and Seeking
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => {},
                      child: const Icon(
                        Icons.repeat,
                        color: accentColor,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {},
                      child: const Icon(
                        Icons.skip_previous_outlined,
                        color: accentColor,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {},
                      child: const Icon(
                        Icons.play_circle_outlined,
                        color: accentColor,
                        size: 60,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {},
                      child: const Icon(
                        Icons.skip_next_outlined,
                        color: accentColor,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {},
                      child: const Icon(
                        Icons.shuffle_outlined,
                        color: accentColor,
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
