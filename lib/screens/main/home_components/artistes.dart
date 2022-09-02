import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../components/loading.dart';
import '../../../constants/colors.dart';
import '../broader_views/artistes.dart';

class Artistes extends StatelessWidget {
   Artistes({Key? key}) : super(key: key);
  var artisteLength = 0;

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
              const Text(
                'Artistes',
                style: TextStyle(
                  color: ambientBg,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  ArtisteView.routeName,
                  arguments: {'length': artisteLength},
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
                    'Artistes are empty!',
                    style: TextStyle(
                      color: searchBoxBg,
                    ),
                  ),
                ],
              );
            }
            artisteLength = artistes!.length;
            return SizedBox(
              height: 90,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                scrollDirection: Axis.horizontal,
                itemCount: artistes.length,
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
    );
  }
}
