// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:beat_box/cubit/song_play_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HorizontalCardView extends StatelessWidget {
  Map<String, dynamic> singleSongInfo;
  HorizontalCardView({
    Key? key,
    required this.singleSongInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size mediaQData = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    context.read<SongPlayCubit>().playSongByURl(
                          songUrl: singleSongInfo['songUrl'],
                          songObject: singleSongInfo,
                        );
                  },
                  child: Container(
                    height: mediaQData.height * 0.17,
                    width: mediaQData.width * 0.4,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 1, 10, 24),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Image.network(
                      singleSongInfo['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned.directional(
                top: 100,
                start: 30,
                textDirection: TextDirection.ltr,
                child: Container(
                  height: 40,
                  width: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Align(
                    alignment: Alignment.center,
                    
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(onPressed: () {
                        context.read<SongPlayCubit>().pauseAndResumeAudio();
                      }, icon: BlocBuilder<SongPlayCubit, SongPlayState>(
                        builder: (context, state) {
                          if (state is SongPlaySuccess) {
                            if(state.songId == singleSongInfo['id']){
                            return Image.network(
                                'https://i.gifer.com/Nt6v.gif');
                            }
                          }
                          return const Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.white,
                          );
                        },
                      )),
                    ),
                  ),
                ),
              )
            ],
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
    );
  }
}
