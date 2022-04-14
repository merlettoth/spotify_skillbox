// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/ui/widgets/photo.dart';
import 'package:spotify_skillbox/utils/color_constants.dart';

class ArtistAppBar extends StatelessWidget {
  final String name;
  final ValueNotifier<String> pathPhoto;
  final double appBarHeight;
  final double expandedHeight;
  final double Function(double) interpolateFontWeightAppBarTitle;

  const ArtistAppBar({
    Key? key,
    required this.name,
    required this.pathPhoto,
    required this.appBarHeight,
    required this.expandedHeight,
    required this.interpolateFontWeightAppBarTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        return SliverAppBar(
          expandedHeight: expandedHeight,
          pinned: true,
          leading: IconButton(
            iconSize: 40,
            icon: const Icon(
              Icons.chevron_left,
              color: ColorConstants.primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 24 / 17,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 0.31,
                  fontWeight: FontWeight.lerp(
                    FontWeight.w400,
                    FontWeight.w700,
                    interpolateFontWeightAppBarTitle(constraints.cacheOrigin),
                  ),
                ),
              ),
            ),
            centerTitle: true,
            background: SizedBox(
              width: constraints.crossAxisExtent,
              height: appBarHeight,
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: Photo(pathAlbumPhoto: pathPhoto),
                  ),
                  Container(
                    width: constraints.crossAxisExtent,
                    height: appBarHeight,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0),
                          Color.fromRGBO(0, 0, 0, 0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
