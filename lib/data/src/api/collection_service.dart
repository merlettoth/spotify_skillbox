// Project imports:
import 'package:spotify_skillbox/entities/track.dart';

abstract class CollectionService {
  Stream<List<Track>> get tracks;
  void addTrack(Track track);
  void deleteTrack(String id);
}
