import 'package:beat_box/Home/SubScreens/playListScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalCardMedU extends StatelessWidget {
  dynamic singleSongInfo;

  HorizontalCardMedU({
    Key? key,
    required this.singleSongInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size mediaQData = MediaQuery.of(context).size;
    print('Made For U (Single Song Info : $singleSongInfo)');
    //For accessing the documents id
    print('Made For U (Single Song Info document id : ${singleSongInfo.id})');
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlayListScreen(playListInfo: singleSongInfo,documentId: singleSongInfo.id,)));
              },
              
              child: Container(
                height: mediaQData.height * 0.17,
                width: mediaQData.width * 0.4,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 1, 10, 24),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Stack(
                  children: [
                    Image.network(
                      singleSongInfo.data()['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                    Positioned.directional(
                      top: 120,
                      start: 20,
                      textDirection: TextDirection.ltr,
                      child: Text('${singleSongInfo.data()['title']}',
                          style: context.textTheme.displayMedium),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
