import 'package:flutter/material.dart';
import 'package:zedmusic/models/downloaded.dart';

class DownloadedData extends ChangeNotifier {
  Downloaded findById(String id) {
    return _downloads.firstWhere((download) => download.id == id);
  }

  final _downloads = [];
}
