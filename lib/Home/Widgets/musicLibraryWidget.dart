import 'package:beat_box/Blocs/Auth/AuthBloc/autth_bloc.dart';
import 'package:beat_box/Home/subWidget/HorizontalCardView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MusicLibraryWidget extends StatelessWidget {
  MusicLibraryWidget._empty({Key? key}) : super(key: key);

  static MusicLibraryWidget singleInstance = MusicLibraryWidget._empty();

  factory MusicLibraryWidget() {
    return singleInstance;
  }

  @override
  Widget build(BuildContext context) {
    String uid = context.read<AuthBloc>().getUid!;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                    Text('Recently Played',
                        style: context.textTheme.displayLarge),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('RecentlyPlayed/$uid/songList')
                                .orderBy('playedAt', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Image.asset(
                                    'assets/Images/madeForU.png');
                              }
                              final List songContent = snapshot.data!.docs;
                              return ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: songContent.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return HorizontalCardView(
                                        singleSongInfo:
                                            songContent[index].data());
                                  });
                            }),
                      ),
                    ),
                    Text(
                      'Your Favorite',
                      style: context.textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
