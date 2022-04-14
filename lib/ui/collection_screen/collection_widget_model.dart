// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elementary/elementary.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/entities/track.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/ui/collection_screen/collection_model.dart';
import 'package:spotify_skillbox/ui/collection_screen/collection_widget.dart';
import 'package:spotify_skillbox/ui/collection_screen/widgets/confirmation_dialog.dart';

abstract class ICollectionWidgetModel extends IWidgetModel {
  ListenableState<EntityState<List<Track>>> get tracks;
  void Function() get onSortCollection;
  Future<bool> Function() get onShowConfirmationDialog;
  void Function(bool) get onConfirmDeletion;
  void Function(int) get onDismissed;
  void Function(Track track) get onOpenPlayer;
}

CollectionWidgetModel collectionWidgetModelFactory(BuildContext context) {
  final appState = context.read<AppState>();
  final napsterService = context.read<NapsterService>();
  final collectionService = context.read<CollectionService>();
  final playerService = context.read<PlayerService>();
  return CollectionWidgetModel(
    CollectionModel(
      appState,
      napsterService,
      collectionService,
      playerService,
    ),
  );
}

class CollectionWidgetModel extends WidgetModel<CollectionWidget, CollectionModel>
    implements ICollectionWidgetModel {
  CollectionWidgetModel(CollectionModel model) : super(model);

  final _tracks = EntityStateNotifier<List<Track>>();
  bool _isDeletionConfirmed = false;

  @override
  ListenableState<EntityState<List<Track>>> get tracks => _tracks;

  @override
  void Function() get onSortCollection => _onSortCollection;

  @override
  Future<bool> Function() get onShowConfirmationDialog => _onShowConfirmationDialog;

  @override
  void Function(bool) get onConfirmDeletion => _onConfirmDeletion;

  @override
  void Function(int) get onDismissed => _onDismissed;

  @override
  void Function(Track track) get onOpenPlayer => _onOpenPlayer;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _tracks.loading();
    _lisenTracksStream();
  }

  void _lisenTracksStream() {
    model.traksStream.listen((tracks) {
      _tracks.content(tracks);
    });
  }

  void _onSortCollection() {
    model.sortCollection();
  }

  Future<bool> _onShowConfirmationDialog() async {
    _isDeletionConfirmed = false;
    await showDialog<bool>(
      context: model.mainBuildContext,
      builder: (_) {
        return ConfirmationDialog(
          onConfirmDeletion: onConfirmDeletion,
        );
      },
    );

    if (_isDeletionConfirmed) {
      return true;
    } else {
      return false;
    }
  }

  void _onConfirmDeletion(bool isDelete) {
    _isDeletionConfirmed = isDelete;
    Navigator.of(model.mainBuildContext).pop();
  }

  void _onDismissed(int trackIndex) {
    final tracks = _tracks.value!.data!.toList();
    final trackId = tracks[trackIndex].id;
    tracks.removeAt(trackIndex);
    _tracks.content(tracks);
    model.deleteTrack(trackId);
  }

  void _onOpenPlayer(Track track) {
    model.openPlayer(track);
  }
}
