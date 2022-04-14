// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/widgets/photo.dart';
import 'package:spotify_skillbox/utils/color_constants.dart';

class TrackData extends StatelessWidget {
  final ValueNotifier<Track?> track;
  final bool isPlaybackCollection;
  final void Function() onAddTrackInCollection;

  const TrackData({
    Key? key,
    required this.track,
    required this.isPlaybackCollection,
    required this.onAddTrackInCollection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<Track?>(
        valueListenable: track,
        builder: (_, track, __) {
          return Stack(
            children: [
              _Photo(pathAlbumPhoto: track!.pathAlbumPhoto),
              _Album(
                name: track.albumName,
                isCollection: isPlaybackCollection,
              ),
              _Track(
                name: track.name,
                isCollection: isPlaybackCollection,
              ),
              if (!isPlaybackCollection)
                _CollectionButton(
                  onAddTrackInCollection: onAddTrackInCollection,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Album extends StatelessWidget {
  final String name;
  final bool isCollection;

  const _Album({
    Key? key,
    required this.name,
    required this.isCollection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final position = isCollection ? const Offset(140, 59) : const Offset(140, 25);
    const rightPadding = 50;
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      top: position.dy,
      left: position.dx,
      child: SizedBox(
        width: screenWidth - position.dx - rightPadding,
        child: Text(
          name.replaceAll('', '\u{200B}'),
          style: const TextStyle(
            fontSize: 10,
            color: ColorConstants.grayMiddle,
            letterSpacing: -0.41,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _Track extends StatelessWidget {
  final String name;
  final bool isCollection;

  const _Track({
    Key? key,
    required this.name,
    required this.isCollection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final position = isCollection ? const Offset(140, 76) : const Offset(140, 42);
    const rightPadding = 50;
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      top: position.dy,
      left: position.dx,
      child: SizedBox(
        width: screenWidth - position.dx - rightPadding,
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

class _Photo extends StatelessWidget {
  final ValueNotifier<String> pathAlbumPhoto;

  const _Photo({
    Key? key,
    required this.pathAlbumPhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 25,
      top: 25,
      child: Container(
        height: 100,
        width: 100,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Photo(pathAlbumPhoto: pathAlbumPhoto),
      ),
    );
  }
}

class _CollectionButton extends StatelessWidget {
  final void Function() onAddTrackInCollection;

  const _CollectionButton({
    Key? key,
    required this.onAddTrackInCollection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const position = Offset(140, 95);

    return Positioned(
      top: position.dy,
      left: position.dx,
      child: SizedBox(
        width: 120,
        height: 30,
        child: ElevatedButton(
          onPressed: onAddTrackInCollection,
          style: ElevatedButton.styleFrom(
            primary: ColorConstants.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 0,
          ),
          child: const Text(
            'В коллекцию',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
