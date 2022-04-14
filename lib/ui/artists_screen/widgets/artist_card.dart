// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/ui/widgets/photo.dart';
import 'package:spotify_skillbox/utils/color_constants.dart';

class ArtistCard extends StatelessWidget {
  final String artistName;
  final ValueNotifier<String> pathPhoto;

  const ArtistCard({
    Key? key,
    required this.artistName,
    required this.pathPhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: ColorConstants.greyDeep,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 75,
            child: SizedBox(
              width: double.infinity,
              child: Photo(pathAlbumPhoto: pathPhoto),
            ),
          ),
          Expanded(
            flex: 45,
            child: Container(
              color: ColorConstants.deepBlack,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    artistName,
                    style: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
