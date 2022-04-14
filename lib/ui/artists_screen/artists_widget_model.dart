// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/ui/artist_screen/artist_widget.dart';
import 'package:spotify_skillbox/ui/artists_screen/artists_model.dart';
import 'package:spotify_skillbox/ui/artists_screen/artists_widget.dart';

abstract class IArtistsWidgetModel extends IWidgetModel {
  ListenableState<EntityState<List<Artist>>> get artists;
  RefreshController get refreshController;
  Future<void> Function() get onRefreshArtists;
  void Function(int index) get onGoToArtistScreen;
  bool get isAllArtistsReceived;
  ValueNotifier<bool> get isLoadingArtists;
}

ArtistsWidgetModel artistsWidgetModelFactory(BuildContext context) {
  final appState = context.read<AppState>();
  final napsterService = context.read<NapsterService>();
  return ArtistsWidgetModel(ArtistsModel(appState, napsterService));
}

class ArtistsWidgetModel extends WidgetModel<ArtistsWidget, ArtistsModel>
    implements IArtistsWidgetModel {
  ArtistsWidgetModel(ArtistsModel model) : super(model);

  final _artists = EntityStateNotifier<List<Artist>>();
  final _refreshController = RefreshController();
  final _isLoadingArtists = ValueNotifier<bool>(false);
  bool _isAllArtistsReceived = false;

  @override
  ListenableState<EntityState<List<Artist>>> get artists => _artists;

  @override
  RefreshController get refreshController => _refreshController;

  @override
  Future<void> Function() get onRefreshArtists => _onRefreshArtists;

  @override
  void Function(int index) get onGoToArtistScreen => _onGoToArtistScreen;

  @override
  bool get isAllArtistsReceived => _isAllArtistsReceived;

  @override
  ValueNotifier<bool> get isLoadingArtists => _isLoadingArtists;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _artists.loading();
    _loadArtists();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadArtists() async {
    _isLoadingArtists.value = true;
    final artists = await model.loadArtists();
    if (artists == null) {
      _isAllArtistsReceived = true;
      _artists.content(_artists.value!.data!);
    } else {
      _artists.content(artists);
    }

    _isLoadingArtists.value = false;
  }

  Future<void> _onRefreshArtists() async {
    if (!_isLoadingArtists.value) {
      await _loadArtists();
      refreshController.loadComplete();
    }
  }

  void _onGoToArtistScreen(int index) {
    model.setCurrentIndexArtist(index);
    Navigator.pushNamed(context, ArtistWidget.routeName);
  }
}
