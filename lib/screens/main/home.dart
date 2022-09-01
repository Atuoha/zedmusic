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
    Size size  = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/images/small_logo.png'),
            ),
            const SizedBox(height: 15),
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
                          itemBuilder: (context, index) =>  Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: QueryArtworkWidget(
                                    id: playlists[index].id,
                                    type: ArtworkType.PLAYLIST,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  playlists[index].playlist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ARTISTE
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Artistes',
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
                FutureBuilder<List<ArtistModel>>(
                  future: audioQuery.queryArtists(
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    sortType: null,
                    ignoreCase: true,
                  ),
                  builder: (context, item) {
                    var artistes = item.data;
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
                      height: 90,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top:10),
                        scrollDirection: Axis.horizontal,
                        itemCount: artistes!.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: QueryArtworkWidget(
                                  id: artistes[index].id,
                                  type: ArtworkType.ARTIST,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                artistes[index].artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // GENRE
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
                      height: 90,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top:10),
                        scrollDirection: Axis.horizontal,
                        itemCount: genres!.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: QueryArtworkWidget(
                                  id: genres[index].id,
                                  type: ArtworkType.GENRE,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                genres[index].genre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),


            // SONGS
            Column(
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
                      height: 220,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        // scrollDirection: Axis.horizontal,
                        itemCount: songs!.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom:10.0),
                          child: ListTile(
                            leading: QueryArtworkWidget(
                              id: songs[index].id,
                              type: ArtworkType.AUDIO,
                              artworkFit: BoxFit.cover,
                              artworkBorder: BorderRadius.circular(30),
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
                            trailing: const Icon(
                              Icons.play_circle,
                              color: ambientBg,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
