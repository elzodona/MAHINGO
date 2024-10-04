import 'dart:ffi';
import 'package:mahingo/screens/newEvent_screen.dart';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahingo/screens/newAnimal_screen.dart';
import 'package:mahingo/screens/update_animal_screen.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mahingo/services/call_api/animal_service.dart';

void showInfoDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
    customHeader: const Icon(
      Icons.info,
      color: AppColors.vert,
      size: 70,
    ),
    animType: AnimType.bottomSlide,
    title: 'Succès',
    desc: 'Suppression effectuée avec succès',
    btnOkOnPress: () {
      Navigator.of(context).pop();
    },
    btnOkColor: AppColors.vert,
  ).show();
}

void showSuccessDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    customHeader: const Icon(
      Icons.check_circle,
      color: AppColors.vert,
      size: 70,
    ),
    animType: AnimType.bottomSlide,
    title: 'Succès',
    desc: 'Suppression effectuée avec succès',
    btnOkOnPress: () {
      Navigator.of(context).pop();
    },
    btnOkColor: AppColors.vert,
  ).show();
}

void showConfirmationDialog(BuildContext context, int id) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.scale,
    title: 'Confirmation',
    desc: 'Êtes-vous sûr de vouloir supprimer cet animal ?',
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      try {
        await ApiService().deleteAnimal(id);
        showSuccessDialog(context);
      } catch (e) {
        print('Erreur lors de la suppression : $e');
      }
    },
  ).show();
}

void showErrorDialog(BuildContext context, String title, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.bottomSlide,
    title: title,
    desc: message,
    btnOkOnPress: () {},
  ).show();
}

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {

  final LayerLink layerLink = LayerLink();
  final GlobalKey _nameAnimalKey = GlobalKey();
  FocusNode _focusNode = FocusNode();
  final TextEditingController _nameEvent = TextEditingController();


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
              height: screenHeight * 0.15,
              color: AppColors.vert,
              child: const Center(
                child: Text(
                  'Agenda',
                  style: TextStyle(
                    color: AppColors.blanc,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight * 0.9,
                  decoration: const BoxDecoration(
                    color: AppColors.blanc,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(23),
                      topLeft: Radius.circular(23),
                    ),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        width: screenWidth * 0.87,
                        child: Row(
                          children: [
                          Expanded(
                            child: Container(
                              // height: screenHeight * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.gris,
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  CompositedTransformTarget(
                                      link: layerLink,
                                      child: TextField(
                                        key: _nameAnimalKey,
                                        focusNode: _focusNode,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        controller: _nameEvent,
                                        decoration: InputDecoration(
                                          hintText: 'Search...',
                                          hintStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 200, 199, 197)),
                                          prefixIcon: const Icon(Icons.search,
                                              color: AppColors.gris),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 15),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: AppColors.gris,
                                                width: 1),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: AppColors.gris,
                                                width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: AppColors.vert,
                                                width: 2),
                                          ),
                                          fillColor: AppColors.blanc,
                                          filled: true,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            
                                          });
                                        },
                                      )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewEventsScreen()),
                                );
                            },
                            child: Container(
                              height: screenHeight * 0.043,
                              width: screenWidth * 0.11,
                              decoration: BoxDecoration(
                                color: AppColors.vert,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.gris,
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                color: AppColors.blanc,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.03),

                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              height: screenHeight * 0.4,
                              width: screenWidth * 0.8,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 203, 222, 201),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.5),
                                  topRight: Radius.circular(12.5),
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            const Padding(
                              padding: EdgeInsets.only(left: 18),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Evènement à venir',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.noir,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.007),

                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              height: screenHeight * 0.085,
                              width: screenWidth * 0.8,
                              decoration: BoxDecoration(
                                // color: const Color(0xFFEBF4EB),
                                color: AppColors.blanc,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.gris,
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    // padding: const EdgeInsets.all(8.0),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.blanc,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Image.asset(
                                      'assets/images/vaccination.png',
                                      color: AppColors.vert,
                                      height: 16,
                                      width: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Vaccination',
                                        style: TextStyle(
                                          color: AppColors.noir,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '11.06.2023 | 13:30',
                                        style: TextStyle(
                                          color: Color(0xFF808B9A),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.008),
                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              height: screenHeight * 0.085,
                              width: screenWidth * 0.8,
                              decoration: BoxDecoration(
                                color: AppColors.blanc,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.gris,
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    // padding: const EdgeInsets.all(8.0),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.blanc,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Image.asset(
                                      'assets/images/visite_medicale.png',
                                      color: AppColors.vert,
                                      height: 16,
                                      width: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Visite médicale',
                                        style: TextStyle(
                                          color: AppColors.noir,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '11.06.2023 | 13:30',
                                        style: TextStyle(
                                          color: Color(0xFF808B9A),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              height: screenHeight * 0.085,
                              width: screenWidth * 0.8,
                              decoration: BoxDecoration(
                                color: AppColors.blanc,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.gris,
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    // padding: const EdgeInsets.all(8.0),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.blanc,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Image.asset(
                                      'assets/images/traitement.png',
                                      color: AppColors.vert,
                                      height: 16,
                                      width: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Traitement médical',
                                        style: TextStyle(
                                          color: AppColors.noir,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '11.06.2023 | 13:30',
                                        style: TextStyle(
                                          color: Color(0xFF808B9A),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                    
                          ],
                        ),
                      )

                      ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
