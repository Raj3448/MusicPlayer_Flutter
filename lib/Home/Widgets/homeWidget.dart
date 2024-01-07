import 'package:beat_box/AuthScreen/authscreen.dart';
import 'package:beat_box/Blocs/Auth/AuthBloc/autth_bloc.dart';
import 'package:beat_box/Home/subWidget/HorizontalCardView.dart';
import 'package:beat_box/Home/subWidget/HorizontalMadeForU.dart';
import 'package:beat_box/Home/subWidget/songPlayerWidget.dart';
import 'package:beat_box/Provider/SongInfo.dart';
import 'package:beat_box/provider/audioPlayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final AuthBloc authBloc = Get.put(AuthBloc());

  String? imageURL = null;

  final _isLoading = true;

  List<int> nums = [1, 2, 3, 4, 5, 6, 7, 8];

  @override
  void initState() {
    super.initState();
  }

  SongInfo? songInfo = SongInfo(
      id: "  ",
      name: "Deva Shree Ganesha",
      singer: "Ajay Gogavale",
      imageUrl:
          "https://a10.gaanacdn.com/images/albums/57/64957/crop_480x480_64957.jpg",
      songUrl:
          "https://pagalfree.com/musics/128-Deva%20Shree%20Ganesha%20-%20Agneepath%20128%20Kbps.mp3");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AuthScreen()),
                (route) => false);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final Future<DocumentSnapshot<Map<String, dynamic>>> userData;
            Map<String, dynamic>? userDataMap;

            Size mediaQueryData = MediaQuery.of(context).size;
            if (imageURL == null && state is AuthSuccess) {
              userData = FirebaseFirestore.instance
                  .collection('usersDoc')
                  .doc(state.UID)
                  .get();
              print('UserData : $userData');
              Future<DocumentSnapshot<Map<String, dynamic>>> snapshot =
                  userData.then((value) {
                userDataMap = value.data();
                print('UserName :: ${userDataMap?['userName']} ');
                print('Email :: ${userDataMap?['email']} ');
                print('ImageURL :: ${userDataMap?['imageURL']} ');
                imageURL = userDataMap?['imageURL'];
                setState(() {});
                return value;
              });
            }
            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 2, 6, 36),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: mediaQueryData.height * 0.08,
                            width: mediaQueryData.width * 0.5,
                            child: Image.asset('assets/Images/BeatBox.png'),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                                right: mediaQueryData.width * 0.07,
                                top: mediaQueryData.height * 0.02),
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                    color: Colors.deepPurple,
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CircleAvatar(
                                    backgroundImage: imageURL == null
                                        ? null
                                        : NetworkImage(imageURL!),
                                    radius: 20,
                                    backgroundColor:
                                        imageURL == null ? Colors.black : null,
                                  ),
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Melodic Deals',
                            style: context.textTheme.displayLarge,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('musicBanner')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Image.asset(
                                        'assets/Images/Screenshot_1703762766.png');
                                  }
                                  final response = snapshot.data!.docs;
                                  return CarouselSlider(
                                    children: response.map((e) {
                                      final Map<String, dynamic> data =
                                          e.data();
                                      return Builder(
                                          builder: (BuildContext context) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 10),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 1, 10, 24),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Image.network(
                                            data['imageUrl'],
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      });
                                    }).toList(),
                                    clipBehavior: Clip.antiAlias,
                                    autoSliderTransitionTime:
                                        const Duration(seconds: 1),
                                    autoSliderDelay: const Duration(seconds: 5),
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    unlimitedMode: true,
                                  );
                                }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'New & Trending Songs',
                            style: context.textTheme.displayLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('new_trending_songs')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Image.asset('assets/Images/-.png');
                                  }
                                  final List songsList = snapshot.data!.docs;
                                  return ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: songsList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            final singleSong =
                                                songsList[index].data();
                                            songInfo = Provider.of<SongInfo>(
                                                    context,
                                                    listen: false)
                                                .getSongInfoInstance;
                                            songInfo!.imageUrl =
                                                singleSong['imageUrl'];
                                            songInfo!.songUrl =
                                                singleSong['songUrl'];
                                            songInfo!.name = singleSong['name'];
                                            songInfo!.singer =
                                                singleSong['singer'];
                                            songInfo!.id = singleSong['id'];
                                            print(songInfo);
                                            Provider.of<MyCustomAudioPlayer>(
                                                    context,
                                                    listen: false)
                                                .playSongByUrl(
                                                    songUrl:
                                                        singleSong['songUrl'],
                                                    songId: singleSong['id']);
                                          },
                                          child: HorizontalCardView(
                                              singleSongInfo:
                                                  songsList[index].data()),
                                        );
                                      });
                                }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Made For You',
                            style: context.textTheme.displayLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('madeForU')
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
                                        // var songList =
                                        //                 songContent[index].collection('songList').snapshots();
                                        return HorizontalCardMedU(
                                            singleSongInfo: songContent[index]);
                                      });
                                }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthLogOutRequested());
                              },
                              child: const Text('Sign Out')),
                        )
                      ],
                    ),
                  ),
                ),
                Consumer<SongInfo>(
                  builder: (context, value, child) => Container(
                    height: 80,
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 2, 31, 249),
                              Color.fromARGB(255, 140, 150, 240)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.black),
                    child: songPlayerWidget(value.name, value.imageUrl,
                        value.songUrl, value.singer, context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
