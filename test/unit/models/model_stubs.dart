// Project imports:
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/entities/track.dart';

abstract class ModelStubs {
  static List<Artist> artists = [
    Artist(
      id: 'Ivan',
      name: 'Ivan',
      bio: 'Ivan',
      imagesHref: 'Ivan',
    ),
  ];

  static List<Track> tracks = [
    Track(
      id: 'track',
      href: 'track',
      name: 'track',
      albumName: 'track',
      artistName: 'track',
      albumHref: 'track',
      previewUrl: 'track',
    )
  ];
}
