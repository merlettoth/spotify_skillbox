// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';

// Project imports:
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/collection_screen/collection_widget_model.dart';
import 'package:spotify_skillbox/ui/collection_screen/widgets/collection_tracks.dart';
import 'package:spotify_skillbox/ui/collection_screen/widgets/sort_collection_button.dart';
import 'package:spotify_skillbox/ui/widgets/loading_widget.dart';

class CollectionWidget extends ElementaryWidget<ICollectionWidgetModel> {
  const CollectionWidget({
    Key? key,
    WidgetModelFactory wmFactory = collectionWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ICollectionWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Коллекция'),
        centerTitle: false,
        actions: [SortCollectionButton(onSortCollection: wm.onSortCollection)],
      ),
      body: EntityStateNotifierBuilder<List<Track>>(
        listenableEntityState: wm.tracks,
        loadingBuilder: (_, __) {
          return const LoadingWidget();
        },
        builder: (_, tracks) {
          return CollectionTracks(
            tracks: tracks!,
            onShowConfirmationDialog: wm.onShowConfirmationDialog,
            onDismissed: wm.onDismissed,
            onOpenPlayer: wm.onOpenPlayer,
          );
        },
      ),
    );
  }
}
