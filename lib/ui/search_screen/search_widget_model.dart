// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Project imports:
import 'package:spotify_skillbox/data/src/api/napster_service.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/ui/artist_screen/artist_widget.dart';
import 'package:spotify_skillbox/ui/search_screen/search_model.dart';
import 'package:spotify_skillbox/ui/search_screen/search_widget.dart';

abstract class ISearchWidgetModel extends IWidgetModel {
  Future<void> Function(String artistName) get onSearchArtists;
  ListenableState<EntityState<List<Artist>>> get artists;
  RefreshController get refreshController;
  Future<void> Function() get onRefreshArtists;
  void Function(int index) get onGoToArtistScreen;
  bool get isLastActionSearch;
  bool get isAllArtistsReceived;
  ValueNotifier<bool> get isLoadingArtists;
}

SearchWidgetModel searchWidgetModelFactory(BuildContext context) {
  final appState = context.read<AppState>();
  final napsterService = context.read<NapsterService>();
  return SearchWidgetModel(SearchModel(appState, napsterService));
}

class SearchWidgetModel extends WidgetModel<SearchWidget, SearchModel>
    implements ISearchWidgetModel {
  SearchWidgetModel(SearchModel model) : super(model);

  final _artists = EntityStateNotifier<List<Artist>>();
  final _refreshController = RefreshController();
  bool _isLastActionSearch = false;
  final _isLoadingArtists = ValueNotifier<bool>(false);
  bool _isAllArtistsReceived = false;

  @override
  Future<void> Function(String artistName) get onSearchArtists => _onSearchArtists;

  @override
  ListenableState<EntityState<List<Artist>>> get artists => _artists;

  @override
  RefreshController get refreshController => _refreshController;

  @override
  void Function(int index) get onGoToArtistScreen => _onGoToArtistScreen;

  @override
  Future<void> Function() get onRefreshArtists => _onRefreshArtists;

  @override
  bool get isLastActionSearch => _isLastActionSearch;

  @override
  bool get isAllArtistsReceived => _isAllArtistsReceived;

  @override
  ValueNotifier<bool> get isLoadingArtists => _isLoadingArtists;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _artists.content([]);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onSearchArtists(String artistName) async {
    if (artistName.replaceAll(' ', '').isEmpty) {
      return;
    }

    _isAllArtistsReceived = false;
    _isLastActionSearch = true;
    _artists.loading();
    model.artistName = artistName.trim();
    final artists = await model.searchArtists();
    _artists.content(artists.toList());
  }

  Future<void> _onRefreshArtists() async {
    if (_isAllArtistsReceived) {
      refreshController.loadComplete();
      return;
    }

    if (!_isLoadingArtists.value) {
      _isLoadingArtists.value = true;
      _isLastActionSearch = false;
      final artists = await model.getMoreArtists();

      if (artists == null) {
        _isAllArtistsReceived = true;
        _artists.content(_artists.value!.data!);
      } else {
        _artists.content(artists.toList());
      }

      _isLoadingArtists.value = false;
      refreshController.loadComplete();
    }
  }

  void _onGoToArtistScreen(int index) {
    model.setCurrentSearchArtist(index);
    Navigator.pushNamed(
      context,
      ArtistWidget.routeName,
    );
  }
}
