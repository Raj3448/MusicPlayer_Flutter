import 'package:beat_box/Home/subWidget/playListWidget.dart';
import 'package:beat_box/provider/SongInfo.dart';
import 'package:beat_box/provider/audioPlayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayListScreen extends StatelessWidget {
  final dynamic playListInfo;
  final String documentId;
  PlayListScreen(
      {Key? key, required this.playListInfo, required this.documentId})
      : super(key: key);
  SongInfo songInfo = SongInfo(
      id: "jnjk",
      name: "Deva Shree Ganesha",
      singer: "Ajay Gogavale",
      imageUrl:
          "https://a10.gaanacdn.com/images/albums/57/64957/crop_480x480_64957.jpg",
      songUrl:
          "https://pagalfree.com/musics/128-Deva%20Shree%20Ganesha%20-%20Agneepath%20128%20Kbps.mp3");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 2, 6, 36),
            ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Image.network(
                      playListInfo.data()['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.directional(
                    top: 50,
                    start: 25,
                    textDirection: TextDirection.ltr,
                    child: Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                )),
                            const Spacer(),
                            Text(
                              '${playListInfo.data()['title']}',
                              style: const TextStyle(
                                  fontFamily: 'MyUniqueFont',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 93, 3, 247)),
                          shape: MaterialStatePropertyAll(CircleBorder())),
                      child: const Icon(
                        Icons.play_circle_fill_rounded,
                        size: 50,
                        color: Colors.white,
                      )),
                  const Text(
                    'PlayList',
                    style: TextStyle(
                        fontFamily: 'MyUniqueFont',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.shuffle_on_rounded))
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.62,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('madeForU/$documentId/songList')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final List songContent = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: songContent.length,
                          itemBuilder: (context, index) {
                            
                            return Center(
                                child: PlayListWidget(
                              name: songContent[index].data()['name'],
                              imageUrl: songContent[index].data()['imageUrl'],
                              songUrl: songContent[index].data()['songUrl'],
                              singer: songContent[index].data()['singer'],
                              id: songContent[index].data()['id'],
                              externalId: documentId,
                              internalId: songContent[index].id,
                            ));
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
