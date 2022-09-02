import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../components/kText.dart';
import '../../components/searchbox.dart';
import '../../constants/colors.dart';
import '../../providers/song.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var songData = Provider.of<SongData>(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
        right: 18,
        left: 18,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/images/small_logo.png'),
            ),
            const SizedBox(height: 15),
            const SearchBox(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const KText(
                  firstText: 'All',
                  secondText: ' Favorites',
                ),
                Text(
                  '${songData.getFavorites().length} songs ',
                  style: const TextStyle(
                    color: searchBoxBg,
                  ),
                ),
              ],
            ),

           songData.getFavorites().length == 0 ?

           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const SizedBox(height:10),
               Image.asset(
                 'assets/images/empty.png',
                 width: 90,
               ),
               const SizedBox(width: 10),
               const Text(
                 'Favorite Songs are empty!',
                 style: TextStyle(
                   color: searchBoxBg,
                 ),
               ),
             ],
           )
               :
               const SizedBox(height:10),
            SizedBox(
              height: size.height / 1,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: songData.getFavorites().length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: QueryArtworkWidget(
                      id: songData.getFavorites()[index].id,
                      type: ArtworkType.AUDIO,
                      artworkFit: BoxFit.cover,
                      artworkBorder: BorderRadius.circular(30),
                    ),
                    title: Text(
                      songData.getFavorites()[index].title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      songData.getFavorites()[index].artist!,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    trailing: Column(
                      children: [
                        GestureDetector(
                          onTap: () => songData
                              .toggleIsFav(songData.getFavorites()[index]),
                          child: Icon(
                            songData.isFav(songData.getFavorites()[index].id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: songData
                                    .isFav(songData.getFavorites()[index].id)
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
          ],
        ),
      ),
    );
  }
}
