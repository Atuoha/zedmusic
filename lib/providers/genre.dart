import 'package:flutter/material.dart';
import 'package:zedmusic/models/genre.dart';

class GenreData extends ChangeNotifier{
  Genre findById(String id){
    return _genres.firstWhere((genre) => genre.id == id);
  }

  final _genres = [];
}