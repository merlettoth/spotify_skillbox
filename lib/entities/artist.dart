// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:spotify_skillbox/entities/track.dart';

class Artist {
  final String id;
  final String name;
  final String bio;
  final String imagesHref;
  final pathPhoto = ValueNotifier<String>('');
  final tracks = ValueNotifier<List<Track>>([]);
  int offsetTracks = 0;
  final isAllSongsReceived = ValueNotifier<bool>(false);

  Artist({
    required this.id,
    required this.name,
    required this.bio,
    required this.imagesHref,
  });
}
