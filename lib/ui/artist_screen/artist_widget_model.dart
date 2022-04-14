// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/ui/artist_screen/artist_model.dart';
import 'package:spotify_skillbox/ui/artist_screen/artist_widget.dart';

abstract class IArtistWidgetModel extends IWidgetModel {
  ValueNotifier<String> get pathPhoto;
  String get bio;
  String get name;
  double get appBarHeight;
  double get expandedHeight;
  double Function(double cacheOrigin) get interpolateFontWeightAppBarTitle;
  ValueNotifier<bool> get isLoadingTracks;
  Future<void> Function() get onLoadTracks;
  ValueNotifier<List<Track>> get tracks;
  void Function(Track track) get onOpenPlayer;
  ValueNotifier<bool> get isAllSongsReceived;
}

ArtistWidgetModel artistWidgetModelFactory(BuildContext context) {
  final appState = context.read<AppState>();
  final napsterService = context.read<NapsterService>();
  final playerService = context.read<PlayerService>();
  return ArtistWidgetModel(ArtistModel(appState, napsterService, playerService));
}

class ArtistWidgetModel extends WidgetModel<ArtistWidget, ArtistModel>
    implements IArtistWidgetModel {
  ArtistWidgetModel(ArtistModel model) : super(model);

  late final Artist artist;
  late final _pathPhoto = model.artist.pathPhoto;
  final _appBarHeight = 250.0;
  late final double _scrolledPartAppBarHeight;
  late final double _expandedHeight;
  final _isLoadingTracks = ValueNotifier<bool>(false);
  late final _tracks = model.artist.tracks;

  @override
  ValueNotifier<String> get pathPhoto => _pathPhoto;

  @override
  String get bio => artist.bio;

  @override
  String get name => artist.name;

  @override
  double get appBarHeight => _appBarHeight;

  @override
  double get expandedHeight => _expandedHeight;

  @override
  double Function(double cacheOrigin) get interpolateFontWeightAppBarTitle =>
      _interpolateFontWeightAppBarTitle;

  @override
  ValueNotifier<bool> get isLoadingTracks => _isLoadingTracks;

  @override
  Future<void> Function() get onLoadTracks => _loadTracks;

  @override
  ValueNotifier<List<Track>> get tracks => _tracks;

  @override
  void Function(Track) get onOpenPlayer => _onOpenPlayer;

  @override
  ValueNotifier<bool> get isAllSongsReceived => artist.isAllSongsReceived;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    setAppBarParams();
    artist = model.artist;
    if (artist.tracks.value.isEmpty && !artist.isAllSongsReceived.value) {
      _loadTracks();
    }
  }

  void setAppBarParams() {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    _expandedHeight = _appBarHeight - statusBarHeight;
    _scrolledPartAppBarHeight = _appBarHeight - statusBarHeight - kToolbarHeight;
  }

  double _interpolateFontWeightAppBarTitle(double cacheOrigin) {
    final value = (_scrolledPartAppBarHeight + cacheOrigin) / _scrolledPartAppBarHeight;
    return value < 0 ? 0 : value;
  }

  Future<void> _loadTracks() async {
    _isLoadingTracks.value = true;
    await model.loadTracks();
    _isLoadingTracks.value = false;
  }

  void _onOpenPlayer(Track track) {
    model.openPlayer(track);
  }
}
