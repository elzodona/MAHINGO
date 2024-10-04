import 'package:flutter/material.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class NewEventsScreen extends StatefulWidget {
  const NewEventsScreen({super.key});

  @override
  _NewEventsScreenState createState() => _NewEventsScreenState();
}

class _NewEventsScreenState extends State<NewEventsScreen> {

  void showInfoDialog(BuildContext context, String message, String etat) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            customHeader: const Icon(
              Icons.info,
              color: AppColors.vert,
              size: 70,
            ),
            // dialogBackgroundColor: Colors.green,
            animType: AnimType.bottomSlide,
            title: etat,
            desc: message,
            btnOkOnPress: () {},
            btnOkColor: AppColors.vert)
        .show();
  }


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
                      Navigator.pop(context, true);
                    },
                  ),
                  const Spacer(),
                  const Center(
                    child: Text(
                      'Ajouter un évènement',
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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight * 0.9,
                  width: screenWidth,
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
