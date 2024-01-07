import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MyCustomAudioPlayer extends ChangeNotifier {
  static AudioPlayer audioPlayer = AudioPlayer();
  static MyCustomAudioPlayer? singleInstance;
  bool isPlaying = false;
  bool get getIsPlayingOrNot {
    //notifyListeners();
    return isPlaying;
  }

  String? previousUrl;
  String id = " ";
  Duration? songDuration;
  Duration maxDuration = const Duration(minutes: 0);
  MyCustomAudioPlayer.private({Key? key});

  factory MyCustomAudioPlayer({required String? songUrl}) {
    singleInstance ??= MyCustomAudioPlayer.private();
    return singleInstance!;
  }

  void playSongByUrl({required String songUrl, required String songId}) async {
    if (isPlaying && previousUrl != songUrl) {
      audioPlayer.pause();
      isPlaying = false;
      notifyListeners();
      await audioPlayer.play(UrlSource(songUrl), mode: PlayerMode.mediaPlayer);
      songDuration = await audioPlayer.getDuration();
      previousUrl = songUrl;
      id = songId;
      isPlaying = true;
      notifyListeners();
    } else if (!isPlaying) {
      await audioPlayer.play(UrlSource(songUrl!), mode: PlayerMode.mediaPlayer);
      isPlaying = true;
      notifyListeners();
    } else if (!isPlaying || audioPlayer.state == PlayerState.completed) {
      // Play the song if it's not playing or has completed
      await audioPlayer.play(UrlSource(songUrl!), mode: PlayerMode.mediaPlayer);
      isPlaying = true;
      notifyListeners();
    }
  }

  // Duration _lastPausedDuration = Duration.zero;

  // // Method to set the last paused duration
  // void setLastPausedDuration(Duration duration) {
  //   print('last pause duration : $duration');
  //   _lastPausedDuration = duration;
  // }

  // // Method to retrieve the last paused duration
  // Duration getLastPausedDuration() {
  //   return _lastPausedDuration;
  // }

  void pauseAndResumeSong() {
    if (isPlaying) {
      audioPlayer.pause();
      isPlaying = false;
      notifyListeners();
    } else if (!isPlaying) {
      audioPlayer.resume();
      isPlaying = true;
      notifyListeners();
    }
  }
  // void pauseAndResumeSong() {
  //   if (isPlaying) {
  //     // Store the current position before pausing
  //     _lastPausedDuration = getCurrentDuration;
  //     audioPlayer.pause();
  //   } else {
  //     // Resume playback from the last paused position
  //     if (_lastPausedDuration != null) {
  //       audioPlayer.seek(_lastPausedDuration);
  //     }
  //     audioPlayer.resume();
  //   }

  //   isPlaying = !isPlaying;
  //   notifyListeners();
  // }

  Future<Duration?> get getCurrentDuration {
    var duration = audioPlayer.getCurrentPosition();
    notifyListeners();
    return duration;
  }

  Stream<Duration> getLiveduration() {
    return audioPlayer.onPositionChanged;
  }

  get getTotalDuration async {
    await audioPlayer.getDuration().then((value) {
      maxDuration = value ?? const Duration(seconds: 0);
    });
    return maxDuration;
  }

  get getSongId => id;

  void setDuration(Duration duration) {
    audioPlayer.seek(duration);
  }

  void onSongCompleted() async {
    if (!isPlaying || audioPlayer.state == PlayerState.completed) {
      // Play the song if it's not playing or has completed
      await audioPlayer.play(UrlSource(previousUrl!),
          mode: PlayerMode.mediaPlayer);
      isPlaying = true;
      notifyListeners();
    }
  }
}
