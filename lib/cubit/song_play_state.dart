part of 'song_play_cubit.dart';

@immutable
sealed class SongPlayState {}

final class SongPlayInitial extends SongPlayState {}

final class SongPlayLoading extends SongPlayState {}

final class SongPlaySuccess extends SongPlayState {
  final String songId;

  SongPlaySuccess({required this.songId});
}

final class SongPlayFailure extends SongPlayState {
  final String error;

  SongPlayFailure({required this.error});
}

final class SongPauseLoading extends SongPlayState {}

final class SongPauseSuccess extends SongPlayState {}
