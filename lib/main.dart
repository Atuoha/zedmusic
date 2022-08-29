import 'package:flutter/material.dart';
import 'package:zedmusic/routes/routes.dart';
import 'package:zedmusic/screens/splash/entry_screen.dart';
import 'package:zedmusic/screens/splash/splash.dart';
void main()=> runApp(const MusicApp());


class MusicApp extends StatelessWidget{
  const MusicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const EntryScreen(),
      routes: routes,
    );
  }
}