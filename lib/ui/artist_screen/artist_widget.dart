// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/ui/artist_screen/artist_widget_model.dart';
import 'package:spotify_skillbox/ui/artist_screen/widgets/artist_app_bar.dart';
import 'package:spotify_skillbox/ui/artist_screen/widgets/artist_bio.dart';
import 'package:spotify_skillbox/ui/artist_screen/widgets/artist_tracks.dart';
import 'package:spotify_skillbox/ui/artist_screen/widgets/loading_tracks.dart';
import 'package:spotify_skillbox/utils/color_constants.dart';

class ArtistWidget extends ElementaryWidget<IArtistWidgetModel> {
  static const routeName = '/artist';

  const ArtistWidget({
    Key? key,
    WidgetModelFactory wmFactory = artistWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IArtistWidgetModel wm) {
    return Container(
      color: ColorConstants.deepBlack,
      child: CustomScrollView(
        slivers: [
          ArtistAppBar(
            name: wm.name,
            pathPhoto: wm.pathPhoto,
            appBarHeight: wm.appBarHeight,
            expandedHeight: wm.expandedHeight,
            interpolateFontWeightAppBarTitle: wm.interpolateFontWeightAppBarTitle,
          ),
          ArtistBio(bio: wm.bio),
          ArtistTracks(
            tracks: wm.tracks,
            onOpenPlayer: wm.onOpenPlayer,
          ),
          LoadingTracksButton(
            isLoadingTracks: wm.isLoadingTracks,
            onLoadTracks: wm.onLoadTracks,
            isAllSongsReceived: wm.isAllSongsReceived,
          ),
        ],
      ),
    );
  }
}
