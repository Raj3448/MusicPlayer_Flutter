import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'autth_event.dart';
part 'autth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String? _receivedUID = null;
  late final _imageUrl;

  String? get getUid {
    return _receivedUID;
  }

  get getImageUrl {
    return _imageUrl;
  }

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(
        (AuthLoginRequested event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      await _authLoginRequested(event);
    });

    on<AuthLogOutRequested>(
        (AuthLogOutRequested event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      await _authLogOutRequested(event);
    });

    // @override
    // void onChange(Change<AuthState> change) {
    //   print('AuthBloc Change -> $change');
    //   super.onChange(change);
    // }

    // @override
    // void onTransition(Transition<AuthEvent, AuthState> transition) {
    //   print('AuthBloc Transition -> $transition');
    //   super.onTransition(transition);
    // }
  }
  Future<void> _authLoginRequested(AuthLoginRequested event) async {
    if (event.isLogin) {
      await signInWithEmailAndPassword(
          event.email, event.password, event.context);
    } else {
      await createUserWithEmailAndPassword(event.username!, event.email,
          event.password, event.storedImage, event.context, event.storedImage!);
    }
  }

  Future<void> _authLogOutRequested(AuthLogOutRequested event) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      emit(AuthFailure(error: 'Error during logout please retry'));
    }
    emit(AuthInitial());
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    debugPrint("In SignIn");
    try {
      var _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        debugPrint('User has been successfully signed in');
        debugPrint('User Credentials: ${userCredential.user}');
        _receivedUID = userCredential.user!.uid;
        emit(AuthSuccess(UID: _receivedUID!));
      } else {
        debugPrint('User is null after sign-in.');
        emit(AuthFailure(error: "User is null after sign-in."));
      }
    } on FirebaseAuthException catch (error) {
      String erMsg = 'An error Occured, Please Check your Credentials!';
      if (error.code == 'user-not-found') {
        erMsg = 'No user found for that email.';
        debugPrint('No user found for that email.');
        emit(AuthFailure(error: 'No user found for that email.'));
      } else if (error.code == 'wrong-password') {
        erMsg = 'Wrong password provided for that user.';
        debugPrint('Wrong password provided for that user.');
        emit(AuthFailure(error: 'Wrong password provided for that user.'));
      }
    } catch (error) {
      debugPrint('error during signIn : $error');
      emit(AuthFailure(error: 'error during signIn '));
    }
    debugPrint('Received UID : $_receivedUID');
  }

  Future<void> createUserWithEmailAndPassword(
      String userName,
      String email,
      String password,
      File? imagefile,
      BuildContext context,
      File storedImage) async {
    debugPrint("In SignUp");
    try {
      var _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        debugPrint('New User has been created successfully');
        debugPrint('New User Credentials: ${userCredential.user}');
        _receivedUID = userCredential.user!.uid;
        
        final imageRef =
            FirebaseStorage.instance.ref().child('userImage').child('$getUid.jpg');
        final imageSnapShot =
            await imageRef.putFile(imagefile!).whenComplete(() {
          print('Image Uploded Successfully');
        });
        _imageUrl = await imageRef.getDownloadURL();
        emit(AuthSuccess(UID: _receivedUID!));
        debugPrint('Image SnapShot :$imageSnapShot');
        if (_receivedUID != null) {
          FirebaseFirestore.instance
              .collection('usersDoc')
              .doc(_receivedUID)
              .set({
            'userName': userName,
            'email': email,
            'imageURL': _imageUrl,
          });
        }
      } else {
        emit(AuthFailure(error: 'New User is null after sign-in.'));
        debugPrint('New User is null after sign-in.');
      }
    } on FirebaseAuthException catch (e) {
      String erMsg = 'An error Occured, Please Check your Credentials!';
      if (e.code == 'weak-password') {
        erMsg = 'The password provided is too weak.';
        debugPrint('The password provided is too weak.');
        emit(AuthFailure(error: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        erMsg = 'The account already exists for that email.';
        debugPrint('The account already exists for that email.');
        emit(AuthFailure(error: 'The account already exists for that email.'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
      debugPrint(e.toString());
    }
  }
}
