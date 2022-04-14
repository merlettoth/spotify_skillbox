// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:audioplayers/audioplayers.dart';
import 'package:elementary/elementary.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/ui/home/home_model.dart';
import 'package:spotify_skillbox/ui/home/home_widget.dart';
import 'package:spotify_skillbox/ui/home/widgets/player.dart';
import 'package:spotify_skillbox/utils/enums.dart';

abstract class IHomeWidgetModel extends IWidgetModel {
  GlobalKey<ScaffoldState> get scaffoldKey;

  ValueNotifier<TypePage> get currentPage;
  void Function(int index) get setCurrentPage;
  Map<TypePage, GlobalKey<NavigatorState>> get navigatorKeys;
  Future<bool> Function() get onWillPop;

  ValueNotifier<bool> get isShowPlayerBar;
  ValueNotifier<double> get durationTrack;
  void Function() get onOpenPlayer;
  ValueNotifier<String> get trackName;
  ValueNotifier<String> get artistName;
}

HomeWidgetModel homeWidgetModelFactory(BuildContext context) {
  final appState = context.read<AppState>();
  final player = context.read<PlayerService>();
  final collectionService = context.read<CollectionService>();
  return HomeWidgetModel(HomeModel(appState, player, collectionService));
}

class HomeWidgetModel extends WidgetModel<HomeWidget, HomeModel> implements IHomeWidgetModel {
  HomeWidgetModel(HomeModel model) : super(model);

  static const _playerHeight = 250.0;
  static const _homeIndicatorHeight = 34.0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final _currentPage = ValueNotifier<TypePage>(model.currentPage);
  final _navigatorKeys = {
    TypePage.artists: GlobalKey<NavigatorState>(),
    TypePage.search: GlobalKey<NavigatorState>(),
    TypePage.collection: GlobalKey<NavigatorState>(),
  };

  bool _isSeekProcess = false;
  late Duration _durationCurrentTrack;
  late double _screenWidth;
  ScaffoldFeatureController? _snackBarController;
  final _track = ValueNotifier<Track?>(null);
  final _isPlaying = StateNotifier<bool>(initValue: false);
  final _durationTrack = StateNotifier<Duration>(initValue: Duration.zero);
  final _currentDurationTrack = StateNotifier<Duration>(initValue: Duration.zero);
  final _isInitTrack = StateNotifier<bool>(initValue: false);
  final _isShowPlayerBar = ValueNotifier<bool>(false);
  final _durationTrackForPlayerBar = ValueNotifier<double>(0);
  final _trackName = ValueNotifier<String>('');
  final _artistName = ValueNotifier<String>('');

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  ValueNotifier<TypePage> get currentPage => _currentPage;

  @override
  void Function(int index) get setCurrentPage => _setCurrentPage;

  @override
  Map<TypePage, GlobalKey<NavigatorState>> get navigatorKeys => _navigatorKeys;

  @override
  Future<bool> Function() get onWillPop => _onWillPop;

  @override
  ValueNotifier<bool> get isShowPlayerBar => _isShowPlayerBar;

  @override
  ValueNotifier<double> get durationTrack => _durationTrackForPlayerBar;

  @override
  void Function() get onOpenPlayer => _onOpenPlayer;

  @override
  ValueNotifier<String> get artistName => _artistName;

  @override
  ValueNotifier<String> get trackName => _trackName;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    model.setMainBuildContext(context);
    model.initOpenPlayer(_onOpenPlayer);
    _screenWidth = MediaQuery.of(context).size.width;
    _listenTrackStream();
    _listenAudioStateTream();
    _listenAudioDurationStream();
    _listenAudioPositionStream();
  }

  void _setCurrentPage(int index) {
    final page = TypePage.values[index];
    _currentPage.value = page;
    model.currentPage = page;
  }

  Future<bool> _onWillPop() async {
    final navigatorKey = _navigatorKeys[_currentPage.value]!;
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop(navigatorKey.currentContext);
    } else {
      model.stopPlaybackTrack();
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
    return false;
  }

  void _onOpenPlayer() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: Platform.isIOS ? _playerHeight + _homeIndicatorHeight : _playerHeight,
      ),
      builder: (_) {
        return Player(
          playerHeight: _playerHeight,
          homeIndicatorHeight: _homeIndicatorHeight,
          isPlaybackCollection: model.isPlaybackCollection,
          track: _track,
          isPlaying: _isPlaying,
          durationTrack: _durationTrack,
          currentDurationTrack: _currentDurationTrack,
          isInitTrack: _isInitTrack,
          onPlaybackTrack: _onPlaybackTrack,
          onAddTrackInCollection: model.addTrackInCollection,
          onSeekStart: _onSeekStart,
          onSeek: _onSeek,
          onSeekEnd: _onSeekEnd,
        );
      },
    ).then((value) => _snackBarController?.close());
  }

  void _onPlaybackTrack() {
    if (_isInitTrack.value!) {
      model.playbackTrack();
    } else {
      _snackBarController = ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.endToStart,
          duration: Duration(seconds: 2),
          content: Text('Дождитесь загрузки трека!'),
        ),
      );
    }
  }

  void _onSeekStart() {
    _isSeekProcess = true;
  }

  void _onSeek(double value) {
    _currentDurationTrack.accept(Duration(milliseconds: value.toInt()));
  }

  void _onSeekEnd(double value) {
    model.seekTrack(Duration(milliseconds: value.toInt()));
    _isSeekProcess = false;
  }

  void _listenAudioStateTream() {
    model.audioStateTream.listen((state) {
      _isPlaying.accept(state == PlayerState.PLAYING);
      _isShowPlayerBar.value = state == PlayerState.PLAYING;
    });
  }

  void _listenAudioPositionStream() {
    model.audioPositionStream.listen((duration) {
      if (!_isSeekProcess) {
        _currentDurationTrack.accept(duration);
        _durationTrackForPlayerBar.value =
            (duration.inMilliseconds / _durationCurrentTrack.inMilliseconds) * _screenWidth;
      }
    });
  }

  void _listenAudioDurationStream() {
    model.audioDurationStream.listen((duration) {
      _isInitTrack.accept(true);
      _durationTrack.accept(duration);
      _durationCurrentTrack = duration;
    });
  }

  void _listenTrackStream() {
    model.trackStream.listen((track) {
      if (!model.isLastTrack) {
        _track.value = track;
        _isInitTrack.accept(false);
        _currentDurationTrack.accept(Duration.zero);
        _trackName.value = track!.name;
        _artistName.value = track.artistName;
      }

      if (model.isLastTrack && model.stateLastTrack == PlayerState.COMPLETED) {
        model.playbackTrack();
      }
    });
  }
}
