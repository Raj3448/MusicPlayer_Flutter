import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchSong with ChangeNotifier {
  Future<void> searchSong(String songName) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot1 = await FirebaseFirestore
        .instance
        .collection('new_trending_songs')
        .where('name', isEqualTo: songName)
        .get();
    bool isFound = false;
    // Handle the query results
    if (querySnapshot1.docs.isNotEmpty) {
      // Found matching documents
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot1.docs) {
        print('Song found: ${document.data()}');
        // You can handle the retrieved data as needed
        isFound = true;
      }

      if (!isFound) {
        Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot2 =
            await FirebaseFirestore.instance.collection('madeForU').snapshots();

        await for (QuerySnapshot<Map<String, dynamic>> event
            in querySnapshot2) {
          final docsList = event.docs;

          for (QueryDocumentSnapshot<Map<String, dynamic>> singleDocument
              in docsList) {
            QuerySnapshot<Map<String, dynamic>> querySnapshot3 =
                await FirebaseFirestore.instance
                    .collection('madeForU/${singleDocument.id}/songList')
                    .where('name', isEqualTo: songName)
                    .get();

            if (querySnapshot3.docs.isNotEmpty) {
              for (QueryDocumentSnapshot<Map<String, dynamic>> document
                  in querySnapshot3.docs) {
                print('Song found: ${document.data()}');
                // You can handle the retrieved data as needed
                return;
              }
            }
          }
        }
      } else {
        // No matching documents found
        print('Song not found');
      }
    }
  }
}