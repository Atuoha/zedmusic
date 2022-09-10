import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zedmusic/screens/main/broader_views/songs_by_artiste.dart';
import '../../../components/kBackground.dart';
import '../../../components/kText.dart';
import '../../../components/loading.dart';
import '../../../components/searchbox.dart';
import '../../../constants/colors.dart';

class ArtisteView extends StatelessWidget {
  static const routeName = '/artistes';

  ArtisteView({Key? key}) : super(key: key);
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int artisteLength = data['length'];

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
                      secondText: ' Artistes',
                    ),
                    Text(
                      '$artisteLength artistes ',
                      style: const TextStyle(
                        color: searchBoxBg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<ArtistModel>>(
                  future: audioQuery.queryArtists(
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    sortType: null,
                    ignoreCase: true,
                  ),
                  builder: (context, item) {
                    var artistes = item.data;
                    if (artistes == null) {
                      return const Center(
                        child: Loading(),
                      );
                    }
                    if (artistes.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty.png',
                            width: 90,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Artistes are empty!',
                            style: TextStyle(
                              color: searchBoxBg,
                            ),
                          ),
                        ],
                      );
                    }
                    return SizedBox(
                        height: size.height / 1.3,
                        child: GridView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 2 : 3,
                            mainAxisSpacing: 7,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: artistes.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                              ArtisteSongs.routeName,
                              arguments: {
                                'artiste': artistes[index],
                              },
                            ),
                            child: Column(
                              children: [
                                QueryArtworkWidget(
                                  id: artistes[index].id,
                                  type: ArtworkType.ARTIST,
                                  artworkFit: BoxFit.cover,
                                  artworkHeight: 120,
                                  artworkWidth: double.infinity,
                                  nullArtworkWidget: const Center(child:  Icon(Icons.music_note),),
                                  artworkBorder: BorderRadius.circular(5),
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
                        ));
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
