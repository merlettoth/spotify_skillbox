// Dart imports:
import 'dart:async';

// Package imports:
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';

class ArtistsModel extends ElementaryModel {
  static const _offset = 10;
  int _offsetArtists = 0;
  final List<Artist> _artists = [];

  final AppState _appState;
  final NapsterService _napsterService;

  ArtistsModel(this._appState, this._napsterService);

  void setCurrentIndexArtist(int index) {
    _appState.artistFromArtists = _artists[index];
  }

  Future<List<Artist>?> loadArtists() async {
    final oldArtists = _artists.toList();
    List<Artist> artists = [];
    bool isError = false;

    try {
      artists = await _napsterService.getArtists(_offsetArtists);
    } on Exception catch (_) {
      isError = true;
    }

    if (!isError) {
      if (artists.isEmpty) {
        return null;
      }

      _offsetArtists += _offset;
      _artists.addAll(artists);
    }

    if (_artists.length != oldArtists.length) {
      loadPathPhotos();
    }

    return _artists;
  }

  Future<void> loadPathPhotos() async {
    try {
      for (final artist in _artists) {
        if (artist.pathPhoto.value.isNotEmpty || artist.imagesHref.isEmpty) {
          continue;
        }

        if (_appState.photos.containsKey(artist.imagesHref)) {
          artist.pathPhoto.value = _appState.photos[artist.imagesHref]!;
          continue;
        }

        String pathPhoto;
        try {
          pathPhoto = await _napsterService.getArtistPathPhoto(artist.imagesHref);
          _appState.photos[artist.imagesHref] = pathPhoto;
        } on Exception catch (_) {
          pathPhoto = '';
        }

        artist.pathPhoto.value = pathPhoto;
      }
    } catch (_) {}
  }
}
