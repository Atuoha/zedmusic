import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:zedmusic/screens/main/details/song_player.dart';
import '../../../components/kBackground.dart';
import '../../../components/kText.dart';
import '../../../components/loading.dart';
import '../../../components/searchbox.dart';
import '../../../constants/colors.dart';
import '../../../providers/song.dart';
import 'package:just_audio/just_audio.dart';

class SongsView extends StatefulWidget {
  static const routeName = '/songs';

  const SongsView({Key? key}) : super(key: key);

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int songsLength = data['length'];
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
      songData.player.play();
    }

    // PAUSE SONG
    _pauseSong() {
      songData.player.pause();
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
            top: 45.0,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                    Icons.chevron_left,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 50),
                          Image.asset('assets/images/small_logo.png'),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const SearchBox(),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const KText(
                            firstText: 'All',
                            secondText: ' Songs',
                          ),
                          Text(
                            '$songsLength songs ',
                            style: const TextStyle(
                              color: searchBoxBg,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<List<SongModel>>(
                        future: audioQuery.querySongs(
                          orderType: OrderType.ASC_OR_SMALLER,
                          uriType: UriType.EXTERNAL,
                          sortType: null,
                          ignoreCase: true,
                        ),
                        builder: (context, item) {
                          var songs = item.data;
                          if (songs == null) {
                            return const Center(
                              child: Loading(),
                            );
                          }
                          if (songs.isEmpty) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/empty.png',
                                  width: 90,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Songs are empty!',
                                  style: TextStyle(
                                    color: searchBoxBg,
                                  ),
                                ),
                              ],
                            );
                          }

                          return SizedBox(
                            height: size.height / 1,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: songs.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SongPlayer(
                                          song: songs[index],
                                          player: songData.player,
                                        ),
                                      ),
                                    );
                                    songData.setPlayingSong(songs[index]);
                                    _playSong(songs[index].uri);
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Hero(
                                      tag: songs[index].id,
                                      child: QueryArtworkWidget(
                                        id: songs[index].id,
                                        type: ArtworkType.AUDIO,
                                        artworkFit: BoxFit.cover,
                                        artworkBorder:
                                            BorderRadius.circular(30),
                                      ),
                                    ),
                                    title: Text(
                                      songs[index].title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      songs[index].artist!,
                                      style: TextStyle(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    trailing: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => songData
                                              .toggleIsFav(songs[index]),
                                          child: Icon(
                                            songData.isFav(songs[index].id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                songData.isFav(songs[index].id)
                                                    ? Colors.red
                                                    : ambientBg,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        GestureDetector(
                                          onTap: () => {
                                            if (songData.isPlaying)
                                              {
                                                setState(() {
                                                  songData.player.playing
                                                      ? _pauseSong()
                                                      : _continueSong();
                                                })
                                              }
                                            else
                                              {
                                                songData.setPlayingSong(
                                                    songs[index]),
                                                setState(() {
                                                  _playSong(songs[index].uri);
                                                })
                                              }
                                          },
                                          child: Icon(
                                            songData.isPlaying
                                                ? songData.playingSong.id ==
                                                        songs[index].id
                                                    ? songData.player.playing
                                                        ? Icons.pause_circle
                                                        : Icons.play_circle
                                                    : Icons.play_circle
                                                : Icons.play_circle,
                                            color: ambientBg,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              songData.isPlaying
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
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
