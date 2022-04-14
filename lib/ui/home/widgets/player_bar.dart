// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/utils/color_constants.dart';

class PlayerBar extends StatelessWidget {
  final ValueNotifier<bool> isShow;
  final ValueNotifier<double> curretnDurationValue;
  final void Function() onOpenPlayer;
  final ValueNotifier<String> artistName;
  final ValueNotifier<String> trackName;

  const PlayerBar({
    Key? key,
    required this.isShow,
    required this.curretnDurationValue,
    required this.onOpenPlayer,
    required this.artistName,
    required this.trackName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isShow,
      builder: (_, isShow, __) {
        if (isShow) {
          return GestureDetector(
            onTap: onOpenPlayer,
            child: Container(
              height: 48,
              width: double.infinity,
              color: ColorConstants.deepBlack,
              child: Column(
                children: [
                  _DurationTrackIndicator(value: curretnDurationValue),
                  _TrackName(name: trackName),
                  _ArtistName(name: artistName),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _DurationTrackIndicator extends StatelessWidget {
  final ValueNotifier<double> value;

  const _DurationTrackIndicator({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 3,
      width: screenWidth,
      color: ColorConstants.greyDeep,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ValueListenableBuilder<double>(
          valueListenable: value,
          builder: (_, value, __) {
            return Container(
              height: 3,
              width: value,
              color: ColorConstants.primary,
            );
          },
        ),
      ),
    );
  }
}

class _ArtistName extends StatelessWidget {
  final ValueNotifier<String> name;

  const _ArtistName({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 25, right: 25),
      child: ValueListenableBuilder<String>(
        valueListenable: name,
        builder: (_, name, __) {
          return Text(
            name.replaceAll('', '\u{200B}'),
            style: const TextStyle(
              fontSize: 12,
              color: ColorConstants.grayMiddle,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }
}

class _TrackName extends StatelessWidget {
  final ValueNotifier<String> name;

  const _TrackName({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 25, right: 25),
      child: ValueListenableBuilder<String>(
        valueListenable: name,
        builder: (_, name, __) {
          return Text(
            name.replaceAll('', '\u{200B}'),
            style: const TextStyle(
              fontSize: 15,
              overflow: TextOverflow.ellipsis,
              height: 20 / 15,
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}
