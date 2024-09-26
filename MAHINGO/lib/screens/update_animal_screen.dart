import 'package:flutter/material.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mahingo/services/call_api/animal_service.dart';

class UpdateAnimalScreen extends StatefulWidget {
  final Map<String, dynamic> animal;

  const UpdateAnimalScreen({required this.animal, super.key});

  @override
  _UpdateAnimalScreenState createState() => _UpdateAnimalScreenState();
}

class _UpdateAnimalScreenState extends State<UpdateAnimalScreen> {
  String? _selectedGender = 'Masculin';
  String? _selectedCategory;
  int id = 2;

  late TextEditingController _textController;
  late TextEditingController _nomController;
  late TextEditingController _tailleController;
  late TextEditingController _poidsController;
  late TextEditingController _genreController;
  late TextEditingController _raceController;
  late TextEditingController _birthController;

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
  void initState() {
    super.initState();

    _textController = TextEditingController(text: widget.animal['categorie']);
    _nomController = TextEditingController(text: widget.animal['name']);
    _birthController = TextEditingController(text: widget.animal['date_birth']);
    _tailleController =
        TextEditingController(text: widget.animal['taille'].toString());
    _poidsController =
        TextEditingController(text: widget.animal['poids'].toString());
    _raceController = TextEditingController(text: widget.animal['race']);
    _genreController = TextEditingController(text: 'Masculin');

    if (widget.animal['sexe'] == 'Male') {
      _selectedGender = 'Masculin';
    } else if (widget.animal['sexe'] == 'Female') {
      _selectedGender = 'Féminin';
    }

    // print(widget.animal['categorie']);
    _selectedCategory = widget.animal['categorie'];
    id = widget.animal['id'];

  }

  DateTime? _selectedDate;

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _showImagePickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? pickedImage =
                    await _picker.pickImage(source: ImageSource.camera);
                if (pickedImage != null) {
                  setState(() {
                    _selectedImage = pickedImage;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir depuis la galerie'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? pickedImage =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    _selectedImage = pickedImage;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

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
        _birthController.text = '${picked.toLocal()}'.split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _nomController.dispose();
    _tailleController.dispose();
    _poidsController.dispose();
    _genreController.dispose();
    _raceController.dispose();
    _birthController.dispose();
    super.dispose();
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
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  Center(
                    child: Text(
                      'Mettre à jour ${widget.animal['name']}',
                      style: const TextStyle(
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
                      SizedBox(
                        height: screenHeight * 0.17,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: AppColors.vertClair,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: _selectedImage != null
                                      ? FileImage(File(_selectedImage!.path))
                                      : const AssetImage(
                                              'assets/images/me.jpeg')
                                          as ImageProvider,
                                  radius: 50,
                                ),
                                Positioned(
                                  bottom: -3,
                                  child: GestureDetector(
                                    onTap: () =>
                                        _showImagePickerOptions(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.vertClair,
                                        border: Border.all(
                                          color: AppColors.vert,
                                          width: 2,
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/images/birth.png',
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Container(
                        height: screenHeight * 0.36,
                        decoration: const BoxDecoration(
                            // color: AppColors.noir
                            ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              height: screenHeight * 0.05,
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.55,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: const Text(
                                          'Categorie',
                                          style: TextStyle(
                                              color: AppColors.noir,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: _selectedCategory,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedCategory = newValue!;
                                                _textController.text = newValue;
                                              });
                                            },
                                            items: <String>['Mouton', 'Vache']
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(right: 12.0),
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.003),
                                  Container(
                                    height: 1.0,
                                    color: AppColors.gris,
                                    width: screenWidth * 0.75,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Container(
                              padding: const EdgeInsets.all(5),
                              height: screenHeight * 0.25,
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
                              child: Column(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.25,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Nom',
                                                style: TextStyle(
                                                    color: AppColors.noir,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: TextField(
                                                  controller: _nomController,
                                                  textAlign: TextAlign.right,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.25,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Taille',
                                                style: TextStyle(
                                                    color: AppColors.noir,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: TextField(
                                                  controller: _tailleController,
                                                  textAlign: TextAlign.right,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.25,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Poids',
                                                style: TextStyle(
                                                    color: AppColors.noir,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: TextField(
                                                  controller: _poidsController,
                                                  textAlign: TextAlign.right,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.5,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Genre',
                                                style: TextStyle(
                                                    color: AppColors.noir,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  value: _selectedGender,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _selectedGender =
                                                          newValue!;
                                                      _genreController.text =
                                                          newValue;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Masculin',
                                                    'Féminin'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.25,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Race',
                                                style: TextStyle(
                                                    color: AppColors.noir,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: TextField(
                                                  controller: _raceController,
                                                  textAlign: TextAlign.right,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: screenHeight * 0.005),
                      Container(
                        height: screenHeight * 0.12,
                        width: screenWidth * 0.85,
                        decoration: const BoxDecoration(
                            // color: AppColors.vert
                            ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Dates importantes',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: screenWidth * 0.85,
                              height: screenHeight * 0.07,
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
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/birth.png',
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Anniversaire',
                                          style: TextStyle(
                                            color: AppColors.noir,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: TextField(
                                        controller: _birthController,
                                        readOnly: true,
                                        textAlign: TextAlign.right,
                                        onTap: () => _selectDate(context),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          isDense: true,
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.calendar_today),
                                            onPressed: () =>
                                                _selectDate(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // SizedBox(height: screenHeight * 0.01),
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
                                  int categorieId;
                                  if (_selectedCategory == 'Mouton') {
                                    categorieId = 1;
                                  } else if (_selectedCategory == 'Vache') {
                                    categorieId = 2;
                                  } else {
                                    throw Exception('Catégorie invalide');
                                  }

                                  String genre;
                                  if (_selectedGender == 'Masculin') {
                                    genre = "Male";
                                  } else if (_selectedGender == 'Féminin') {
                                    genre = "Female";
                                  } else {
                                    throw Exception('Genre invalide');
                                  }

                                  Map<String, dynamic> newAnimalData = {
                                    'name': _nomController.text,
                                    'date_birth': _birthController.text,
                                    'sexe': genre,
                                    'race': _raceController.text,
                                    'taille': _tailleController.text,
                                    'poids': _poidsController.text,
                                    'categorie_id': categorieId,
                                    'user_id': 2,
                                  };

                                  // print(newAnimalData);
                                  dynamic response = await ApiService()
                                      .updateAnimal(id, newAnimalData);
                                  print('$response');

                                  showInfoDialog(context, response['message'], 'Succès');
                                } catch (e) {
                                  print('Erreur : $e');
                                  showInfoDialog(
                                      context, e.toString(), 'Erreur');

                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //         content: Text(
                                  //             'Erreur lors de l\'ajout de l\'animal : $e')));
                                }
                              },
                              child: const Text(
                                'Modifier',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
