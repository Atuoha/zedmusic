import 'package:zedmusic/screens/auth/auth.dart';
import 'package:zedmusic/screens/auth/forgot_password.dart';
import 'package:zedmusic/screens/main/bottom_nav.dart';
import 'package:zedmusic/screens/main/broader_views/albums.dart';
import 'package:zedmusic/screens/main/broader_views/genres.dart';
import 'package:zedmusic/screens/main/broader_views/playlist.dart';
import 'package:zedmusic/screens/main/broader_views/songs.dart';
import 'package:zedmusic/screens/main/broader_views/songs_by_album.dart';
import 'package:zedmusic/screens/main/broader_views/songs_by_genre.dart';
import 'package:zedmusic/screens/main/broader_views/songs_by_playlist.dart';
import 'package:zedmusic/screens/main/details/song_player.dart';
import 'package:zedmusic/screens/main/home_components/artistes.dart';
import 'package:zedmusic/screens/splash/splash.dart';

import '../screens/main/broader_views/artistes.dart';
import '../screens/main/broader_views/songs_by_artiste.dart';

var routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  AuthScreen.routeName: (context) => const AuthScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  BottomNav.routeName: (context) => const BottomNav(),
  SongsView.routeName: (context) => SongsView(),
  GenresView.routeName: (context) => GenresView(),
  ArtisteView.routeName: (context) => ArtisteView(),
  PlayListView.routeName: (context) => const PlayListView(),
  ArtisteSongs.routeName: (context) => ArtisteSongs(),
  GenreSongs.routeName: (context) => GenreSongs(),
  AlbumsView.routeName: (context) => AlbumsView(),
  AlbumSongs.routeName: (context) => AlbumSongs(),
  PlayListSongs.routeName: (context) => PlayListSongs(),
  SongPlayer.routeName: (context) => SongPlayer(),
};
