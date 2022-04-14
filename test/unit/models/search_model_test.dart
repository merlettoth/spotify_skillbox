// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/ui/search_screen/search_model.dart';
import 'model_stubs.dart';

class NapsterServiceMock extends Mock implements NapsterService {}

void main() {
  late AppState appState;
  late NapsterServiceMock napsterService;
  late SearchModel model;

  setUp(() {
    appState = AppState();
    napsterService = NapsterServiceMock();
    model = SearchModel(appState, napsterService);
    ModelStubs.artists.first.pathPhoto.value = '';
  });

  test('successful finding of artists', () async {
    when(
      () => napsterService.searchArtists(
        name: any(named: 'name'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer(
      (invocation) => Future.value(ModelStubs.artists),
    );

    when(
      () => napsterService.getArtistPathPhoto(any()),
    ).thenAnswer(
      (invocation) => Future.value('pathPhoto'),
    );

    model.artistName = 'Ivan';
    final artists = await model.searchArtists();

    verify(
      () => napsterService.searchArtists(name: 'Ivan', offset: 0),
    ).called(1);

    verify(
      () => napsterService.getArtistPathPhoto(ModelStubs.artists.first.imagesHref),
    ).called(1);

    expect(artists, isA<List<Artist>>());
    expect(artists.length, 1);
  });

  test('error finding of artists', () async {
    when(
      () => napsterService.searchArtists(
        name: any(named: 'name'),
        offset: any(named: 'offset'),
      ),
    ).thenThrow(Exception());

    model.artistName = 'Ivan';
    final artists = await model.searchArtists();

    verify(
      () => napsterService.searchArtists(name: 'Ivan', offset: 0),
    ).called(1);

    expect(artists, isA<List<Artist>>());
    expect(artists.length, 0);
  });

  test('no artists found', () async {
    when(
      () => napsterService.searchArtists(
        name: any(named: 'name'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer(
      (invocation) => Future.value([]),
    );

    model.artistName = 'Ivan';
    final artists = await model.searchArtists();

    verify(
      () => napsterService.searchArtists(name: 'Ivan', offset: 0),
    ).called(1);

    expect(artists, isA<List<Artist>>());
    expect(artists.length, 0);
  });

  test('successfully getting more artists', () async {
    when(
      () => napsterService.searchArtists(
        name: any(named: 'name'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer(
      (invocation) => Future.value(ModelStubs.artists),
    );

    when(
      () => napsterService.getArtistPathPhoto(any()),
    ).thenAnswer(
      (invocation) => Future.value('pathPhoto'),
    );

    model.artistName = 'Ivan';
    final artists = await model.getMoreArtists();

    verify(
      () => napsterService.searchArtists(name: 'Ivan', offset: 0),
    ).called(1);

    verify(
      () => napsterService.getArtistPathPhoto(ModelStubs.artists.first.imagesHref),
    ).called(1);

    expect(artists, isA<List<Artist>?>());
    expect(artists!.length, 1);
  });

  test('error getting more artists', () async {
    when(
      () => napsterService.searchArtists(
        name: any(named: 'name'),
        offset: any(named: 'offset'),
      ),
    ).thenThrow(Exception());

    model.artistName = 'Ivan';
    final artists = await model.getMoreArtists();

    verify(
      () => napsterService.searchArtists(name: 'Ivan', offset: 0),
    ).called(1);

    expect(artists, isA<List<Artist>?>());
    expect(artists!.length, 0);
  });

  test('the artists are over', () async {
    when(
      () => napsterService.searchArtists(
        name: any(named: 'name'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer(
      (invocation) => Future.value([]),
    );

    model.artistName = 'Ivan';
    final artists = await model.getMoreArtists();

    verify(
      () => napsterService.searchArtists(name: 'Ivan', offset: 0),
    ).called(1);

    expect(artists, null);
  });
}
