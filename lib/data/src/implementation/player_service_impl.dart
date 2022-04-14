// Dart imports:
import 'dart:async';

// Package imports:
import 'package:audioplayers/audioplayers.dart';

// Project imports:
import 'package:spotify_skillbox/data/src/api/player_service.dart';
import 'package:spotify_skillbox/entities/track.dart';

class PlayerServiceImpl implements PlayerService {
  final Stream<List<Track>> _collectionStream;

  final _audioPlayer = AudioPlayer(playerId: 'player');
  Track? _track;
  late List<Track> _tracks;
  int _indexTrack = 0;
  bool _isLastTrack = false;
  bool _isPlaybackCollection = false;

  final _trackController = StreamController<Track>.broadcast();
  final _durationTrackController = StreamController<Duration>();
  final _currentDurationTrackController = StreamController<Duration>();
  final _stateTrackController = StreamController<PlayerState>();
  final _playbackController = StreamController<bool>();

  PlayerServiceImpl(this._collectionStream) {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    _collectionStreamListen();
    _durationChangedListen();
    _playerStateChangedListen();
    _audioPositionChangedListen();
  }

  @override
  bool get isLastTrack => _isLastTrack;

  @override
  PlayerState get stateLastTrack => _audioPlayer.state;

  @override
  Stream<Track> get trackStream => _trackController.stream;

  @override
  Stream<Duration> get audioDurationStream => _durationTrackController.stream;

  @override
  Stream<Duration> get audioPositionStream => _currentDurationTrackController.stream;

  @override
  Stream<PlayerState> get audioStateStream => _stateTrackController.stream;

  @override
  Stream<bool> get playbackStream => _playbackController.stream;

  @override
  void setTrack({required Track track, required bool isPlaybackCollection}) {
    _trackController.add(track);
    _isPlaybackCollection = isPlaybackCollection;
    if (_track == null || _track!.id != track.id) {
      _track = track;
      _isLastTrack = false;
      _setIndexTrack();
      _audioPlayer.stop();
      _audioPlayer.setUrl(track.previewUrl);
    } else {
      _isLastTrack = true;
    }
  }

  @override
  void playbackTrack() {
    if (_audioPlayer.state == PlayerState.PLAYING) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
  }

  @override
  void stopPlaybackTrack() {
    _audioPlayer.stop();
  }

  @override
  void seek(Duration duration) {
    _audioPlayer.seek(duration);
  }

  void _durationChangedListen() {
    _audioPlayer.onDurationChanged.listen((duration) {
      _durationTrackController.add(duration);
      _playbackController.add(true);
      _audioPlayer.resume();
    });
  }

  void _playerStateChangedListen() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _stateTrackController.add(state);
      if (state == PlayerState.COMPLETED) {
        _currentDurationTrackController.add(Duration.zero);

        if (_isPlaybackCollection) {
          if (_indexTrack != _tracks.length - 1) {
            setTrack(track: _tracks[_indexTrack + 1], isPlaybackCollection: true);
          }
        } else {
          _playbackController.add(false);
        }
      }

      if (state == PlayerState.PLAYING) {
        _playbackController.add(true);
      }
    });
  }

  void _audioPositionChangedListen() {
    _audioPlayer.onAudioPositionChanged.listen((duration) {
      _currentDurationTrackController.add(duration);
    });
  }

  void _collectionStreamListen() {
    _collectionStream.listen((tracks) {
      _tracks = tracks;
      _setIndexTrack();
    });
  }

  void _setIndexTrack() {
    if (_isPlaybackCollection) {
      _indexTrack = _tracks.indexWhere((track) => track.id == _track!.id);
    }
  }
}
