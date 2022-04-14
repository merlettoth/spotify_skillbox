// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:spotify_skillbox/data/src/implementation/napster_service_impl.dart';
import 'package:spotify_skillbox/data/src/repository/napster_api_client.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/entities/track.dart';
import 'service_stubs.dart';

class NapsterApiClientMock extends Mock implements NapsterApiClient {}

void main() {
  late final NapsterApiClientMock napsterApiClient;
  late final NapsterServiceImpl napsterService;

  setUpAll(() {
    napsterApiClient = NapsterApiClientMock();
    napsterService = NapsterServiceImpl(napsterApiClient);
  });

  test(
    'successful receipt of artists',
    () {
      when(
        () => napsterApiClient.getData(
          path: any(named: 'path'),
          params: any(named: 'params'),
        ),
      ).thenAnswer(
        (invocation) => Future.value(
          Response<Map<String, dynamic>>(
            data: ServiceStubs.atristsTop,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      final artists = napsterService.getArtists(10);

      verify(
        () => napsterApiClient.getData(
          path: 'artists/top',
          params: <String, dynamic>{'limit': 10, 'offset': 10},
        ),
      ).called(1);

      expect(artists, isA<Future<List<Artist>>>());
    },
  );

  test(
    'unsuccessful receipt of artists',
    () {
      when(
        () => napsterApiClient.getData(
          path: any(named: 'path'),
          params: any(named: 'params'),
        ),
      ).thenAnswer(
        (invocation) => Future.value(
          Response<Map<String, dynamic>>(
            data: <String, dynamic>{"code": "UnauthorizedError", "message": "Unauthorized"},
            statusCode: 405,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      expect(napsterService.getArtists(10), throwsException);
    },
  );

  test(
    'successful receipt of tracks',
    () {
      when(
        () => napsterApiClient.getData(
          path: any(named: 'path'),
          params: any(named: 'params'),
        ),
      ).thenAnswer(
        (invocation) => Future.value(
          Response<Map<String, dynamic>>(
            data: ServiceStubs.tracksTop,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      final tracks = napsterService.getTracks(artistId: 'id', offset: 0);

      verify(
        () => napsterApiClient.getData(
          path: 'artists/id/tracks/top',
          params: <String, dynamic>{'limit': 5, 'offset': 0},
        ),
      ).called(1);

      expect(tracks, isA<Future<List<Track>>>());
    },
  );

  test(
    'unsuccessful receipt of tracks',
    () {
      when(
        () => napsterApiClient.getData(
          path: any(named: 'path'),
          params: any(named: 'params'),
        ),
      ).thenAnswer(
        (invocation) => Future.value(
          Response<Map<String, dynamic>>(
            data: <String, dynamic>{"code": "UnauthorizedError", "message": "Unauthorized"},
            statusCode: 405,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      expect(napsterService.getTracks(artistId: 'id', offset: 0), throwsException);
    },
  );

  test(
    'successful search for artists',
    () {
      when(
        () => napsterApiClient.getData(
          path: any(named: 'path'),
          params: any(named: 'params'),
        ),
      ).thenAnswer(
        (invocation) => Future.value(
          Response<Map<String, dynamic>>(
            data: ServiceStubs.searchArtists,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      final artists = napsterService.searchArtists(name: 'Weezer', offset: 0);

      verify(
        () => napsterApiClient.getData(
          path: 'search',
          params: <String, dynamic>{
            'query': 'Weezer',
            'type': 'artists',
            'per_type_limit': 10,
            'offset': 0,
          },
        ),
      ).called(1);

      expect(artists, isA<Future<List<Artist>>>());
    },
  );

  test(
    'unsuccessful search for artists',
    () {
      when(
        () => napsterApiClient.getData(
          path: any(named: 'path'),
          params: any(named: 'params'),
        ),
      ).thenAnswer(
        (invocation) => Future.value(
          Response<Map<String, dynamic>>(
            data: <String, dynamic>{"code": "UnauthorizedError", "message": "Unauthorized"},
            statusCode: 405,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      expect(napsterService.searchArtists(name: 'Weezer', offset: 0), throwsException);
    },
  );

  test(
    'successfully getting a link to a artist photo',
    () {
      when(
        () => napsterApiClient.getPhotoData(
          path: any(named: 'path'),
        ),
      ).thenAnswer(
        (invocation) => Future.value(
          Response<Map<String, dynamic>>(
            data: ServiceStubs.artistPathPhotos,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      final pathPhoto = napsterService.getArtistPathPhoto('albumHref');

      verify(
        () => napsterApiClient.getPhotoData(
          path: 'albumHref',
        ),
      ).called(1);

      expect(pathPhoto, isA<Future<String>>());
    },
  );

  test(
    'unsuccessfully getting a link to a artist photo',
    () {
      when(
        () => napsterApiClient.getPhotoData(
          path: any(named: 'path'),
        ),
      ).thenAnswer(
        (invocation) => Future.value(
          Response<Map<String, dynamic>>(
            data: <String, dynamic>{"code": "UnauthorizedError", "message": "Unauthorized"},
            statusCode: 405,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      expect(napsterService.getArtistPathPhoto('imagesHref'), throwsException);
    },
  );
}
