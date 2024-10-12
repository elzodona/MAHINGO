import 'package:flutter/material.dart';
import 'package:mahingo/screens/accueil_screen.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mahingo/routes/paths.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedOption1 = 'un';
  String selectedOption2 = 'one';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.vert,
              AppColors.vert,
            ],
            stops: [0.3, 0.3],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30),
              height: screenHeight * 0.14,
              color: AppColors.vert,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.blanc),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AccueilScreen()),
                      );
                    },
                  ),
                  const Spacer(),
                  const Center(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: AppColors.blanc,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            
            Container(
              height: screenHeight * 0.86,
              width: screenWidth,
              decoration: const BoxDecoration(
                color: AppColors.blanc,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(23),
                  topLeft: Radius.circular(23),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.055,
                    width: screenWidth,
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      // color: AppColors.vert,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(23),
                        topLeft: Radius.circular(23),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: screenHeight * 0.03,
                          width: screenWidth * 0.42,
                          // padding: EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.vertClair,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedOption1 = 'un';
                                    });
                                  },
                                  child :Container(
                                  height: screenHeight * 0.03,
                                  width: screenWidth * 0.135,
                                  // padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: selectedOption1 == 'un'
                                      ? AppColors.vert
                                      : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/icon_good_health.png',
                                      color: selectedOption1 == 'un'
                                          ? AppColors.blanc
                                          : AppColors.vert,
                                      height: 20,
                                      width: 20,
                                    ),
                                  )
                                ),
                                ),
                                
                                Spacer(),

                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedOption1 = 'dos';
                                    });
                                  },
                                  child: Container(
                                    height: screenHeight * 0.03,
                                    width: screenWidth * 0.135,
                                    // padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: selectedOption1 == 'dos'
                                              ? AppColors.vert
                                              : Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/calendar.png',
                                        color: selectedOption1 == 'dos'
                                            ? AppColors.blanc
                                            : AppColors.vert,
                                        height: 18,
                                        width: 18,
                                      ),
                                    )
                                  ),
                                ),
                                  
                                Spacer(),

                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedOption1 = 'tres';
                                    });
                                  },
                                  child: Container(
                                  height: screenHeight * 0.03,
                                  width: screenWidth * 0.135,
                                  // padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: selectedOption1 == 'tres'
                                              ? AppColors.vert
                                              : Colors.transparent,
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/loca.png',
                                      color: selectedOption1 == 'tres'
                                          ? AppColors.blanc
                                          : AppColors.vert,
                                      height: 18,
                                      width: 18,
                                    ),
                                  )
                                ),
                                )
                              ],
                            ),
                          )
                        ),

                        Spacer(),

                        Container(
                          height: screenHeight * 0.03,
                          width: screenWidth * 0.425,
                          // padding: EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.vertClair,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedOption2 = 'one';
                                    });
                                  },
                                  child: Container(
                                  height: screenHeight * 0.03,
                                  width: screenWidth * 0.21,
                                  // padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: selectedOption2 == 'one'
                                              ? AppColors.vert
                                              : Colors.transparent,
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Toutes",
                                      style: TextStyle(
                                        color: selectedOption2 == 'one'
                                                    ? AppColors.blanc
                                                    : AppColors.noir,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),  
                                  )
                                ),
                                ),

                                Spacer(),

                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedOption2 = 'two';
                                    });
                                  },
                                  child: Container(
                                    height: screenHeight * 0.03,
                                    width: screenWidth * 0.21,
                                    // padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: selectedOption2 == 'two'
                                                ? AppColors.vert
                                                : Colors.transparent,
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Non lues",
                                        style: TextStyle(
                                          color: selectedOption2 == 'two'
                                                      ? AppColors.blanc
                                                      : AppColors.noir,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ),
                                )
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  Expanded(
                    child: Container(
                      // height: screenHeight * 0.63,
                      width: screenWidth,
                      decoration: const BoxDecoration(
                        // color: AppColors.vert,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(23),
                          topLeft: Radius.circular(23),
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
