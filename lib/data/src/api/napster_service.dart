// Project imports:
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/entities/track.dart';

abstract class NapsterService {
  Future<List<Artist>> getArtists(int offset);
  Future<String> getArtistPathPhoto(String imageHref);
  Future<List<Track>> getTracks({required String artistId, required int offset});
  Future<String> getTrackPathPhoto(String albumHref);
  Future<List<Artist>> searchArtists({required String name, required int offset});
}
