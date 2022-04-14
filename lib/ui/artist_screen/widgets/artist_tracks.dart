// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/widgets/track_card.dart';

class ArtistTracks extends StatelessWidget {
  final ValueNotifier<List<Track>> tracks;
  final void Function(Track) onOpenPlayer;

  const ArtistTracks({
    Key? key,
    required this.tracks,
    required this.onOpenPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Track>>(
      valueListenable: tracks,
      builder: (_, tracks, __) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              return GestureDetector(
                onTap: () => onOpenPlayer(tracks[index]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                  child: TrackCard(track: tracks[index]),
                ),
              );
            },
            childCount: tracks.length,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
          ),
        );
      },
    );
  }
}
