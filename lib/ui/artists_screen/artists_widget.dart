// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/ui/artists_screen/artists_widget_model.dart';
import 'package:spotify_skillbox/ui/widgets/artist_list.dart';
import 'package:spotify_skillbox/ui/widgets/loading_widget.dart';

class ArtistsWidget extends ElementaryWidget<IArtistsWidgetModel> {
  static const routeName = '/';

  const ArtistsWidget({
    Key? key,
    WidgetModelFactory wmFactory = artistsWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IArtistsWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Исполнители'),
        centerTitle: false,
      ),
      body: EntityStateNotifierBuilder<List<Artist>>(
        listenableEntityState: wm.artists,
        loadingBuilder: (_, __) {
          return const LoadingWidget();
        },
        builder: (_, artists) {
          return ArtistList(
            artists: artists!,
            refreshController: wm.refreshController,
            onRefreshArtists: wm.onRefreshArtists,
            onGoToArtistScreen: wm.onGoToArtistScreen,
            isAllArtistsReceived: wm.isAllArtistsReceived,
            isLoadingArtists: wm.isLoadingArtists,
          );
        },
      ),
    );
  }
}
