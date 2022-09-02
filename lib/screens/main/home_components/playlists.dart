import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../components/kText.dart';
import '../../../components/loading.dart';
import '../../../constants/colors.dart';

class Playlists extends StatelessWidget {
  const Playlists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OnAudioQuery audioQuery = OnAudioQuery();

    return    Padding(
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
    );
  }
}
