import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusicLibraryWidget extends StatelessWidget {
  MusicLibraryWidget._empty({Key? key}) : super(key: key);

  static MusicLibraryWidget singleInstance = MusicLibraryWidget._empty();

  factory MusicLibraryWidget() {
    return singleInstance;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
                Text(
                  ' My Library',
                  style: TextStyle(
                      fontFamily: 'MyUniqueFont',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Recently Played', style: context.textTheme.displayLarge)
            
          ],
        ),
      ),
    );
  }
}
