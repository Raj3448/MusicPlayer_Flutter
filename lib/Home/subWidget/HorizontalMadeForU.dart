import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalCardMedU extends StatelessWidget {
  Map<String, dynamic> singleSongInfo;
  HorizontalCardMedU({
    Key? key,
    required this.singleSongInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size mediaQData = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
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
              child: Stack(
                children: [
                  Image.network(
                    singleSongInfo['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                  Positioned.directional(
                    top: 120,
                    start: 20,
                    textDirection: TextDirection.ltr,
                    child: Text('${singleSongInfo['title']}',
                        style: context.textTheme.displayMedium),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
