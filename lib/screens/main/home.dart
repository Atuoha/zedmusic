import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zedmusic/components/searchbox.dart';
import 'package:zedmusic/screens/main/home_components/playlists.dart';
import '../../components/bottomPlayer.dart';
import '../../constants/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/song.dart';
import 'home_components/albums.dart';
import 'home_components/artistes.dart';
import 'home_components/genres.dart';
import 'home_components/songs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Wrap(
            children: const [
              Icon(
                Icons.music_note,
                size: 30,
                color: primaryColor,
              ),
              SizedBox(width: 5),
              Text(
                'ZedMusic',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Access Denied! Music from storage will not be fetched',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: btnBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(5),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Dismiss',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var songData = Provider.of<SongData>(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('assets/images/small_logo.png'),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: SearchBox(),
                ),

                //  PLAYLISTS
                Playlists(),
                const SizedBox(height: 5),

                //  ALBUMS
                Albums(),
                const SizedBox(height: 5),

                // ARTISTES
                Artistes(),
                const SizedBox(height: 5),

                // GENRES
                Genres(),
                const SizedBox(height: 5),

                // SONGS
                Songs()
              ],
            ),
          ),

          // Bottom Player
          BottomPlayer(songData: songData,)
        ],
      ),
    );
  }
}
