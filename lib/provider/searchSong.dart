import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchSong with ChangeNotifier{

  Future<void> searchSong(String songName) async {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('madeForU')
          .where('name', isEqualTo: songName)
          .get();

      // Handle the query results
      if (querySnapshot.docs.isNotEmpty) {
        // Found matching documents
        for (QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs) {
          print('Song found: ${document.data()}');
          // You can handle the retrieved data as needed
        }
      } else {
        // No matching documents found
        print('Song not found');
      }
    }
}