// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/home/widgets/control_playback.dart';
import 'package:spotify_skillbox/ui/home/widgets/track_data.dart';
import 'package:spotify_skillbox/utils/color_constants.dart';

class Player extends StatelessWidget {
  final double playerHeight;
  final double homeIndicatorHeight;
  final bool isPlaybackCollection;
  final ValueNotifier<Track?> track;
  final ListenableState<bool> isPlaying;
  final ListenableState<Duration> durationTrack;
  final ListenableState<Duration> currentDurationTrack;
  final ListenableState<bool> isInitTrack;
  final void Function() onPlaybackTrack;
  final void Function() onAddTrackInCollection;
  final void Function() onSeekStart;
  final void Function(double) onSeek;
  final void Function(double) onSeekEnd;

  const Player({
    Key? key,
    required this.playerHeight,
    required this.homeIndicatorHeight,
    required this.isPlaybackCollection,
    required this.track,
    required this.isPlaying,
    required this.durationTrack,
    required this.currentDurationTrack,
    required this.isInitTrack,
    required this.onPlaybackTrack,
    required this.onAddTrackInCollection,
    required this.onSeekStart,
    required this.onSeek,
    required this.onSeekEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Platform.isIOS ? playerHeight + homeIndicatorHeight : playerHeight,
        decoration: const BoxDecoration(
          color: ColorConstants.greyDeep,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Builder(
          builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: playerHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TrackData(
                        track: track,
                        onAddTrackInCollection: onAddTrackInCollection,
                        isPlaybackCollection: isPlaybackCollection,
                      ),
                      MultiListenerRebuilder(
                        listenableList: [
                          isPlaying,
                          durationTrack,
                          currentDurationTrack,
                          isInitTrack,
                        ],
                        builder: (_) {
                          return ControlPlayback(
                            onPlaybackTrack: onPlaybackTrack,
                            isInitTrack: isInitTrack.value!,
                            isPlaying: isPlaying.value!,
                            durationTrack: durationTrack.value!,
                            currentDurationTrack: currentDurationTrack.value!,
                            onSeekStart: onSeekStart,
                            onSeek: onSeek,
                            onSeekEnd: onSeekEnd,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (Platform.isIOS) SizedBox(height: homeIndicatorHeight),
              ],
            );
          },
        ),
      ),
    );
  }
}
