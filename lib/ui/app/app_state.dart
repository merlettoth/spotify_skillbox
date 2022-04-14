// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/utils/enums.dart';

class AppState {
  TypePage currentPage = TypePage.artists;
  Artist? artistFromArtists;
  Artist? artistFromSearch;
  BuildContext? mainBuildContext;
  late final Stream<Track> trackStream;
  late void Function() openPlayer;
  List<String> collectionTracksId = [];
  Map<String, String> photos = {};
  final orderStreamController = StreamController<void>.broadcast();
  bool isPlaybackCollection = false;
}
