import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../components/bottomPlayer.dart';
import '../../../components/kBackground.dart';
import '../../../components/kText.dart';
import '../../../components/loading.dart';
import '../../../components/searchbox.dart';
import '../../../constants/colors.dart';
import '../../../providers/song.dart';
import '../details/song_player.dart';

class PlayListSongs extends StatefulWidget {
  static const routeName = '/playlistsongs';

  const PlayListSongs({Key? key}) : super(key: key);

  @override
  State<PlayListSongs> createState() => _PlayListSongsState();
}

class _PlayListSongsState extends State<PlayListSongs> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  showMusics(
    BuildContext context,
    int playlistId,
    SongData songData,
  ) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SearchBox(),
            SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<List<SongModel>>(
                    future: audioQuery.querySongs(
                      orderType: OrderType.ASC_OR_SMALLER,
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
                        height: 365,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: songs.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: QueryArtworkWidget(
                                id: songs[index].id,
                                type: ArtworkType.AUDIO,
                                artworkFit: BoxFit.cover,
                                artworkBorder: BorderRadius.circular(30),
                              ),
                              title: Text(
                                songs[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                songs[index].artist!,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              trailing: Column(
                                children: [
                                  songData.isSongInPlaylist(
                                          songs[index].id, playlistId)
                                      ? const Icon(
                                          Icons.playlist_add_check,
                                          color: pColor,
                                        )
                                      : GestureDetector(
                                          onTap: () => {
                                            setState(() {
                                              audioQuery.addToPlaylist(
                                                playlistId,
                                                songs[index].id,
                                              );
                                            }),
                                            Navigator.of(context).pop()
                                          },
                                          child: const Icon(
                                            Icons.playlist_add,
                                            color: pColor,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    PlaylistModel playlist = data['playlist'];
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => showMusics(context, playlist.id, songData),
        child: const Icon(
          Icons.add,
          color: primaryColor,
        ),
      ),
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
                          KText(
                            firstText: 'Songs of ',
                            secondText: '${playlist.playlist} Playlist',
                          ),
                          Text(
                            '${playlist.numOfSongs} songs ',
                            style: const TextStyle(
                              color: searchBoxBg,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/playlist1.png',
                          height: 210,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        child: FutureBuilder<List<SongModel>>(
                          future: audioQuery.queryAudiosFrom(
                            AudiosFromType.PLAYLIST,
                            playlist.id,
                            orderType: OrderType.ASC_OR_SMALLER,
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
                              height: size.height / 2.2,
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
                                      leading: const CircleAvatar(
                                        backgroundImage: AssetImage(
                                          'assets/images/play.gif',
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
                                      trailing: PopupMenuButton(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                        itemBuilder: (BuildContext context) => [
                                          PopupMenuItem(
                                            onTap: () => {
                                              setState(() {
                                                audioQuery.removeFromPlaylist(
                                                  playlist.id,
                                                  songs[index].id,
                                                );
                                              })
                                            },
                                            child: const Text(
                                              'Remove from list',
                                            ),
                                          ),
                                          // PopupMenuItem(
                                          //   onTap: () =>
                                          //       songData.toggleIsFav(songs[index]),
                                          //   child: Text(
                                          //     songData.isFav(songs[index].id)
                                          //         ? 'Remove from favorites'
                                          //         : 'Add to favorites',
                                          //   ),
                                          // ),

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
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Player
              const BottomPlayer(),
            ],
          ),
        ),
      ),
    );
  }
}
