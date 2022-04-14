// ignore_for_file: avoid_setters_without_getters

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/data/src/api/napster_service.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';

class SearchModel extends ElementaryModel {
  static const _offset = 10;

  List<Artist> _artists = [];
  int _searchOffset = 0;
  String _artistName = '';

  final AppState _appState;
  final NapsterService _napsterService;

  SearchModel(this._appState, this._napsterService);

  set artistName(String artistName) {
    _artistName = artistName;
  }

  void setCurrentSearchArtist(int index) {
    _appState.artistFromSearch = _artists[index];
  }

  Future<List<Artist>> searchArtists() async {
    _searchOffset = 0;
    List<Artist> artists = [];

    try {
      artists = await _napsterService.searchArtists(name: _artistName, offset: _searchOffset);
      _searchOffset += _offset;
    } on Exception catch (_) {}

    _artists = artists;

    if (artists.isNotEmpty) {
      _loadPathPhotos();
    }

    return _artists;
  }

  Future<List<Artist>?> getMoreArtists() async {
    final oldArtists = _artists.toList();
    List<Artist> artists = [];
    bool isError = false;

    try {
      artists = await _napsterService.searchArtists(name: _artistName, offset: _searchOffset);
    } on Exception catch (_) {
      isError = true;
    }

    if (!isError) {
      if (artists.isEmpty) {
        return null;
      }

      _searchOffset += _offset;
      _artists.addAll(artists);
    }

    if (_artists.length != oldArtists.length) {
      _loadPathPhotos();
    }

    return _artists;
  }

  Future<void> _loadPathPhotos() async {
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
