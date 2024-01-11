import 'package:beat_box/Provider/SongInfo.dart';
import 'package:beat_box/models/songDetailsTemplate.dart';
import 'package:beat_box/provider/audioPlayer.dart';
import 'package:beat_box/provider/recentlyPlayed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PlayListWidget extends StatelessWidget {
  final String? name;
  String? imageUrl;
  String? songUrl;
  String? singer;
  String? id;
  String? externalId;
  String? internalId;
  PlayListWidget(
      {
      required this.externalId,
      required this.internalId,
      required this.name,
      required this.imageUrl,
      required this.songUrl,
      required this.singer,
      required this.id,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final songInfo = Provider.of<SongInfo>(context, listen: false);
    return Consumer<MyCustomAudioPlayer>(builder: (context, value, child) {
      if (value.getSongId == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: id == value.getSongId
            ? BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.cyan,
                  Colors.blue,
                  Color.fromARGB(255, 45, 1, 121)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                //color: Color.fromARGB(255, 2, 6, 36),
                border: Border.all(width: 1, color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(20)))
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {

                SongInfo songInfo =
                    Provider.of<SongInfo>(context, listen: false)
                        .getSongInfoInstance!;
                songInfo.imageUrl = imageUrl!;
                songInfo.songUrl = songUrl!;
                songInfo.name = name!;
                songInfo.singer = singer!;
                songInfo.id = id!;
                value.playSongByUrl(songUrl: songUrl!, songId: id!,);
                
                SongDetailsTemplate songDetailsTemplate = SongDetailsTemplate(
                id: id!,
                name: name!,
                imageUrl: imageUrl!,
                songUrl: songUrl!,
                singer: singer!);
            Provider.of<RecentlyPlayedSongAdd>(context, listen: false)
                .addSongIntoDB(songDetailsTemplate, context);
              },
              child: ListTile(
                leading: Container(
                  height: 100,
                  width: 60,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name!,
                      style: context.textTheme.displayMedium,
                    ),
                    Text(singer!,
                        style: const TextStyle(
                            fontFamily: 'MyUniqueFont',
                            fontSize: 14,
                            color: Colors.white30))
                  ],
                ),
                trailing: InkWell(
                  onTap: value.getSongId == id
                      ? () {
                          value.pauseAndResumeSong();
                        }
                      : null,
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: value.getIsPlayingOrNot && value.getSongId == id
                          ? Image.asset(
                              'assets/Images/icons8-audio-wave.gif',
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/Images/play.png',
                              fit: BoxFit.contain,
                              color: Colors.white,
                            )),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
