// ignore_for_file: use_setters_to_change_properties

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:audioplayers/audioplayers.dart';
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/utils/enums.dart';

class HomeModel extends ElementaryModel {
  final AppState _appState;
  final PlayerService _playerService;
  final CollectionService _collectionService;

  late Track _track;

  HomeModel(this._appState, this._playerService, this._collectionService) {
    _playerService.trackStream.listen((track) {
      _track = track;
    });
  }

  bool get isPlaybackCollection => _appState.isPlaybackCollection;
  TypePage get currentPage => _appState.currentPage;
  bool get isLastTrack => _playerService.isLastTrack;
  PlayerState get stateLastTrack => _playerService.stateLastTrack;
  Stream<Track?> get trackStream => _playerService.trackStream;
  Stream<bool> get playbackStream => _playerService.playbackStream;
  Stream<PlayerState> get audioStateTream => _playerService.audioStateStream;
  Stream<Duration> get audioPositionStream => _playerService.audioPositionStream;
  Stream<Duration> get audioDurationStream => _playerService.audioDurationStream;

  set currentPage(TypePage page) => _appState.currentPage = page;

  void setMainBuildContext(BuildContext context) {
    _appState.mainBuildContext = context;
  }

  void initOpenPlayer(void Function() openPlayer) {
    _appState.openPlayer = openPlayer;
  }

  void playbackTrack() {
    _playerService.playbackTrack();
  }

  void stopPlaybackTrack() {
    _playerService.stopPlaybackTrack();
  }

  Future<void> addTrackInCollection() async {
    if (!_appState.collectionTracksId.contains(_track.id)) {
      _collectionService.addTrack(_track);
    }
  }

  void seekTrack(Duration duration) {
    _playerService.seek(duration);
  }
}
