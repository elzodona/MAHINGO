import 'package:flutter/material.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:mahingo/routes/paths.dart';


class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  _StartingScreenState createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacementNamed(context, AppPaths.login);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.vert,
      body: Center(
        child: Image.asset(
          'assets/images/logo1.png',
          width: screenWidth,
          height: screenHeight * 0.3,
        ),
      ),
    );
  }
  
}
