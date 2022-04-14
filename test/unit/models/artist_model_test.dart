// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/ui/artist_screen/artist_model.dart';
import 'package:spotify_skillbox/utils/enums.dart';
import 'model_stubs.dart';

class NapsterServiceMock extends Mock implements NapsterService {}

class PlayerServiceMock extends Mock implements PlayerService {}

void main() {
  late AppState appState;
  late NapsterServiceMock napsterService;
  late PlayerServiceMock playerService;
  late ArtistModel model;

  setUp(() {
    appState = AppState()
      ..artistFromArtists = Artist(
        id: ModelStubs.artists.first.id,
        name: ModelStubs.artists.first.name,
        bio: ModelStubs.artists.first.bio,
        imagesHref: ModelStubs.artists.first.imagesHref,
      )
      ..currentPage = TypePage.artists
      ..openPlayer = () {};
    napsterService = NapsterServiceMock();
    playerService = PlayerServiceMock();
    model = ArtistModel(appState, napsterService, playerService);
  });

  setUpAll(() {
    registerFallbackValue(ModelStubs.tracks.first);
  });

  test('successful loading of tracks', () async {
    when(
      () => napsterService.getTracks(
        artistId: any(named: 'artistId'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer(
      (invocation) => Future.value(ModelStubs.tracks),
    );

    when(
      () => napsterService.getTrackPathPhoto(any()),
    ).thenAnswer(
      (invocation) => Future.value('pathPhoto'),
    );

    final offsetTracks = model.artist.offsetTracks;
    await model.loadTracks();

    verify(
      () => napsterService.getTracks(
        artistId: model.artist.id,
        offset: offsetTracks,
      ),
    ).called(1);

    verify(
      () => napsterService.getTrackPathPhoto(ModelStubs.tracks.first.albumHref),
    ).called(1);

    expect(model.artist.offsetTracks, offsetTracks + 1);
    expect(model.artist.tracks.value.length, 1);
    expect(model.artist.tracks.value.first.albumHref, ModelStubs.tracks.first.albumHref);
  });

  test('the tracks are over', () async {
    when(
      () => napsterService.getTracks(
        artistId: any(named: 'artistId'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer(
      (invocation) => Future.value([]),
    );

    final offsetTracks = model.artist.offsetTracks;
    await model.loadTracks();

    verify(
      () => napsterService.getTracks(
        artistId: model.artist.id,
        offset: offsetTracks,
      ),
    ).called(1);

    expect(model.artist.offsetTracks, offsetTracks);
    expect(model.artist.tracks.value.length, 0);
  });

  test('error loading tracks', () async {
    when(
      () => napsterService.getTracks(
        artistId: any(named: 'artistId'),
        offset: any(named: 'offset'),
      ),
    ).thenThrow(Exception());

    final offsetTracks = model.artist.offsetTracks;
    await model.loadTracks();

    verify(
      () => napsterService.getTracks(
        artistId: model.artist.id,
        offset: offsetTracks,
      ),
    ).called(1);

    expect(model.artist.offsetTracks, offsetTracks);
    expect(model.artist.tracks.value.length, 0);
  });

  test('open player', () async {
    when(
      () => playerService.setTrack(
        track: any(named: 'track'),
        isPlaybackCollection: any(named: 'isPlaybackCollection'),
      ),
    ).thenReturn(null);

    appState.isPlaybackCollection = true;
    model.openPlayer(ModelStubs.tracks.first);

    verify(
      () => playerService.setTrack(
        track: ModelStubs.tracks.first,
        isPlaybackCollection: false,
      ),
    ).called(1);

    expect(appState.isPlaybackCollection, false);
  });
}
