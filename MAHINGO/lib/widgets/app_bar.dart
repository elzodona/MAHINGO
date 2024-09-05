import 'package:flutter/material.dart';
import 'package:mahingo/screens/login_screen.dart';
import 'package:mahingo/utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

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

          const Expanded(
            child: Center(
              child: Text(
                'Bonjour Elhadji Malick!',
                style: TextStyle(
                  color: AppColors.noir, 
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'
                ),
              ),
            ),
          ),

          // Icône à droite
          GestureDetector(
            onTap: () {

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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
