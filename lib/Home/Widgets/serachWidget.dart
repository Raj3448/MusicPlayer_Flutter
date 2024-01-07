import 'package:beat_box/provider/searchSong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? songName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          TextField(
            onSubmitted: (value) {
              setState(() {
                songName = value.trim();
                print(songName);
              });
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                hintText: 'Search',
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                if (songName != null) {
                  Provider.of<SearchSong>(context, listen: false)
                      .searchSong(songName!);
                }
              },
              child: const Text('Search'))
        ],
      ),
    );
  }
}
