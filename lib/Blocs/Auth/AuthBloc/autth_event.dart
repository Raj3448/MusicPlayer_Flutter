part of 'autth_bloc.dart';


@immutable
sealed class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String? username;
  String email;
  final String password;
  final bool isLogin;
  final File? storedImage;
  final BuildContext context;

  AuthLoginRequested(
      {
      required this.context,
      required this.username,
      required this.email,
      required this.password,
      required this.isLogin,
      required this.storedImage
      });
}

class AuthLogOutRequested extends AuthEvent{}
