import 'package:beat_box/Blocs/Auth/AuthBloc/autth_bloc.dart';
import 'package:beat_box/models/songDetailsTemplate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentlyPlayedSongAdd with ChangeNotifier {
  String? uid;
  void addSongIntoDB(
      SongDetailsTemplate songDetailsTemplate, BuildContext context) async {
    try {
      if (uid == null) {
        uid = context.read<AuthBloc>().getUid;
        
        print('Recently Played Song UiD: $uid');
      }
      if (uid != null) {
        //if the songDocument is found then delete it
        CollectionReference<Map<String, dynamic>> collectionReference =
            await FirebaseFirestore.instance
                .collection('RecentlyPlayed/$uid/songList');
        QuerySnapshot<Map<String, dynamic>> querySnapshot1 =
            await collectionReference
                .where('id', isEqualTo: songDetailsTemplate.id)
                .get();
        bool isFound = false;
        if (querySnapshot1.docs.isNotEmpty) {
          for (QueryDocumentSnapshot<Map<String, dynamic>> document
              in querySnapshot1.docs) {
            print('Song found by id: ${document.data()}');

            isFound = true;
            collectionReference.doc(document.id).delete();
          }
        }

        if (isFound) {
          print('Song found and then successfully delete');
        }

        CollectionReference<Map<String, dynamic>> usersCollection =
            await FirebaseFirestore.instance
                .collection('RecentlyPlayed/$uid/songList');

        usersCollection.add({
          'id': songDetailsTemplate.id,
          'name': songDetailsTemplate.name,
          'imageUrl': songDetailsTemplate.imageUrl,
          'songUrl': songDetailsTemplate.songUrl,
          'singer': songDetailsTemplate.singer,
          'playedAt': DateTime.now()
        });

        notifyListeners();
        print('Recently Played Song Added Response:: : ');
      }
    } catch (error) {
      print('Exception occured during recently plyed song added :$error');
    }
  }
}