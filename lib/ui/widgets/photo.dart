// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';

// Project imports:
import 'package:spotify_skillbox/utils/color_constants.dart';

class Photo extends StatelessWidget {
  final ValueNotifier<String> pathAlbumPhoto;
  final Color? colorAbsentPhoto;

  const Photo({
    Key? key,
    required this.pathAlbumPhoto,
    this.colorAbsentPhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: pathAlbumPhoto,
      builder: (_, pathAlbumPhoto, __) {
        return ExtendedImage.network(
          pathAlbumPhoto,
          fit: BoxFit.cover,
          enableLoadState: false,
          loadStateChanged: (loadStateChanged) {
            final loadSate = loadStateChanged.extendedImageLoadState;
            if (loadSate == LoadState.loading || loadSate == LoadState.failed) {
              return Container(color: colorAbsentPhoto ?? ColorConstants.greyDeep);
            }
            return null;
          },
        );
      },
    );
  }
}
