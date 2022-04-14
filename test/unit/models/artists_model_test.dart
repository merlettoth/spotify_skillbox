// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/ui/artists_screen/artists_model.dart';
import 'model_stubs.dart';

class NapsterServiceMock extends Mock implements NapsterService {}

void main() {
  late AppState appState;
  late NapsterServiceMock napsterService;
  late ArtistsModel model;

  setUp(() {
    appState = AppState();
    napsterService = NapsterServiceMock();
    model = ArtistsModel(appState, napsterService);
  });

  test('successful loading of artists', () async {
    when(
      () => napsterService.getArtists(any()),
    ).thenAnswer(
      (invocation) => Future.value(ModelStubs.artists),
    );

    when(
      () => napsterService.getArtistPathPhoto(any()),
    ).thenAnswer(
      (invocation) => Future.value('pathPhoto'),
    );

    final artists = await model.loadArtists();

    verify(
      () => napsterService.getArtists(0),
    ).called(1);

    verify(
      () => napsterService.getArtistPathPhoto(ModelStubs.artists.first.imagesHref),
    ).called(1);

    expect(artists, isA<List<Artist>?>());
    expect(artists!.length, 1);

    model.setCurrentIndexArtist(0);
    expect(appState.artistFromArtists, ModelStubs.artists.first);
  });

  test('error loading artists', () async {
    when(
      () => napsterService.getArtists(any()),
    ).thenThrow(Exception());

    final artists = await model.loadArtists();

    verify(
      () => napsterService.getArtists(0),
    ).called(1);

    expect(artists, isA<List<Artist>?>());
    expect(artists!.length, 0);
  });

  test('the artists are over', () async {
    when(
      () => napsterService.getArtists(any()),
    ).thenAnswer(
      (invocation) => Future.value([]),
    );

    final artists = await model.loadArtists();

    verify(
      () => napsterService.getArtists(0),
    ).called(1);

    expect(artists, null);
  });
}
