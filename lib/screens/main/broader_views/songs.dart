import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../components/kBackground.dart';
import '../../../components/loading.dart';
import '../../../components/searchbox.dart';
import '../../../constants/colors.dart';

class SongsView extends StatelessWidget {
  static const routeName = '/songs';
  const SongsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    final OnAudioQuery audioQuery = OnAudioQuery();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: KBackground(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 18.0,
            top: 40.0,
          ),
          child: Column(
            children: [
              Center(
                child: Image.asset('assets/images/small_logo.png'),
              ),
              const SizedBox(height: 15),
              const SearchBox(),
              const SizedBox(height: 15),
              const Text(
                'Songs',
                style: TextStyle(
                  color: ambientBg,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
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
                    height: size.height / 3,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: songs!.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
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
                          trailing: Column(
                            children: [
                              const Icon(
                                Icons.play_circle,
                                color: ambientBg,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: ambientBg,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
