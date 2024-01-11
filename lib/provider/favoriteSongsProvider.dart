import 'package:beat_box/Blocs/Auth/AuthBloc/autth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteSongs with ChangeNotifier {
  String? uid;
  void songsAddAndRemoveAsFavorite(
      {required String songId,
      required String songsDocumentId,
      required BuildContext context,
      String? songListContentId}) async {
    if (uid == null) {
      uid = context.read<AuthBloc>().getUid;
      print('In Favorite Played Song UiD: $uid');
    }

    if (uid != null) {
      if (songListContentId == null) {
        CollectionReference<Map<String, dynamic>> collectionReference =
            await FirebaseFirestore.instance.collection('new_trending_songs');
        QuerySnapshot<Map<String, dynamic>> querySnapshot1 =
            await collectionReference.where('id', isEqualTo: songId).get();

        if (querySnapshot1.docs.isNotEmpty) {
          for (QueryDocumentSnapshot<Map<String, dynamic>> document
              in querySnapshot1.docs) {
            print('Selected Favorite song found : ${document.data()}');

            final response = await collectionReference
                .doc('${document.id}/IsFavorite/$uid')
                .get();
            bool oldData = false;
            if (response.data()!.isNotEmpty) {
              oldData = response.data()?['isFav'];
            }
              await collectionReference
                  .doc('${document.id}/IsFavorite/$uid')
                  .set({'isFav': !oldData});
          }
        }
      }

      if (songListContentId != null) {
        CollectionReference<Map<String, dynamic>> collectionReference1 =
            await FirebaseFirestore.instance
                .collection('madeForU/$songListContentId/songList');
        QuerySnapshot<Map<String, dynamic>> querySnapshot2 =
            await collectionReference1.where('id', isEqualTo: songId).get();

        if (querySnapshot2.docs.isNotEmpty) {
          for (QueryDocumentSnapshot<Map<String, dynamic>> document
              in querySnapshot2.docs) {
            print('Selected favorite song from the made for u: ${document.data()}');

            final response = await collectionReference1
                  .doc('${document.id}/IsFavorite/$uid')
                  .get();
            bool oldData = false;
            if (response.data()!.isNotEmpty) {
              oldData = response.data()?['isFav'];
            }
              await collectionReference1
                  .doc('${document.id}/IsFavorite/$uid')
                  .set({'isFav': !oldData});
          }
        }
      }
    }
  }
}
