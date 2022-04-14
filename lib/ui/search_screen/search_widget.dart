// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/ui/search_screen/search_widget_model.dart';
import 'package:spotify_skillbox/ui/search_screen/widgets/search_text_field.dart';
import 'package:spotify_skillbox/ui/widgets/artist_list.dart';
import 'package:spotify_skillbox/ui/widgets/loading_widget.dart';

class SearchWidget extends ElementaryWidget<ISearchWidgetModel> {
  static const routeName = '/';

  const SearchWidget({
    Key? key,
    WidgetModelFactory wmFactory = searchWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ISearchWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: SearchTextField(onSearchArtists: wm.onSearchArtists),
      ),
      body: EntityStateNotifierBuilder<List<Artist>>(
        listenableEntityState: wm.artists,
        loadingBuilder: (_, __) {
          return const LoadingWidget();
        },
        builder: (_, artists) {
          if (artists!.isEmpty) {
            if (wm.isLastActionSearch) {
              return const Center(
                child: Text('Ничего не найдено'),
              );
            }
            return const SizedBox.shrink();
          }

          return ArtistList(
            artists: artists,
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
