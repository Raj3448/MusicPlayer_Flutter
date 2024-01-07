import 'package:beat_box/provider/audioPlayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Widget? songPlayerWidget(String? name, String? imageUrl, String? songUrl,
    String? singer, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ListTile(
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
        trailing: Consumer<MyCustomAudioPlayer>(
          builder: (context, value, child) => InkWell(
            onTap: () {
              value.pauseAndResumeSong();
            },
            child: SizedBox(
                height: 40,
                width: 40,
                child: value.getIsPlayingOrNot
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
  );
}
