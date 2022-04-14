// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/utils/color_constants.dart';
import 'package:spotify_skillbox/utils/extensions.dart';

class ControlPlayback extends StatelessWidget {
  final bool isInitTrack;
  final bool isPlaying;
  final Duration durationTrack;
  final Duration currentDurationTrack;
  final void Function() onPlaybackTrack;
  final void Function(double) onSeek;
  final void Function() onSeekStart;
  final void Function(double) onSeekEnd;

  const ControlPlayback({
    Key? key,
    required this.isInitTrack,
    required this.isPlaying,
    required this.durationTrack,
    required this.currentDurationTrack,
    required this.onPlaybackTrack,
    required this.onSeek,
    required this.onSeekStart,
    required this.onSeekEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Stack(
            children: [
              _ControlButton(
                isEnable: isInitTrack,
                isPlaying: isPlaying,
                onPlaybackTrack: onPlaybackTrack,
              ),
              _Slider(
                isEnable: isInitTrack,
                currentValue: currentDurationTrack.inMilliseconds.toDouble(),
                maxValue: durationTrack.inMilliseconds.toDouble(),
                onSeek: onSeek,
                onSeekStart: (value) => onSeekStart(),
                onSeekEnd: onSeekEnd,
              ),
              _DurationsTrack(
                durationTrack: durationTrack.toStringForPlayer,
                currentDurationTrack: currentDurationTrack.toStringForPlayer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationsTrack extends StatelessWidget {
  final String durationTrack;
  final String currentDurationTrack;

  const _DurationsTrack({
    Key? key,
    required this.durationTrack,
    required this.currentDurationTrack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const paddingLeft = 78.0;
    const paddingRight = 25.0;

    return Positioned(
      left: paddingLeft,
      top: 34,
      child: SizedBox(
        width: screenWidth - (paddingLeft + paddingRight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Text(currentDurationTrack),
            _Text(durationTrack),
          ],
        ),
      ),
    );
  }
}

class _Text extends StatelessWidget {
  final String text;

  const _Text(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: ColorConstants.grayMiddle,
        letterSpacing: -0.41,
        fontSize: 10,
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  final bool isEnable;
  final double maxValue;
  final double currentValue;
  final void Function(double) onSeek;
  final void Function(double) onSeekStart;
  final void Function(double) onSeekEnd;

  const _Slider({
    Key? key,
    required this.isEnable,
    required this.maxValue,
    required this.currentValue,
    required this.onSeek,
    required this.onSeekStart,
    required this.onSeekEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const paddingLeft = 78.0;
    const paddingRight = 25.0;
    const _sliderHeight = 36.0;

    return Positioned(
      left: paddingLeft,
      top: 5,
      child: SizedBox(
        height: _sliderHeight,
        width: screenWidth - (paddingLeft + paddingRight),
        child: SliderTheme(
          data: SliderThemeData(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
            trackShape: _CustomTrackShape(),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: _sliderHeight / 2),
          ),
          child: Slider(
            onChanged: isEnable ? onSeek : null,
            onChangeStart: onSeekStart,
            onChangeEnd: onSeekEnd,
            value: currentValue,
            max: maxValue,
            activeColor: ColorConstants.primary,
            inactiveColor: ColorConstants.grayMiddle,
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final bool isEnable;
  final bool isPlaying;
  final void Function() onPlaybackTrack;

  const _ControlButton({
    Key? key,
    required this.isEnable,
    required this.isPlaying,
    required this.onPlaybackTrack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPlaybackTrack,
        iconSize: 32,
        icon: Icon(
          isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
          color: isEnable ? ColorConstants.primary : const Color.fromRGBO(158, 158, 158, 1),
        ),
      ),
    );
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop = parentBox.size.height / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
