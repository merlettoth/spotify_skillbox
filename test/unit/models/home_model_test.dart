// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/ui/home/home_model.dart';
import 'model_stubs.dart';

class CollectionServiceMock extends Mock implements CollectionService {}

class PlayerServiceMock extends Mock implements PlayerService {}

void main() {
  late AppState appState;
  late CollectionServiceMock collectionService;
  late PlayerServiceMock playerService;
  late HomeModel model;

  setUpAll(() {
    appState = AppState();
    collectionService = CollectionServiceMock();
    playerService = PlayerServiceMock();

    when(() => playerService.trackStream).thenAnswer(
      (invocation) => Stream<Track>.fromIterable([ModelStubs.tracks.first]),
    );

    model = HomeModel(appState, playerService, collectionService);

    registerFallbackValue(Duration.zero);
    registerFallbackValue(ModelStubs.tracks.first);
  });

  test('seek track', () {
    when(() => playerService.seek(any())).thenReturn(null);

    model.seekTrack(Duration.zero);

    verify(() => playerService.seek(Duration.zero)).called(1);
  });

  test('playback track', () {
    when(() => playerService.playbackTrack()).thenReturn(null);

    model.playbackTrack();

    verify(() => playerService.playbackTrack()).called(1);
  });

  test('add track in collection', () {
    when(() => collectionService.addTrack(any())).thenReturn(null);

    model.addTrackInCollection();

    verify(() => collectionService.addTrack(ModelStubs.tracks.first)).called(1);
  });
}
