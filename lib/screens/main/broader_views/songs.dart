import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:zedmusic/screens/main/now_playing/song_player.dart';
import '../../../components/bottomPlayer.dart';
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
    var songList = [];

    // PLAY SONG
    _playSong(SongModel song) {
      try {
        songData.player.setAudioSource(
          AudioSource.uri(
            Uri.parse(song.uri!),
            tag: MediaItem(
              // Specify a unique ID for each media item:
              id: '${song.id}',
              // Metadata to display in the notification:
              artist: song.artist,
              duration: Duration(minutes: song.duration!),
              title: song.title,
              album: song.album,
              // artUri: Uri.parse(song.uri!),
            ),
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

    // Fnc for loading new music on track and taking them to the song_player screen
    _loadNewSongOnTrack(
      SongModel song,
      List<SongModel> songs,
    ) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => SongPlayer(
                song: song,
                player: songData.player,
                songs: songList,
                songData: songData,
              ),
            ),
          )
          .then((value) => setState(() {}));
      songData.setSongs(songs);
      songData.setPlayingSong(song);
      _playSong(song);
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
                          songList = songs;
                          return SizedBox(
                            height: size.height / 1,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: songs.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () =>
                                      _loadNewSongOnTrack(songs[index], songs),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Hero(
                                      tag: songs[index].id,
                                      child: songs[index] != null
                                          ? QueryArtworkWidget(
                                              id: songs[index].id,
                                              type: ArtworkType.AUDIO,
                                              artworkFit: BoxFit.cover,
                                              artworkBorder:
                                                  BorderRadius.circular(30),
                                              nullArtworkWidget: const Icon(
                                                Icons.music_note,
                                                color: pColor,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.music_note,
                                              color: pColor,
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
                                          /* function is used for playing and pause song and it also considers the songId of
                                          the song which is playing
                                          */
                                          onTap: () => {
                                            if (songData.isPlaying &&
                                                songData.playingSong.id ==
                                                    songs[index].id)
                                              {
                                                setState(() {
                                                  songData.player.playing
                                                      ? _pauseSong()
                                                      : _continueSong();
                                                })
                                              }
                                            else if (songData.playingSong.id !=
                                                songs[index].id)
                                              {
                                                _loadNewSongOnTrack(
                                                    songs[index], songs)
                                              }
                                            else
                                              {
                                                songData.setPlayingSong(
                                                    songs[index]),
                                                setState(() {
                                                  _playSong(songs[index]);
                                                })
                                              }
                                          },
                                          /* This icon state changes everything and adjusts itself based on the current
                                            state of the player and check the songID of the playing song so as to change
                                            it's icon to pause and the others to play
                                          */
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

              // Bottom Player
              BottomPlayer(
                songData: songData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
