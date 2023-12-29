import 'package:flutter/material.dart';

class MusicLibraryWidget extends StatelessWidget {


MusicLibraryWidget._empty({ Key? key }) : super(key: key);

static MusicLibraryWidget singleInstance = MusicLibraryWidget._empty();

  factory MusicLibraryWidget() {
    return singleInstance;
  }

  @override
  Widget build(BuildContext context){
    return Container();
  }
}