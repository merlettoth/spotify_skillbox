// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';

class CollectionModel extends ElementaryModel {
  final AppState _appState;
  final NapsterService _napsterService;
  final CollectionService _collectionService;
  final PlayerService _playerService;

  List<Track> _tracks = [];
  final _tracksController = StreamController<List<Track>>();

  Stream<List<Track>> get traksStream => _tracksController.stream;
  BuildContext get mainBuildContext => _appState.mainBuildContext!;

  CollectionModel(
    this._appState,
    this._napsterService,
    this._collectionService,
    this._playerService,
  ) {
    _listenCollectionStream();
  }

  void _listenCollectionStream() {
    _collectionService.tracks.listen((tracks) {
      _tracks = tracks;
      _tracksController.add(_tracks);
      _setCollectionTracksId();
      _loadPathPhotos();
    });
  }

  Future<void> _loadPathPhotos() async {
    for (final track in _tracks) {
      if (track.pathAlbumPhoto.value.isNotEmpty || track.albumHref.isEmpty) {
        continue;
      }

      if (_appState.photos.containsKey(track.albumHref)) {
        track.pathAlbumPhoto.value = _appState.photos[track.albumHref]!;
        continue;
      }

      String pathPhoto;
      try {
        pathPhoto = await _napsterService.getTrackPathPhoto(track.albumHref);
        _appState.photos[track.albumHref] = pathPhoto;
      } on Exception catch (_) {
        pathPhoto = '';
      }

      track.pathAlbumPhoto.value = pathPhoto;
    }
  }

  Future<void> deleteTrack(String trackId) async {
    _collectionService.deleteTrack(trackId);
  }

  void openPlayer(Track track) {
    _appState.isPlaybackCollection = true;
    _playerService.setTrack(track: track, isPlaybackCollection: true);
    _appState.openPlayer();
  }

  void sortCollection() {
    _appState.orderStreamController.add(null);
  }

  void _setCollectionTracksId() {
    _appState.collectionTracksId.clear();
    for (final track in _tracks) {
      _appState.collectionTracksId.add(track.id);
    }
  }
}
