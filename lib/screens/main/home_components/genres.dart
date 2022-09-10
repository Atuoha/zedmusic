import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../components/kText.dart';
import '../../../components/loading.dart';
import '../../../constants/colors.dart';
import '../broader_views/genres.dart';

class Genres extends StatelessWidget {
   Genres({Key? key}) : super(key: key);
  var genresLength = 0;

  @override
  Widget build(BuildContext context) {
    final OnAudioQuery audioQuery = OnAudioQuery();
    return Column(
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
                onPressed: () => Navigator.of(context).pushNamed(
                  GenresView.routeName,
                  arguments: {'length': genresLength},
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
        FutureBuilder<List<GenreModel>>(
          future: audioQuery.queryGenres(
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            sortType: null,
            ignoreCase: true,
          ),
          builder: (context, item) {
            var genres = item.data;
            if (genres == null) {
              return const Center(
                child: Loading(),
              );
            }
            if (genres.isEmpty) {
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
            genresLength = genres.length;
            return SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: QueryArtworkWidget(
                          id: genres[index].id,
                          type: ArtworkType.GENRE,
                          nullArtworkWidget: const Center(child:  Icon(Icons.music_note),),
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
    );
  }
}
