import 'package:beat_box/Blocs/Auth/AuthBloc/autth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String? imageURL;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<AuthBloc, AuthState>(
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
            return Container(
              height: mediaQueryData.height * 0.3,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink,
                      Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: mediaQueryData.height * 0.2,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 230, 84, 133),
                                  Colors.cyan
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            clipBehavior: Clip.antiAlias,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: imageURL != null
                                ? Image.network(imageURL!)
                                : null,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '0',
                                style: context.textTheme.displayMedium,
                              ),
                              Text(
                                'Following',
                                style: context.textTheme.displayMedium,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '0',
                                style: context.textTheme.displayMedium,
                              ),
                              Text(
                                'Followers',
                                style: context.textTheme.displayMedium,
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
