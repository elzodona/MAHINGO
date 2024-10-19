import 'package:flutter/material.dart';
import 'package:mahingo/screens/accueil_screen.dart';
import 'package:mahingo/screens/animals_screen.dart';
import 'package:mahingo/screens/events_screen.dart';
import 'package:mahingo/screens/location_screen.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    AccueilScreen(),
    const AnimalsScreen(),
    LocationScreen(),
    const EventsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: _pages[_selectedIndex],
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
        onTap: _onItemTapped,
        index: _selectedIndex,
      ),
    );
  }
}
