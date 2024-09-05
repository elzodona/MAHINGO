import 'package:flutter/material.dart';
import 'package:mahingo/screens/accueil_screen.dart';
import 'package:mahingo/screens/animals_screen.dart';
import 'package:mahingo/screens/location_screen.dart';
import 'package:mahingo/screens/events_screen.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _page = 0;

  final List<Widget> _pages = [
    AccueilScreen(),
    const AnimalsScreen(),
    const LocationScreen(),
    const EventsScreen(),
    // const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomAppBar(),
      body: _pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppColors.vert,
        color: AppColors.vert,
        animationDuration: const Duration(milliseconds: 300),
        items: <Widget>[
          const Icon(Icons.home, size: 32, color: AppColors.blanc),
          const Icon(Icons.pets, size: 32, color: AppColors.blanc),
          Image.asset('assets/images/location.png', width: 32, height: 32),
          const Icon(Icons.event, size: 32, color: AppColors.blanc),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}

