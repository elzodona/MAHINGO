import 'package:flutter/material.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mahingo/services/call_api/event_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class NewEventsScreen extends StatefulWidget {
  const NewEventsScreen({super.key});

  @override
  _NewEventsScreenState createState() => _NewEventsScreenState();
}

class _NewEventsScreenState extends State<NewEventsScreen> {
  Map<DateTime, List<dynamic>> _events = {};
  int id = 2;

@override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      String userString = prefs.getString('user')!;
      Map<String, dynamic> userData = json.decode(userString);
      setState(() {
        id = userData["id"];
      });
      // print("User ID: ${id}");
      await _loadEvents(id);
    } else {
      print('Aucun utilisateur trouvé dans les préférences partagées');
    }
  }

  Future<void> _loadEvents(int id) async {
    try {
      Api2Service apiService = Api2Service();
      List<dynamic> events = await apiService.fetchEvents(id);

      Map<DateTime, List<dynamic>> eventsMap = {};
      for (var event in events) {
        DateTime eventDate = DateTime.parse(event['dateEvent']);

        DateTime eventKey =
            DateTime(eventDate.year, eventDate.month, eventDate.day);

        if (eventsMap[eventKey] == null) {
          eventsMap[eventKey] = [];
        }
        eventsMap[eventKey]!.add(event);
      }

      setState(() {
        _events = eventsMap;
      });
      print(_events);
    } catch (e) {
      print('Erreur : $e');
    }
  }

  void showInfoDialoga(
      BuildContext context, String message, String etat, VoidCallback onClose) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      customHeader: const Icon(
        Icons.info,
        color: AppColors.vert,
        size: 70,
      ),
      animType: AnimType.bottomSlide,
      title: etat,
      desc: message,
      btnOkOnPress: () {
        onClose();
      },
      btnOkColor: AppColors.vert,
    ).show();
  }

  TextEditingController animalController = 
    TextEditingController(text: 'Saisir l\'animal');
  TextEditingController titreController =
      TextEditingController(text: 'Saisir le titre');
  TextEditingController dateController =
      TextEditingController(text: '');
  TextEditingController debutController =
      TextEditingController(text: '');
  TextEditingController finController =
      TextEditingController(text: '');
  TextEditingController descriptionController =
      TextEditingController(text: 'Saisir la description');


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
                      const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Nouvel évènement",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.vert,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: screenWidth * 0.85,
                        height: screenHeight * 0.33,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gris),
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.blanc,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.gris,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildEditableDetailRow(
                                    screenWidth, 'Animal', animalController),
                            _buildEditableDetailRow(
                                screenWidth, 'Titre', titreController),
                            _buildEditableDetailRow1(
                                screenWidth, 'Date événement', dateController),
                            _buildEditableDetailRow2(
                                screenWidth, 'Heure de debut', debutController),
                            _buildEditableDetailRow2(
                                screenWidth, 'Heure de fin', finController),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Column(
                        children: [
                          Container(
                            width: screenWidth * 0.85,
                            height: screenHeight * 0.06,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.gris),
                              borderRadius: BorderRadius.circular(8.0),
                              color: AppColors.blanc,
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.gris,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    color: AppColors.noir,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: screenWidth * 0.85,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.gris),
                              borderRadius: BorderRadius.circular(8.0),
                              color: AppColors.blanc,
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.gris,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              maxLines: 5,
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0),
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Expanded(
                        child: Center(
                          child: Container(
                            width: screenWidth * 0.4,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.vert,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.gris,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () async {
                                try {
                                  String newTitre = titreController.text;
                                  String newDate = dateController.text;
                                  String newDebut = debutController.text;
                                  String newFin = finController.text;
                                  String newDescription =
                                      descriptionController.text;
                                  String newAnimal = animalController.text;

                                  Map<String, dynamic> newEventData = {
                                    'animal_id': newAnimal,
                                    'user_id': id,
                                    'titre': newTitre,
                                    'dateEvent': newDate,
                                    'heureDebut': newDebut,
                                    'heureFin': newFin,
                                    'description': newDescription,
                                  };

                                  dynamic response = await Api2Service()
                                      .createEvent(newEventData);
                                  showInfoDialoga(
                                      context,
                                      'Événement ajouté avec succès !',
                                      'Succès', () {
                                    _loadUserInfo();
                                  });
                                } catch (e) {
                                  print('Erreur lors de la création : $e');
                                  showInfoDialoga(
                                      context,
                                      'Erreur lors de la création : ${e.toString()}',
                                      'Erreur', () {
                                    _loadUserInfo();
                                  });
                                }
                              },

                              child: const Text(
                                'Ajouter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
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

  Widget _buildEditableDetailRow(
      double screenWidth, String label, TextEditingController controller) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: screenWidth * 0.25,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                '$label :',
                style: const TextStyle(
                    color: AppColors.noir, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(right: 12.0),
                    isDense: true,
                  ),
                  style: const TextStyle(color: Colors.black),
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.gris),
      ],
    );
  }

  Widget _buildEditableDetailRow1(
      double screenWidth, String label, TextEditingController controller) {
    DateTime? _selectedDate;

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
          controller.text = '${picked.toLocal()}'.split(' ')[0];
        });
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: screenWidth * 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '$label :',
                style: const TextStyle(
                    color: AppColors.noir, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  textAlign: TextAlign.right,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 14,
                    ),
                    isDense: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                      iconSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(
            color: AppColors.gris, height: 1.0),
      ],
    );
  }

  Widget _buildEditableDetailRow2(
      double screenWidth, String label, TextEditingController controller) {
    TimeOfDay? _selectedTime;

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
      );
      if (picked != null && picked != _selectedTime) {
        _selectedTime = picked;
        final now = DateTime.now();
        final selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        controller.text =
            "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}";
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: screenWidth * 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '$label :',
                style: const TextStyle(
                    color: AppColors.noir, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  textAlign: TextAlign.right,
                  onTap: () => _selectTime(context),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                    isDense: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () => _selectTime(context),
                      iconSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.gris, height: 1.0),
      ],
    );
  }

}
