import 'package:flutter/foundation.dart';

class SongInfo extends ChangeNotifier {
  String name;
  String singer;
  String imageUrl;
  String songUrl;
  String id;
  static SongInfo? singleInstance;
  SongInfo._private(
      {required this.name,
      required this.singer,
      required this.imageUrl,
      required this.songUrl,
      required this.id});

  factory SongInfo(
      {String? name,
      String? singer,
      String? imageUrl,
      String? songUrl,
      String? id}) {
    singleInstance ??= SongInfo._private(
        name: name!,
        singer: singer!,
        imageUrl: imageUrl!,
        songUrl: songUrl!,
        id: id!);

    return singleInstance!;
  }

  SongInfo? get getSongInfoInstance {
    notifyListeners();
    return singleInstance;
  }

  String toString() {
    return '[Songname: $name , SingerName: $singer , ImageUrl: $imageUrl , SongUrl: $songUrl]';
  }
}
