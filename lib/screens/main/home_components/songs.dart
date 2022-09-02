import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../components/loading.dart';
import '../../../constants/colors.dart';

class Songs extends StatelessWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OnAudioQuery audioQuery = OnAudioQuery();
    return      Column(
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
    );
  }
}
