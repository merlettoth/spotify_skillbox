// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Project imports:
import 'package:spotify_skillbox/entities/artist.dart';
import 'package:spotify_skillbox/ui/artists_screen/widgets/artist_card.dart';
import 'package:spotify_skillbox/ui/widgets/loading_widget.dart';

class ArtistList extends StatelessWidget {
  final List<Artist> artists;
  final RefreshController refreshController;
  final Future<void> Function() onRefreshArtists;
  final void Function(int index) onGoToArtistScreen;
  final bool isAllArtistsReceived;
  final ValueNotifier<bool> isLoadingArtists;

  const ArtistList({
    Key? key,
    required this.artists,
    required this.refreshController,
    required this.onRefreshArtists,
    required this.onGoToArtistScreen,
    required this.isAllArtistsReceived,
    required this.isLoadingArtists,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: false,
      enablePullUp: true,
      footer: CustomFooter(
        readyLoading: onRefreshArtists,
        loadStyle: LoadStyle.ShowWhenLoading,
        builder: (_, __) {
          return ValueListenableBuilder<bool>(
            valueListenable: isLoadingArtists,
            builder: (_, isLoadingArtists, __) {
              if (isAllArtistsReceived || !isLoadingArtists) {
                return const SizedBox.shrink();
              }
              return const LoadingWidget();
            },
          );
        },
      ),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: artists.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          crossAxisCount: 2,
          childAspectRatio: 1.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () => onGoToArtistScreen(index),
            child: ArtistCard(
              artistName: artists[index].name,
              pathPhoto: artists[index].pathPhoto,
            ),
          );
        },
      ),
    );
  }
}
