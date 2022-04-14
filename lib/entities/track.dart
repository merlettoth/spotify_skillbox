// Flutter imports:
import 'package:flutter/cupertino.dart';

class Track {
  final String id;
  final String href;
  final String name;
  final String albumName;
  final String artistName;
  final String albumHref;
  final pathAlbumPhoto = ValueNotifier<String>('');
  final String previewUrl;
  int? additionTime;

  Track({
    required this.id,
    required this.href,
    required this.name,
    required this.albumName,
    required this.artistName,
    required this.albumHref,
    required this.previewUrl,
    this.additionTime,
  });

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        id: json['id'] as String,
        href: json['href'] as String,
        name: json['name'] as String,
        albumName: json['albumName'] as String,
        artistName: json['artistName'] as String,
        albumHref: json['albumHref'] as String,
        previewUrl: json['previewUrl'] as String,
        additionTime: json['additionTime'] as int,
      )..pathAlbumPhoto.value = json['pathAlbumPhoto'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'href': href,
        'name': name,
        'albumName': albumName,
        'artistName': artistName,
        'albumHref': albumHref,
        'previewUrl': previewUrl,
        'additionTime': additionTime,
        'pathAlbumPhoto': pathAlbumPhoto.value,
      };
}
