import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../components/loading.dart';
import '../../../constants/colors.dart';
import '../../../providers/song.dart';
import '../broader_views/songs.dart';
import '../details/song_player.dart';

class Songs extends StatefulWidget {
  Songs({Key? key}) : super(key: key);

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final player = AudioPlayer();

  var songsLength;

  @override
  Widget build(BuildContext context) {
    final OnAudioQuery audioQuery = OnAudioQuery();
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

    // Fnc for loading new music on track and taking them to the song_player screen
    _loadNewSongOnTrack(SongModel song) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SongPlayer(
            song: song,
            player: songData.player,
              songs: songList,
            songData: songData,
          ),
        ),
      );
      songData.setPlayingSong(song);
      _playSong(song.uri);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Songs',
                style: TextStyle(
                  color: ambientBg,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  SongsView.routeName,
                  arguments: {'length': songsLength},
                ),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: searchBoxBg,
                  ),
                ),
              )
            ],
          ),
        ),
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
            songsLength = songs.length;
            return SizedBox(
              height: 220,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                // scrollDirection: Axis.horizontal,
                itemCount: songs.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: GestureDetector(
                    onTap: () =>
                        _loadNewSongOnTrack(songs[index]),
                    child: ListTile(
                      leading: songs[index].isMusic!
                          ? QueryArtworkWidget(
                        id: songs[index].id,
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.cover,
                        artworkBorder:
                        BorderRadius.circular(30),
                      )
                          : const Center(
                        child: Icon(
                          Icons.music_note,
                          color: pColor,
                        ),
                      ),
                      title: Text(
                        songs[index].displayName,
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
                      trailing: GestureDetector(
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
                                  songs[index])
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
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
