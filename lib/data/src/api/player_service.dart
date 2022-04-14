// Package imports:
import 'package:audioplayers/audioplayers.dart';

// Project imports:
import 'package:spotify_skillbox/entities/track.dart';

abstract class PlayerService {
  void setTrack({required Track track, required bool isPlaybackCollection});
  void playbackTrack();
  void stopPlaybackTrack();
  void seek(Duration duration);
  bool get isLastTrack;
  PlayerState get stateLastTrack;
  Stream<Duration> get audioPositionStream;
  Stream<PlayerState> get audioStateStream;
  Stream<Duration> get audioDurationStream;
  Stream<bool> get playbackStream;
  Stream<Track> get trackStream;
}
