import 'package:flutter/material.dart';
import 'package:zedmusic/components/kText.dart';
import '../../components/loading.dart';
import '../../constants/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Wrap(
            children: const [
              Icon(
                Icons.music_note,
                size: 30,
                color: primaryColor,
              ),
              SizedBox(width: 5),
              Text(
                'ZedMusic',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Access Denied! Music from storage will not be fetched',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: btnBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(5),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Dismiss',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget kShowCase(
    String title,
    String imgAsset,
    String baseText,
    bool showBaseText,
    bool isMusic,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 120,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/playlist1.png'),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 9,
              child: Text(
                title,
                style: const TextStyle(
                  color: primaryColor,
                ),
              ),
            )
          ],
        ),
        showBaseText
            ? Text(
                baseText,
                style: const TextStyle(
                  color: searchBoxBg,
                ),
              )
            : const Text('')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final OnAudioQuery audioQuery = OnAudioQuery();
    final orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: const EdgeInsets.only(
        // right: 18.0,
        // left: 18.0,
        top: 45.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset('assets/images/small_logo.png'),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                fillColor: searchBoxBg,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          //  PLAYLIST SIDE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const KText(
                      firstText: 'My',
                      secondText: ' Playlist',
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(''),
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: searchBoxBg,
                        ),
                      ),
                    )
                  ],
                ),
                FutureBuilder<List<PlaylistModel>>(
                  future: audioQuery.queryPlaylists(
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    sortType: null,
                    ignoreCase: true,
                  ),
                  builder: (context, item) {
                    var playlists = item.data;
                    if (item.data == null) {
                      return const Center(
                        child: Loading(),
                      );
                    }
                    if (item.data!.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty.png',
                            width: 90,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Playlist is empty!',
                            style: TextStyle(
                              color: searchBoxBg,
                            ),
                          ),
                        ],
                      );
                    }
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: playlists!.length,
                        itemBuilder: (context, index) => kShowCase(
                          playlists[index].playlist,
                          'assets/images/playlist.png',
                          '${playlists[index].numOfSongs} songs',
                          true,
                          false,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),


          // BY GENRE
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const KText(
                      firstText: 'All',
                      secondText: ' Genres',
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(''),
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
              FutureBuilder<List<GenreModel>>(
                future: audioQuery.queryGenres(
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  sortType: null,
                  ignoreCase: true,
                ),
                builder: (context, item) {
                  var genres = item.data;
                  if (item.data == null) {
                    return const Center(
                      child: Loading(),
                    );
                  }
                  if (item.data!.isEmpty) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty.png',
                          width: 90,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Genres are empty!',
                          style: TextStyle(
                            color: searchBoxBg,
                          ),
                        ),
                      ],
                    );
                  }
                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: genres!.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: kShowCase(
                         '',
                          'assets/images/playlist.png',
                            genres[index].genre,
                          true,
                          false
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          // BY DOWNLOAD
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Downloads',
                      style: TextStyle(
                        color: ambientBg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(''),
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
                  print(songs);
                  if (item.data == null) {
                    return const Center(
                      child: Loading(),
                    );
                  }
                  if (item.data!.isEmpty) {
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
                    height: 200,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 3,
                        mainAxisSpacing: 5,
                      ),
                      // scrollDirection: Axis.horizontal,
                      itemCount: songs!.length,
                      itemBuilder: (context, index) => kShowCase(
                        songs[index].displayName,
                        songs[index].album!,
                        songs[index].artist!,
                        true,
                        true,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
