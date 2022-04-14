// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/widgets/photo.dart';
import 'package:spotify_skillbox/utils/color_constants.dart';

const _widgetHeight = 65.0;
const _horizontalPadding = 25.0;
const _playIconWidth = 60.0;
const _offsetText = 80;

class TrackCard extends StatelessWidget {
  final Track track;
  final bool? isCollectionPage;

  const TrackCard({
    Key? key,
    required this.track,
    this.isCollectionPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textWidth = screenWidth - (_offsetText + _horizontalPadding * 2 + _playIconWidth);
    final isCollection = isCollectionPage != null;

    return Container(
      height: _widgetHeight,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: isCollection ? ColorConstants.greyDeep : ColorConstants.blackMatte,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          SizedBox.square(
            dimension: _widgetHeight,
            child: Photo(
              pathAlbumPhoto: track.pathAlbumPhoto,
              colorAbsentPhoto: isCollection ? ColorConstants.silver : null,
            ),
          ),
          _Name(
            name: track.name,
            width: textWidth,
            isCollection: isCollection,
          ),
          _Album(
            album: track.albumName,
            width: textWidth,
            isCollection: isCollection,
          ),
          if (isCollection)
            _Artist(
              artist: track.artistName,
              width: textWidth,
            ),
          const _PlayIcon(),
        ],
      ),
    );
  }
}

class _Artist extends StatelessWidget {
  final String artist;
  final double width;

  const _Artist({
    Key? key,
    required this.artist,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const position = Offset(80, 11);
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: SizedBox(
        width: width,
        child: Text(
          artist.replaceAll('', '\u{200B}'),
          style: const TextStyle(
            fontSize: 10,
            overflow: TextOverflow.ellipsis,
            letterSpacing: -0.41,
          ),
        ),
      ),
    );
  }
}

class _Name extends StatelessWidget {
  final String name;
  final double width;
  final bool isCollection;

  const _Name({
    Key? key,
    required this.name,
    required this.width,
    required this.isCollection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final position = isCollection ? const Offset(80, 21) : const Offset(80, 13);
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: SizedBox(
        width: width,
        child: Text(
          name.replaceAll('', '\u{200B}'),
          style: const TextStyle(
            fontSize: 15,
            overflow: TextOverflow.ellipsis,
            height: 20 / 15,
          ),
        ),
      ),
    );
  }
}

class _Album extends StatelessWidget {
  final String album;
  final double width;
  final bool isCollection;

  const _Album({
    Key? key,
    required this.album,
    required this.width,
    required this.isCollection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final position = isCollection ? const Offset(80, 43) : const Offset(80, 37);
    final prefixText = isCollection ? 'Album: ' : '';
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: SizedBox(
        width: width,
        child: Text(
          '$prefixText${album.replaceAll('', '\u{200B}')}',
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: -0.41,
            color: ColorConstants.grayMiddle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _PlayIcon extends StatelessWidget {
  const _PlayIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 16, top: 16.5, bottom: 16.5),
        child: const Icon(
          Icons.play_circle_outline,
          size: 32,
          color: ColorConstants.primary,
        ),
      ),
    );
  }
}
