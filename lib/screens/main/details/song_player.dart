import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../components/kBackground.dart';
import '../../../constants/colors.dart';
import '../../../providers/song.dart';

class SongPlayer extends StatelessWidget {
  static const routeName = '/songplayer';

  SongPlayer({Key? key}) : super(key: key);
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    var data =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    SongModel song  = data['song'];
    var songData = Provider.of<SongData>(context);
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Icons.keyboard_arrow_down,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 50),
                    Image.asset('assets/images/small_logo.png'),

                  ],
                ),
                Text(song.title)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
