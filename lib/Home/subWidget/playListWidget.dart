import 'package:beat_box/Home/subWidget/songPlayerWidget.dart';
import 'package:beat_box/provider/audioPlayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PlayListWidget extends StatelessWidget {
  final String? name;
  String? imageUrl;
  String? songUrl;
  String? singer;
  String? id;
  PlayListWidget(
      {required this.name,
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
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: id == value.getSongId
            ? BoxDecoration(border: Border.all(width: 1, color: Colors.white))
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                value.playSongByUrl(songUrl: songUrl!, songId: id!);
                songPlayerWidget(name, imageUrl, songUrl, singer, context);
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
                  onTap: () {
                    value.pauseAndResumeSong();
                  },
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: value.getIsPlayingOrNot && value.getSongId == id
                          ? Image.asset(
                              'assets/Images/icons8-audio-wave.gif',
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/Images/play.png',
                              fit: BoxFit.contain,
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
