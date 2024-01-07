import 'package:beat_box/Home/Widgets/homeWidget.dart';
import 'package:beat_box/Home/Widgets/musicLibraryWidget.dart';
import 'package:beat_box/Home/Widgets/musicWidget.dart';
import 'package:beat_box/Home/Widgets/profileWidget.dart';
import 'package:beat_box/Home/Widgets/serachWidget.dart';
import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> screenList;

  void initState() {
    super.initState();
    screenList = [
      const HomeWidget(),
      SearchScreen(),
      MusicScreen(),
      MusicLibraryWidget(),
      const ProfileWidget()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050A30),
      body: screenList[_selectedIndex],
      bottomNavigationBar: MoltenBottomNavigationBar(
        barColor: Color.fromARGB(255, 2, 6, 36),
        selectedIndex: _selectedIndex,
        borderRaduis: BorderRadius.circular(50),
        curve: Curves.bounceInOut,
        tabs: [
          MoltenTab(
              icon: Icon(Icons.home, color: Colors.grey),
              selectedColor: const Color(0xFF7C4DFF),
              unselectedColor: const Color(0xFF607D8B)),
          MoltenTab(
              icon: Icon(Icons.search_rounded, color: Colors.grey),
              selectedColor: const Color(0xFF7C4DFF),
              unselectedColor: const Color(0xFF607D8B)),
          MoltenTab(
              icon: Icon(Icons.music_note, color: Colors.grey),
              selectedColor: const Color(0xFF7C4DFF),
              unselectedColor: const Color(0xFF607D8B)),
          MoltenTab(
              icon: Icon(Icons.library_music_rounded, color: Colors.grey),
              selectedColor: const Color(0xFF7C4DFF),
              unselectedColor: const Color(0xFF607D8B)),
          MoltenTab(
              icon: Icon(Icons.person_4_rounded, color: Colors.grey),
              selectedColor: const Color(0xFF7C4DFF),
              unselectedColor: const Color(0xFF607D8B)),
        ],
        onTabChange: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
