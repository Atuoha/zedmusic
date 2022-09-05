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

class SongsView extends StatelessWidget {
  static const routeName = '/songs';

  SongsView({Key? key}) : super(key: key);
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int songsLength = data['length'];
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
                            onTap: () => Navigator.of(context).pushNamed(
                              SongPlayer.routeName,
                              arguments: {
                                'song': songs[index],
                              },
                            ),
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
                                    onTap: () =>
                                        songData.toggleIsFav(songs[index]),
                                    child: Icon(
                                      songData.isFav(songs[index].id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: songData.isFav(songs[index].id)
                                          ? Colors.red
                                          : ambientBg,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Icon(
                                    Icons.play_circle,
                                    color: ambientBg,
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
      ),
    );
  }
}
