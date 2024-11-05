import 'package:flutter/material.dart';
import 'package:instaclone/pages/feed.dart';
import 'package:instaclone/pages/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selected = 0;

  final List _screens = [
    const Feed(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('instaclone'),
      ),
      body: _screens[_selected],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selected,
          onTap: (index) {
            setState(() {
              _selected = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.feed),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login_rounded),
              label: 'profile',
            ),
          ]),
    );
  }
}
