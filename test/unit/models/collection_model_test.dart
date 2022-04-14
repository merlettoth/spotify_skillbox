// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/ui/collection_screen/collection_model.dart';
import 'package:spotify_skillbox/utils/enums.dart';
import 'model_stubs.dart';

class NapsterServiceMock extends Mock implements NapsterService {}

class CollectionServiceMock extends Mock implements CollectionService {}

class PlayerServiceMock extends Mock implements PlayerService {}

void main() {
  late AppState appState;
  late NapsterServiceMock napsterService;
  late CollectionServiceMock collectionService;
  late PlayerServiceMock playerService;
  late CollectionModel model;

  setUpAll(() {
    appState = AppState()
      ..artistFromArtists = Artist(
        id: ModelStubs.artists.first.id,
        name: ModelStubs.artists.first.name,
        bio: ModelStubs.artists.first.bio,
        imagesHref: ModelStubs.artists.first.imagesHref,
      )
      ..currentPage = TypePage.collection
      ..openPlayer = () {};
    napsterService = NapsterServiceMock();
    collectionService = CollectionServiceMock();
    playerService = PlayerServiceMock();

    when(() => collectionService.tracks).thenAnswer(
      (invocation) => Stream<List<Track>>.fromIterable([ModelStubs.tracks]),
    );

    when(
      () => napsterService.getTrackPathPhoto(any()),
    ).thenAnswer(
      (invocation) => Future.value('pathPhoto'),
    );

    model = CollectionModel(appState, napsterService, collectionService, playerService);
  });

  setUpAll(() {
    registerFallbackValue(ModelStubs.tracks.first);
  });

  test('open player', () async {
    when(
      () => playerService.setTrack(
        track: any(named: 'track'),
        isPlaybackCollection: any(named: 'isPlaybackCollection'),
      ),
    ).thenReturn(null);

    appState.isPlaybackCollection = false;
    model.openPlayer(ModelStubs.tracks.first);

    verify(
      () => playerService.setTrack(
        track: ModelStubs.tracks.first,
        isPlaybackCollection: true,
      ),
    ).called(1);

    expect(appState.isPlaybackCollection, true);
  });

  test('delete track', () async {
    when(() => collectionService.deleteTrack(any())).thenReturn(null);

    model.deleteTrack('trackId');

    verify(() => collectionService.deleteTrack('trackId')).called(1);
  });

  test('change collection', () async {
    verify(
      () => napsterService.getTrackPathPhoto(ModelStubs.tracks.first.albumHref),
    ).called(1);
  });
}
