// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:beat_box/Provider/SongInfo.dart';
import 'package:beat_box/models/songDetailsTemplate.dart';
import 'package:beat_box/provider/audioPlayer.dart';
import 'package:beat_box/provider/recentlyPlayed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HorizontalCardView extends StatelessWidget {
  Map<String, dynamic> singleSongInfo;
 
  HorizontalCardView(
      {Key? key,
      required this.singleSongInfo,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size mediaQData = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Consumer<SongInfo>(
        builder: (context, value, child) => GestureDetector(
          onTap: () {
            SongInfo songInfo = Provider.of<SongInfo>(context, listen: false)
                .getSongInfoInstance!;
            songInfo.imageUrl = singleSongInfo['imageUrl'];
            songInfo.songUrl = singleSongInfo['songUrl'];
            songInfo.name = singleSongInfo['name'];
            songInfo.singer = singleSongInfo['singer'];
            songInfo.id = singleSongInfo['id'];
            print(songInfo);
            Provider.of<MyCustomAudioPlayer>(context, listen: false)
                .playSongByUrl(
                    songUrl: singleSongInfo['songUrl'],
                    songId: singleSongInfo['id'],
                    );
            SongDetailsTemplate songDetailsTemplate = SongDetailsTemplate(
                id: singleSongInfo['id'],
                name: singleSongInfo['name'],
                imageUrl: singleSongInfo['imageUrl'],
                songUrl: singleSongInfo['songUrl'],
                singer: singleSongInfo['singer']);
            Provider.of<RecentlyPlayedSongAdd>(context, listen: false)
                .addSongIntoDB(songDetailsTemplate, context);
          },
          child: Container(
            decoration: value.id == singleSongInfo['id']
                ? BoxDecoration(
                    border: Border.all(color: Colors.white38, width: 0.5),
                    borderRadius: BorderRadius.circular(20))
                : null,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: mediaQData.height * 0.17,
                    width: mediaQData.width * 0.4,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 1, 10, 24),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Image.network(
                      singleSongInfo['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: mediaQData.width * 0.32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        singleSongInfo['name'],
                        style: context.textTheme.displayMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(singleSongInfo['singer'],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontFamily: 'MyUniqueFont',
                              color: Color.fromARGB(255, 96, 96, 96),
                              fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
