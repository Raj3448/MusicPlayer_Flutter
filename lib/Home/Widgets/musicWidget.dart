import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:beat_box/Provider/SongInfo.dart';
import 'package:beat_box/provider/audioPlayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicScreen extends StatelessWidget {
  dynamic maxDuration;
  MusicScreen({Key? key}) : super(key: key);

  getMaxDuration(context) async {
    maxDuration = await Provider.of<MyCustomAudioPlayer>(context, listen: false)
        .getTotalDuration;
  }

  var data = Duration.zero;
  @override
  Widget build(BuildContext context) {
    getMaxDuration(context);
    return Consumer<MyCustomAudioPlayer>(
        builder: (context, audioPlayer, child) {
      return Consumer<SongInfo>(
        builder: (context, value, child) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                ),
                child: Image.network(
                  value.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: StreamBuilder<Duration>(
                    stream: audioPlayer.getLiveduration(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        data = snapshot.data!;
                      }
                      print('Data : $data');
                      return ProgressBar(
                        progress: !snapshot.hasData && snapshot.data == null
                            ? data
                            : snapshot.data!,
                        total: maxDuration,
                        onSeek: (duration) {
                          Provider.of<MyCustomAudioPlayer>(context,
                                  listen: false)
                              .setDuration(duration);
                          print(duration);
                        },
                        // onDragEnd: () {
                        //   Provider.of<MyCustomAudioPlayer>(context,
                        //           listen: false)
                        //       .onSongCompleted();
                        // },

                        barCapShape: BarCapShape.round,
                        thumbRadius: 7,
                        barHeight: 1.5,
                        timeLabelTextStyle: const TextStyle(
                          fontFamily: 'MyUniqueFont',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/Images/previous.png',
                        color: Colors.white,
                      ),
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    IconButton(
                      onPressed: () {
                        audioPlayer.pauseAndResumeSong();
                      },
                      icon: audioPlayer.isPlaying
                          ? Image.asset(
                              'assets/Images/pause.png',
                              color: Colors.white,
                            )
                          : Image.asset(
                              'assets/Images/play.png',
                              color: Colors.white,
                            ),
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/Images/next.png',
                        color: Colors.white,
                      ),
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
