import 'package:flutter/material.dart';
import 'package:mahingo/screens/login_screen.dart';
import 'package:mahingo/screens/notifications_screen.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      String userString = prefs.getString('user')!;
      Map<String, dynamic> userData = json.decode(userString);
      setState(() {
        user = userData;
      });
      print(user);
    } else {
      print('Aucun utilisateur trouvé dans les préférences partagées');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 12,
      backgroundColor: AppColors.blanc,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.vert,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/me.jpeg'),
                radius: 16,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                user != null
                    ? 'Bonjour ${user!['first_name']}!'
                    : 'Bonjour Elhadji Malick!',
                style: const TextStyle(
                  color: AppColors.noir,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),

          // Icône à droite
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
            child: const Icon(
              Icons.notifications,
              color: AppColors.vert,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
