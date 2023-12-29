// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
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
          Padding(
            padding: const EdgeInsets.all(10.0),
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
