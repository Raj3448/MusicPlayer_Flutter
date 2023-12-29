import 'package:beat_box/AuthScreen/authscreen.dart';
import 'package:beat_box/Blocs/Auth/AuthBloc/autth_bloc.dart';
import 'package:beat_box/Home/subWidget/HorizontalCardView.dart';
import 'package:beat_box/Home/subWidget/HorizontalMadeForU.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget._empty({Key? key}) : super(key: key);

  static HomeWidget singleInstance = HomeWidget._empty();

  factory HomeWidget() {
    return singleInstance;
  }

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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            height: MediaQuery.of(context).size.height * 0.08,
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
                                final Map<String, dynamic> data = e.data();
                                return Builder(builder: (BuildContext context) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 10),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 1, 10, 24),
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
                              scrollPhysics: const BouncingScrollPhysics(),
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
                                itemBuilder: (context, index) =>
                                    HorizontalCardView(
                                        singleSongInfo:
                                            songsList[index].data()));
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
                              return Image.asset('assets/Images/madeForU.png');
                            }
                            final List songContent = snapshot.data!.docs;

                            return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: songContent.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    HorizontalCardMedU(
                                        singleSongInfo:
                                            songContent[index].data()));
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthLogOutRequested());
                        },
                        child: const Text('Sign Out')),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
