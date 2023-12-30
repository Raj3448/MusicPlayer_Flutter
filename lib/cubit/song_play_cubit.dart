import 'package:beat_box/Blocs/Auth/AuthBloc/autth_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
part 'song_play_state.dart';

class SongPlayCubit extends Cubit<SongPlayState> {
  static var player;
  static dynamic songObject;
  late final Duration? duration;
  SongPlayCubit() : super(SongPlayInitial());

  void playSongByURl(
      {required String? songUrl, required dynamic songObject}) async {
    emit(SongPlayLoading());
    if (player != null) {
      stopAudio();
      player = null;
    }
    player = AudioPlayer();
    SongPlayCubit.songObject = songObject;
    try {
      duration = await player.setUrl(songUrl!);
      if(!player.playing){
        await player.play();
      }
      await player.play();
      
      emit(SongPlaySuccess(songId: songObject['id']));
    } catch (error) {
      emit(SongPlayFailure(error: error.toString()));
    }
  }

  void pauseAndResumeAudio() async {
    emit(SongPauseLoading());
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
      emit(SongPlaySuccess(songId: songObject['id']));
    }
    emit(SongPauseSuccess());
  }

  void resumeAudio() async {
    await player.play();
  }

  void stopAudio() async {
    await player.stop();
  }

  void pushSongBy10Sec() async {
    await player.seek(const Duration(seconds: 10));
  }

  void poolSongBy10Sec() async {
    await player.seek(const Duration(seconds: -10));
  }
}
