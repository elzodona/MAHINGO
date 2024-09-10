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

  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    AccueilScreen(),
    const AnimalsScreen(),
    const LocationScreen(),
    const EventsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
        physics: const BouncingScrollPhysics(),
      ),
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
