// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/widgets/track_card.dart';

class CollectionTracks extends StatelessWidget {
  final List<Track> tracks;
  final Future<bool> Function() onShowConfirmationDialog;
  final void Function(int) onDismissed;
  final void Function(Track) onOpenPlayer;

  const CollectionTracks({
    Key? key,
    required this.tracks,
    required this.onShowConfirmationDialog,
    required this.onDismissed,
    required this.onOpenPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const Center(
        child: Text('Коллекция пуста'),
      );
    }

    return ListView.builder(
      itemCount: tracks.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, index) {
        final track = tracks[index];
        return Padding(
          padding: EdgeInsets.only(
            top: index == 0 ? 15 : 0,
            bottom: 15,
            left: 25,
            right: 25,
          ),
          child: Dismissible(
            key: Key(track.id),
            confirmDismiss: (_) => onShowConfirmationDialog(),
            resizeDuration: const Duration(microseconds: 1),
            onDismissed: (_) => onDismissed(index),
            child: GestureDetector(
              onTap: () => onOpenPlayer(track),
              child: TrackCard(
                track: track,
                isCollectionPage: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
