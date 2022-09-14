import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../components/kText.dart';
import '../../../components/loading.dart';
import '../../../constants/colors.dart';
import '../broader_views/albums.dart';
import '../broader_views/songs_by_album.dart';

class Albums extends StatelessWidget {
  Albums({Key? key}) : super(key: key);
  var albumsLength = 0;

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
                secondText: ' Albums',
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  AlbumsView.routeName,
                  arguments: {'length': albumsLength},
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
        FutureBuilder<List<AlbumModel>>(
          future: audioQuery.queryAlbums(
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            sortType: null,
            ignoreCase: true,
          ),
          builder: (context, item) {
            var albums = item.data;
            if (albums == null) {
              return const Center(
                child: Loading(),
              );
            }
            if (albums.isEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty.png',
                    width: 90,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Albums are empty!',
                    style: TextStyle(
                      color: searchBoxBg,
                    ),
                  ),
                ],
              );
            }
            albumsLength = albums.length;
            return SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: albums.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    AlbumSongs.routeName,
                    arguments: {
                      'id': albums[index].id,
                    },
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: QueryArtworkWidget(
                            id: albums[index].id,
                            type: ArtworkType.ALBUM,
                            nullArtworkWidget: const Icon(
                              Icons.album,
                              color: pColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${albums[index].album.substring(0, 4)}...',
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
              ),
            );
          },
        ),
      ],
    );
  }
}
