// Project imports:
import 'package:spotify_skillbox/data/src/api/napster_service.dart';
import 'package:spotify_skillbox/data/src/repository/napster_api_client.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/entities/track.dart';

class NapsterServiceImpl implements NapsterService {
  final NapsterApiClient _apiClient;

  NapsterServiceImpl(this._apiClient);

  @override
  Future<List<Artist>> getArtists(int offset) async {
    final artists = <Artist>[];

    const path = 'artists/top';
    final params = {'limit': 10, 'offset': offset};
    final response = await _apiClient.getData(path: path, params: params);

    if (response.statusCode != 200 || response.data == null) {
      throw Exception();
    }

    final data = response.data!['artists'] as List<dynamic>;
    final listArtists = data.map((dynamic e) => e as Map<String, dynamic>);

    for (final item in listArtists) {
      final id = item['id'] as String;
      final name = item['name'] as String;

      final dynamic biosListData = item['bios'];
      String bio = '';
      if (biosListData != null) {
        final biosList = item['bios'] as List<dynamic>;
        final bios = biosList.map((dynamic e) => e as Map<String, dynamic>).first;
        bio = bios['bio'] as String;
      }

      final links = item['links'] as Map<String, dynamic>;
      final images = links['images'] as Map<String, dynamic>;
      final imageHref = images['href'] as String;
      artists.add(Artist(id: id, name: name, bio: bio, imagesHref: imageHref));
    }

    return artists;
  }

  @override
  Future<String> getArtistPathPhoto(String imagesHref) async {
    return _getPathPhoto(imagesHref);
  }

  @override
  Future<List<Track>> getTracks({required String artistId, required int offset}) async {
    final tracks = <Track>[];

    final path = 'artists/$artistId/tracks/top';
    final params = {'limit': 5, 'offset': offset};
    final response = await _apiClient.getData(path: path, params: params);

    if (response.statusCode != 200 || response.data == null) {
      throw Exception();
    }

    final data = response.data!['tracks'] as List<dynamic>;
    final listTracks = data.map((dynamic e) => e as Map<String, dynamic>);

    for (final item in listTracks) {
      final id = item['id'] as String;
      final href = item['href'] as String;
      final name = item['name'] as String;
      final albumName = item['albumName'] as String;
      final artistName = item['artistName'] as String;
      final previewUrl = item['previewURL'] as String;
      final links = item['links'] as Map<String, dynamic>;
      final albums = links['albums'] as Map<String, dynamic>;
      final albumHref = albums['href'] as String;

      tracks.add(
        Track(
          id: id,
          href: href,
          name: name,
          albumName: albumName,
          artistName: artistName,
          previewUrl: previewUrl,
          albumHref: albumHref,
        ),
      );
    }

    return tracks;
  }

  @override
  Future<List<Artist>> searchArtists({required String name, required int offset}) async {
    final artists = <Artist>[];

    const path = 'search';
    final params = {
      'query': name,
      'type': 'artists',
      'per_type_limit': 10,
      'offset': offset,
    };
    final response = await _apiClient.getData(path: path, params: params);

    if (response.statusCode != 200 || response.data == null) {
      throw Exception();
    }

    final search = response.data!['search'] as Map<String, dynamic>;
    final data = search['data'] as Map<String, dynamic>;
    final artistsData = data['artists'] as List<dynamic>;
    final listArtists = artistsData.map((dynamic e) => e as Map<String, dynamic>);

    for (final item in listArtists) {
      final id = item['id'] as String;
      final name = item['name'] as String;

      final dynamic biosListData = item['bios'];
      String bio = '';
      if (biosListData != null) {
        final biosList = item['bios'] as List<dynamic>;
        final bios = biosList.map((dynamic e) => e as Map<String, dynamic>).first;
        bio = bios['bio'] as String;
      }

      final links = item['links'] as Map<String, dynamic>;
      final images = links['images'] as Map<String, dynamic>;
      final imageHref = images['href'] as String;
      artists.add(Artist(id: id, name: name, bio: bio, imagesHref: imageHref));
    }

    return artists;
  }

  @override
  Future<String> getTrackPathPhoto(String albumHref) async {
    final response = await _apiClient.getPhotoData(path: albumHref);

    if (response.statusCode != 200 || response.data == null) {
      throw Exception();
    }
    
    final albums = response.data!['albums'] as List<dynamic>;
    final album = albums[0] as Map<String, dynamic>;
    final links = album['links'] as Map<String, dynamic>;
    final images = links['images'] as Map<String, dynamic>;
    final imagesHref = images['href'] as String;
    return _getPathPhoto(imagesHref);
  }

  Future<String> _getPathPhoto(String imagesHref) async {
    final response = await _apiClient.getPhotoData(path: imagesHref);
    if (response.statusCode != 200 || response.data == null) {
      throw Exception();
    }

    final imagesData = response.data!['images'] as List<dynamic>;
    final images = imagesData.map((dynamic e) => e as Map<String, dynamic>).toList();

    if (images.isEmpty) {
      return '';
    }

    final photos = <_Photo>[];
    for (final image in images) {
      final url = image['url'] as String;
      final width = image['width'] as int;
      photos.add(_Photo(url: url, width: width));
    }
    final photo = photos.reduce((a, b) => a.width < b.width ? a : b);

    return photo.url;
  }
}

class _Photo {
  final String url;
  final int width;

  _Photo({
    required this.url,
    required this.width,
  });
}
