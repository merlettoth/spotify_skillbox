// Dart imports:
import 'dart:async';

// Package imports:
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/utils/enums.dart';

class ArtistModel extends ElementaryModel {
  late final Artist _artist;

  final AppState _appState;
  final NapsterService _napsterService;
  final PlayerService _playerService;

  Artist get artist => _artist;

  ArtistModel(this._appState, this._napsterService, this._playerService) {
    _artist = _appState.currentPage == TypePage.artists
        ? _appState.artistFromArtists!
        : _appState.artistFromSearch!;
  }

  void openPlayer(Track track) {
    _appState.isPlaybackCollection = false;
    _playerService.setTrack(track: track, isPlaybackCollection: false);
    _appState.openPlayer();
  }

  Future<void> loadTracks() async {
    List<Track> tracks = [];
    bool isError = false;

    try {
      tracks = await _napsterService.getTracks(artistId: _artist.id, offset: _artist.offsetTracks);
    } on Exception catch (_) {
      isError = true;
    }

    if (!isError) {
      if (tracks.isEmpty) {
        _artist.isAllSongsReceived.value = true;
        return;
      }

      final tracksCopy = _artist.tracks.value.toList();
      tracksCopy.addAll(tracks);
      _artist.tracks.value = tracksCopy;
      _artist.offsetTracks += tracks.length;
      _loadPathPhotos();
    }
  }

  Future<void> _loadPathPhotos() async {
    for (final track in _artist.tracks.value) {
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
}
