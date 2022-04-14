// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:spotify_skillbox/data/src/api/collection_service.dart';
import 'package:spotify_skillbox/entities/track.dart';

class CollectionServiceImpl implements CollectionService {
  final Stream<void> _orderStream;

  late List<Track> _tracks;
  final _tracksStreamController = StreamController<List<Track>>.broadcast();
  bool _isDirectOrder = false;

  final CollectionReference<Track> _tracksReference =
      FirebaseFirestore.instance.collection('collection').withConverter(
            fromFirestore: (snapshot, _) => Track.fromJson(snapshot.data()!),
            toFirestore: (Track track, _) => track.toJson(),
          );

  CollectionServiceImpl(this._orderStream) {
    _listenTracksReference();
    _listenDirectOrderStream();
  }

  @override
  Stream<List<Track>> get tracks => _tracksStreamController.stream;

  @override
  void addTrack(Track track) {
    track.additionTime = DateTime.now().millisecondsSinceEpoch;
    _tracksReference.doc(track.id).set(track);
  }

  @override
  void deleteTrack(String id) {
    _tracksReference.doc(id).delete();
  }

  void _listenTracksReference() {
    _tracksReference.snapshots().listen((e) {
      _tracks = e.docs.map((e) => e.data()).toList();
      _tracks.sort((a, b) => b.additionTime!.compareTo(a.additionTime!));
      _tracksStreamController.add(_isDirectOrder ? _tracks : _tracks.reversed.toList());
    });
  }

  void _listenDirectOrderStream() {
    _orderStream.listen((_) {
      _isDirectOrder = !_isDirectOrder;
      _tracksStreamController.add(_isDirectOrder ? _tracks : _tracks.reversed.toList());
    });
  }
}
