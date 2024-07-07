import 'package:flutter/material.dart';
import 'package:apotek_fe/ui/home/screens/home_screen.dart';
import 'package:apotek_fe/ui/profile/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        HomeScreen(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        ProfilePage(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ],
    );
  }
}
