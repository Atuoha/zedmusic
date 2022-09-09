import 'package:flutter/material.dart';
import 'package:zedmusic/providers/song.dart';
import 'package:zedmusic/routes/routes.dart';
import 'package:zedmusic/screens/splash/entry_screen.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.zedmusic',
    androidNotificationChannelName: 'Zedmusic',
    androidNotificationOngoing: true,
  );
  runApp(const MusicApp());
}
// void main()=>
// runApp(const MusicApp());

class MusicApp extends StatelessWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SongData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto'),
        home: const EntryScreen(),
        routes: routes,
      ),
    );
  }
}

/* ISSUES TO FIX
 - RENAMING PLAYLIST NOT WORKING
 - CHECKING SONG PRESENCE IN PLAYLIST
 - FINDING A BETTER WAY TO MANAGE THE NUMBER OF SONGS IN A PLAYLIST
*/
