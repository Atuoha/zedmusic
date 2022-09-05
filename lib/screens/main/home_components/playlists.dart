import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zedmusic/screens/main/broader_views/playlist.dart';

import '../../../components/kText.dart';
import '../../../components/loading.dart';
import '../../../constants/colors.dart';

class Playlists extends StatelessWidget {
  Playlists({Key? key}) : super(key: key);
  var playlistlength = 0;

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
                firstText: 'My',
                secondText: ' Playlist',
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  PlayListView.routeName,
                  arguments: {'length': playlistlength},
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
            playlistlength = playlists!.length;
            return SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: playlists.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/images/playlist1.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
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
    );
  }
}
