import 'dart:ffi';
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

void showErrorDialog(BuildContext context, String title, String message) 
{
  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.bottomSlide,
    title: title,
    desc: message,
    btnOkOnPress: () {},
  ).show();
}


class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  _AnimalsScreenState createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  List<dynamic> animaux = [];

  int _selectedFilterIndex = 0;
  int _selectedCountIndex = 0;
  String couleur = 'couleur';
  String _searchQuery = '';
  bool display = false;

  final GlobalKey _nameAnimalKey = GlobalKey();

  // late FocusNode _focusNode;
  FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;

  final TextEditingController _nameAnimal = TextEditingController();

  // final List<Map<String, dynamic>> animaux = [
  //   {
  //     'id': 1,
  //     'libelle': "Mouton",
  //     'animaux': [
  //       {
  //         'id': 1,
  //         'nom': "MacGyver",
  //         'sexe': "Male",
  //         'dateNaiss': "28/03/2020",
  //         'photo': "image.jpeg",
  //         'race': "Ladoum",
  //         'poids': "150kg",
  //         'taille': "30Cm",
  //         'idCategorie': 1,
  //         'idCollier': 1
  //       },
  //       {
  //         'id': 2,
  //         'nom': "Bozer",
  //         'sexe': "Male",
  //         'dateNaiss': "28/03/2020",
  //         'photo': "image.jpeg",
  //         'race': "Ladoum",
  //         'poids': "130kg",
  //         'taille': "35cm",
  //         'idCategorie': 1,
  //         'idCollier': 2
  //       },
  //       {
  //         'id': 6,
  //         'nom': "Diallo",
  //         'sexe': "Male",
  //         'dateNaiss': "28/03/2020",
  //         'photo': "image.jpeg",
  //         'race': "Ladoum",
  //         'poids': "130kg",
  //         'taille': "35cm",
  //         'idCategorie': 1,
  //         'idCollier': 6
  //       },
  //       {
  //         'id': 7,
  //         'nom': "Douks",
  //         'sexe': "Male",
  //         'dateNaiss': "28/03/2020",
  //         'photo': "image.jpeg",
  //         'race': "Ladoum",
  //         'poids': "130kg",
  //         'taille': "35cm",
  //         'idCategorie': 1,
  //         'idCollier': 7
  //       }
  //     ]
  //   },
  //   {
  //     'id': 2,
  //     'libelle': "Vache",
  //     'animaux': [
  //       // {
  //       //   'id': 3,
  //       //   'nom': "Maty",
  //       //   'sexe': "Femelle",
  //       //   'dateNaiss': "28/03/2020",
  //       //   'photo': "image.jpeg",
  //       //   'race': "race 1",
  //       //   'poids': "150kg",
  //       //   'taille': "30m",
  //       //   'idCategorie': 2,
  //       //   'idCollier': 3
  //       // },
  //       // {
  //       //   'id': 4,
  //       //   'nom': "Riley",
  //       //   'sexe': "Femelle",
  //       //   'dateNaiss': "28/03/2020",
  //       //   'photo': "image.jpeg",
  //       //   'race': "race 2",
  //       //   'poids': "130kg",
  //       //   'taille': "33m",
  //       //   'idCategorie': 2,
  //       //   'idCollier': 4
  //       // },
  //       {
  //         'id': 5,
  //         'nom': "Jack",
  //         'sexe': "Male",
  //         'dateNaiss': "28/03/2020",
  //         'photo': "image.jpeg",
  //         'race': "race 3",
  //         'poids': "110kg",
  //         'taille': "30m",
  //         'idCategorie': 2,
  //         'idCollier': 5
  //       }
  //     ]
  //   },
  // ];

  final List<Map<String, dynamic>> colliers = [
    {
      'id': 1,
      'identifier': 'M001',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'normal'
    },
    {
      'id': 2,
      'identifier': 'M002',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'sensible'
    },
    {
      'id': 12,
      'identifier': 'V001',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'sensible'
    },
    {
      'id': 4,
      'identifier': 'V002',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'normal'
    },
    {
      'id': 4,
      'identifier': 'V003',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'normal'
    },
    {
      'id': 4,
      'identifier': 'V004',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'anormal'
    },
    {
      'id': 4,
      'identifier': 'M004',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'sensible'
    },
    {
      'id': 4,
      'identifier': 'M003',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'normal'
    },
    {
      'id': 4,
      'identifier': 'M005',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'normal'
    },
    {
      'id': 4,
      'identifier': 'M006',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'normal'
    },
    {
      'id': 4,
      'identifier': 'V005',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "",
        'longitude': "",
      },
      'etat': 'normal'
    },
  ];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // animals = ApiService().fetchAnimals();
    _loadAnimals();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    try {
      ApiService apiService = ApiService();
      animaux = await apiService.fetchAnimals(2);
      print(animaux);
      setState(() {});
    } catch (e) {
      print('Erreur : $e');
    }
  }

  void _onNewAnimal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewAnimalsScreen()),
    );

    if (result == true) {
      _loadAnimals();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Widget selectedContainer = Container();

    // bool displayDropdown = false;
    // List<Map<String, dynamic>> foundAnimals = [];
    List<dynamic> foundAnimals = [];

    final LayerLink layerLink = LayerLink();

    if (_selectedCountIndex == 0) {
      selectedContainer = Container(
        margin: const EdgeInsets.only(top: 30),
        height: screenHeight * 0.44,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/vertb.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/images/vertc.png',
                  width: screenWidth * 0.5,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/images/vert.png',
                  width: screenWidth * 0.4,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_selectedCountIndex == 1) {
      selectedContainer = Container(
        margin: const EdgeInsets.only(top: 30),
        height: screenHeight * 0.44,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/orange.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/images/orangec.png',
                  width: screenWidth * 0.5,
                  height: 300,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/images/orangeb.png',
                  width: screenWidth * 0.32,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_selectedCountIndex == 2) {
      selectedContainer = Container(
        margin: const EdgeInsets.only(top: 30),
        height: screenHeight * 0.44,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/rouge (1).png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/images/rougec.png',
                  width: screenWidth * 0.5,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/images/rouge (2).png',
                  width: screenWidth * 0.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    int nombreMoutons = animaux
        .firstWhere((categorie) => categorie['libelle'] == 'Mouton',
            orElse: () => {'animaux': []})['animaux']
        .length;

    int nombreVaches = animaux
        .firstWhere((categorie) => categorie['libelle'] == 'Vache',
            orElse: () => {'animaux': []})['animaux']
        .length;

    int nombreColliersNormaux = 0;
    int nombreColliersSensibles = 0;
    int nombreColliersAnormaux = 0;

    if (animaux.isNotEmpty &&
        _selectedFilterIndex >= 0 &&
        _selectedFilterIndex < animaux.length &&
        animaux[_selectedFilterIndex].containsKey('animaux') &&
        animaux[_selectedFilterIndex]['animaux'].isNotEmpty) {
      for (var animal in animaux[_selectedFilterIndex]['animaux']) {
        Map<String, dynamic>? collier = colliers.firstWhere(
          (c) => c['identifier'] == animal['necklace_id']['identifier'],
          orElse: () => <String, dynamic>{},
        );

        if (collier.isNotEmpty) {
          if (collier['etat'] == 'normal') {
            nombreColliersNormaux++;
          } else if (collier['etat'] == 'sensible') {
            nombreColliersSensibles++;
          } else if (collier['etat'] == 'anormal') {
            nombreColliersAnormaux++;
          }
        }
      }
    }

    if (nombreColliersAnormaux == 0) {
      couleur = 'rouge';
    } else if (nombreColliersSensibles == 0) {
      couleur = 'orange';
    } else if (nombreColliersNormaux == 0) {
      couleur = 'verte';
    } else {
      couleur = 'couleur';
    }

    List<Map<String, dynamic>> filteredAnimaux = [];

    if (animaux.isNotEmpty &&
        _selectedFilterIndex < animaux.length &&
        animaux[_selectedFilterIndex]['animaux'] is List) {
      List<Map<String, dynamic>> animalList = List<Map<String, dynamic>>.from(
          animaux[_selectedFilterIndex]['animaux'] as List);

      filteredAnimaux = animalList.where((animal) {
        Map<String, dynamic>? collier = colliers.firstWhere(
          (c) => c['identifier'] == animal['necklace_id']['identifier'],
          orElse: () => <String, dynamic>{},
        );

        if (collier.isNotEmpty) {
          if (_selectedCountIndex == 0 && collier['etat'] == 'normal') {
            return true;
          } else if (_selectedCountIndex == 1 &&
              collier['etat'] == 'sensible') {
            return true;
          } else if (_selectedCountIndex == 2 && collier['etat'] == 'anormal') {
            return true;
          }
        }

        return false;
      }).toList();
    }

    List<dynamic> getAnimalSearchResult(String searchQuery) {
      List<dynamic> found = [];
      for (var category in animaux) {
        for (var animal in category['animaux']) {
          if (animal['name']
              .toLowerCase()
              .startsWith(searchQuery.toLowerCase())) {
            found.add(animal);
          }
        }
      }
      return found;
    }

    TextEditingController textController = TextEditingController(text: 'M001');
    TextEditingController nomController =
        TextEditingController(text: 'Saloum Saloum');
    TextEditingController ageController = TextEditingController(text: '6 ans');
    TextEditingController tailleController =
        TextEditingController(text: '1.70 m');
    TextEditingController poidsController =
        TextEditingController(text: '306 kg');
    TextEditingController genreController =
        TextEditingController(text: 'Femelle');
    TextEditingController raceController =
        TextEditingController(text: 'Ndama-grande');
    // TextEditingController _birthController =
    //     TextEditingController(text: '6 ans');

    final TextEditingController birthController = TextEditingController();
    DateTime? selectedDate;

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          birthController.text = '${picked.toLocal()}'.split(' ')[0];
        });
      }
    }

    int calculateAge(DateTime birthDate) {
      DateTime now = DateTime.now();
      int age = now.year - birthDate.year;

      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      return age;
    }

    // void showDeleteConfirmation(BuildContext context) {
    //   showModalBottomSheet(
    //     context: context,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(15),
    //         topRight: Radius.circular(15),
    //       ),
    //     ),
    //     builder: (BuildContext context) {
    //       return Container(
    //         padding: const EdgeInsets.all(16),
    //         height: 150,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             const Text(
    //               'Êtes-vous sûr de vouloir supprimer cet élément ?',
    //               style: TextStyle(fontSize: 16),
    //               textAlign: TextAlign.center,
    //             ),
    //             const SizedBox(height: 20),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 ElevatedButton(
    //                   onPressed: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: Colors.grey,
    //                   ),
    //                   child: const Text('Annuler'),
    //                 ),
    //                 ElevatedButton(
    //                   onPressed: () {
    //                     Navigator.of(context).pop();
    //                     showSuccessDialog(context);
    //                   },
    //                   child: const Text('Confirmer'),
    //                 ),
    //               ],
    //             )
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }

    void showAnimalDetails(BuildContext context, Map<String, dynamic> animal) {
      // String dateNaissString = animal['dateNaiss'];
      // DateTime dateNaiss = DateTime.parse(dateNaissString);
      // int age = _calculateAge(dateNaiss);

      textController.text = animal['necklace_id']['identifier'].toString();
      tailleController.text = "${animal['taille']}m";
      poidsController.text = "${animal['poids']}kg";
      genreController.text = animal['sexe'];
      ageController.text = animal['date_birth'];
      raceController.text = animal['race'];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.887,
            minChildSize: 0.6,
            maxChildSize: 0.887,
            builder: (_, controller) {
              return Container(
                // height: screenHeight * 0.95,
                // width: screenWidth,
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
                    Container(
                      width: 80,
                      height: 5,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.17,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.vert, width: 1.5),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 30 * 0.7, // Rempli à 70%
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: -4,
                                    top: 1,
                                    child: Container(
                                      width: 4,
                                      height: 8,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '70%',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.vert,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateAnimalScreen(animal: {
                                                  'id': animal['id'],
                                                  'name': animal['name'],
                                                  'sexe': animal['sexe'],
                                                  'date_birth':
                                                      animal['date_birth'],
                                                  'photo': animal['photo'],
                                                  'race': animal['race'],
                                                  'poids': animal['poids'],
                                                  'taille': animal['taille'],
                                                  'categorie':
                                                      animal['categorie_id']
                                                          ['libelle'],
                                                  'collier':
                                                      animal['necklace_id']
                                                          ['identifier']
                                                })),
                                      );
                                    },
                                    child: const FaIcon(
                                      FontAwesomeIcons.penToSquare,
                                      color: AppColors.vert,
                                      size: 18,
                                    ),
                                  ),
                                  // Spacer(),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      showConfirmationDialog(
                                          context, animal['id']);
                                    },
                                    child: const FaIcon(
                                      FontAwesomeIcons.trash,
                                      color: AppColors.vert,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Center(
                            child: Container(
                              width: 105,
                              height: 105,
                              decoration: const BoxDecoration(
                                color: AppColors.vertClair,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/me.jpeg'),
                                  radius: 40,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(height: screenHeight * 0.025),

                    Container(
                      height: screenHeight * 0.38,
                      decoration: const BoxDecoration(
                          // color: AppColors.noir
                          ),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              animal['name'],
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.noir,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: screenHeight * 0.3,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: const Text(
                                              'Race',
                                              style: TextStyle(
                                                  color: AppColors.noir,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: TextField(
                                                controller: raceController,
                                                textAlign: TextAlign.right,
                                                enabled: false,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 12.0),
                                                  isDense: true,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.black,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: const Text(
                                              'Âge',
                                              style: TextStyle(
                                                  color: AppColors.noir,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: TextField(
                                                controller: ageController,
                                                textAlign: TextAlign.right,
                                                enabled: false,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 12.0),
                                                  isDense: true,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.black,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: const Text(
                                              'Taille',
                                              style: TextStyle(
                                                  color: AppColors.noir,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: TextField(
                                                controller: tailleController,
                                                textAlign: TextAlign.right,
                                                enabled: false,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 12.0),
                                                  isDense: true,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.black,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: const Text(
                                              'Poids',
                                              style: TextStyle(
                                                  color: AppColors.noir,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: TextField(
                                                controller: poidsController,
                                                textAlign: TextAlign.right,
                                                enabled: false,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 12.0),
                                                  isDense: true,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.black,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: const Text(
                                              'Genre',
                                              style: TextStyle(
                                                  color: AppColors.noir,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: TextField(
                                                controller: genreController,
                                                textAlign: TextAlign.right,
                                                enabled: false,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 12.0),
                                                  isDense: true,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.black,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: const Text(
                                              'Collier',
                                              style: TextStyle(
                                                  color: AppColors.noir,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: TextField(
                                                controller: textController,
                                                textAlign: TextAlign.right,
                                                enabled: false,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 12.0),
                                                  isDense: true,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.black,
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
                    SizedBox(height: screenHeight * 0.003),

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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Position',
                            style: TextStyle(
                              color: AppColors.noir,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/images/moutonDebout.png',
                            height: 24,
                            width: 24,
                          ),
                          const Spacer(),
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Debout',
                                style: TextStyle(
                                  color: AppColors.noir,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    Expanded(
                      child: Container(
                        // height: screenHeight * 0.13,
                        // width: screenWidth * 0.85,
                        decoration: const BoxDecoration(
                            // color: AppColors.vert
                            ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.85,
                              child: const Text(
                                'Constantes vitales',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
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
                                color: AppColors.vertClair,
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
                                          'assets/images/freq.png',
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Fréquence cardiaque',
                                          style: TextStyle(
                                            color: AppColors.noir,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  const Expanded(
                                    child: Text(
                                      '80 bpm',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              width: screenWidth * 0.85,
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.gris),
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColors.vertClair,
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
                                          'assets/images/temp.png',
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Température corporelle',
                                          style: TextStyle(
                                            color: AppColors.noir,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  const Expanded(
                                    child: Text(
                                      '38 °C',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ).then((_) {
        _loadAnimals();
      });
    }

    void removeOverlay() {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    }
    // OverlayEntry _createOverlayEntry() {
    //   RenderBox? renderBox =
    //       _nameAnimalKey.currentContext?.findRenderObject() as RenderBox?;
    //   if (renderBox == null) {
    //     return OverlayEntry(builder: (_) => Container());
    //   }
    //   var size = renderBox.size;
    //   var offset = renderBox.localToGlobal(Offset.zero);

    //   return OverlayEntry(
    //     builder: (context) {
    //       return Positioned(
    //         width: size.width,
    //         left: offset.dx,
    //         top: offset.dy + size.height,
    //         child: Material(
    //           elevation: 4.0,
    //           borderRadius: BorderRadius.circular(12),
    //           child: Container(
    //             decoration: BoxDecoration(
    //               border: Border.all(color: AppColors.gris),
    //               borderRadius: BorderRadius.circular(12),
    //               color: AppColors.blanc,
    //             ),
    //             child: ListView.builder(
    //               shrinkWrap: true,
    //               itemCount: foundAnimals.length,
    //               itemBuilder: (context, index) {
    //                 return ListTile(
    //                   title: Text(foundAnimals[index]['nom']),
    //                   onTap: () {
    //                     setState(() {
    //                       _nameAnimal.text = foundAnimals[index]['nom'];
    //                       _removeOverlay();
    //                       print(foundAnimals);
    //                       _showAnimalDetails(context, foundAnimals[index + 1]);
    //                     });
    //                   },
    //                 );
    //               },
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    OverlayEntry createOverlayEntry() {
      RenderBox? renderBox =
          _nameAnimalKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        return OverlayEntry(builder: (_) => Container());
      }
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);

      return OverlayEntry(
        builder: (context) {
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    removeOverlay();
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              Positioned(
                width: size.width,
                left: offset.dx,
                top: offset.dy + size.height,
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gris),
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.blanc,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: foundAnimals.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(foundAnimals[index]['name']),
                            onTap: () {
                              setState(() {
                                removeOverlay();
                                showAnimalDetails(
                                    context, foundAnimals[index]);
                                _nameAnimal.text = '';
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    void showOverlay() {
      _focusNode.requestFocus();
      _overlayEntry = createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }

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
                  'Gestion des animaux',
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
                      Row(
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
                                        controller: _nameAnimal,
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
                                            _searchQuery = value;
                                            foundAnimals =
                                                getAnimalSearchResult(
                                                    _searchQuery);
                                            if (foundAnimals.isNotEmpty) {
                                              showOverlay(); // Affiche l'overlay si le dropdown n'est pas déjà affiché
                                            } else {
                                              removeOverlay(); // Retire l'overlay si aucun résultat n'est trouvé
                                            }
                                          });
                                        },
                                      )),
                                ],
                                // TextField(
                                //   style: const TextStyle(
                                //     color: Color.fromARGB(255, 0, 0, 0),
                                //   ),
                                //   controller: _nameAnimal,
                                //   decoration: InputDecoration(
                                //     hintText: 'Search...',
                                //     hintStyle: const TextStyle(
                                //       color:
                                //           Color.fromARGB(255, 200, 199, 197),
                                //     ),
                                //     prefixIcon: const Icon(
                                //       Icons.search,
                                //       color: AppColors.gris,
                                //     ),
                                //     contentPadding:
                                //         const EdgeInsets.symmetric(
                                //             vertical: 10, horizontal: 15),
                                //     border: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(12),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.gris,
                                //         width: 1,
                                //       ),
                                //     ),
                                //     enabledBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(12),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.gris,
                                //         width: 1,
                                //       ),
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(12),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.vert,
                                //         width: 2,
                                //       ),
                                //     ),
                                //     fillColor: AppColors.blanc,
                                //     filled: true,
                                //   ),
                                //   onChanged: (value) {
                                //     setState(() {
                                //       _searchQuery = value;
                                //       foundAnimals = getAnimalSearchResult(_searchQuery);
                                //       displayDropdown = foundAnimals.isNotEmpty;
                                //       print("Display Dropdown: $displayDropdown");
                                //       print("Found Animals: $foundAnimals");
                                //     });
                                //   },
                                // ),

                                // if (displayDropdown)
                                //   Expanded(
                                //     child: Container(
                                //       decoration: BoxDecoration(
                                //         border:
                                //             Border.all(color: AppColors.gris),
                                //         borderRadius:
                                //             BorderRadius.circular(12),
                                //         color: AppColors.blanc,
                                //       ),
                                //       child: ListView.builder(
                                //         shrinkWrap:
                                //             true,
                                //         itemCount: foundAnimals.length,
                                //         itemBuilder: (context, index) {
                                //           return ListTile(
                                //             title: Text(
                                //                 foundAnimals[index]['nom']),
                                //             onTap: () {
                                //               setState(() {
                                //                 _nameAnimal.text =
                                //                     foundAnimals[index]
                                //                         ['nom'];
                                //                 displayDropdown = false;
                                //               });
                                //             },
                                //           );
                                //         },
                                //       ),
                                //     ),
                                //   ),

                                // ],
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          GestureDetector(
                            onTap: () {
                              _onNewAnimal();
                            },
                            child: Container(
                              height: screenHeight * 0.04,
                              width: screenWidth * 0.1,
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
                      SizedBox(height: screenHeight * 0.035),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: screenHeight * 0.04,
                            decoration: BoxDecoration(
                              color: AppColors.blanc,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedFilterIndex = 0;
                                    });
                                  },
                                  child: Container(
                                    width: screenHeight * 0.0835,
                                    height: screenHeight * 0.04,
                                    decoration: BoxDecoration(
                                      color: _selectedFilterIndex == 0
                                          ? AppColors.vert
                                          : const Color.fromARGB(
                                              255, 235, 245, 227),
                                      borderRadius: BorderRadius.circular(12),
                                      // boxShadow: const [
                                      //   BoxShadow(
                                      //     color: AppColors.gris,
                                      //     spreadRadius: 4,
                                      //     blurRadius: 3,
                                      //     offset: Offset(0, 0),
                                      //   ),
                                      // ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            MdiIcons.sheep,
                                            color: _selectedFilterIndex == 0
                                                ? AppColors.blanc
                                                : AppColors.vert,
                                            size: 24,
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: -0,
                                          child: Container(
                                            width: 17,
                                            height: 17,
                                            decoration: BoxDecoration(
                                              color: _selectedFilterIndex == 0
                                                  ? AppColors.blanc
                                                  : AppColors.vert,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: _selectedFilterIndex == 0
                                                    ? AppColors.vert
                                                    : AppColors.blanc,
                                                width: 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$nombreMoutons',
                                                style: TextStyle(
                                                  color:
                                                      _selectedFilterIndex == 0
                                                          ? AppColors.vert
                                                          : AppColors.blanc,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedFilterIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    width: screenHeight * 0.0835,
                                    height: screenHeight * 0.04,
                                    decoration: BoxDecoration(
                                      color: _selectedFilterIndex == 1
                                          ? AppColors.vert
                                          : const Color.fromARGB(
                                              255, 235, 245, 227),
                                      borderRadius: BorderRadius.circular(12),
                                      // boxShadow: const [
                                      //   BoxShadow(
                                      //     color: AppColors.gris,
                                      //     spreadRadius: 1,
                                      //     blurRadius: 1,
                                      //     offset: Offset(0, 0),
                                      //   ),
                                      // ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            MdiIcons.cow,
                                            color: _selectedFilterIndex == 1
                                                ? AppColors.blanc
                                                : AppColors.vert,
                                            size: 24,
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: -0,
                                          child: Container(
                                            width: 17,
                                            height: 17,
                                            decoration: BoxDecoration(
                                              color: _selectedFilterIndex == 1
                                                  ? AppColors.blanc
                                                  : AppColors.vert,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: _selectedFilterIndex == 1
                                                    ? AppColors.vert
                                                    : AppColors.blanc,
                                                width: 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$nombreVaches',
                                                style: TextStyle(
                                                  color:
                                                      _selectedFilterIndex == 1
                                                          ? AppColors.vert
                                                          : AppColors.blanc,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: screenHeight * 0.04,
                            decoration: BoxDecoration(
                              color: AppColors.blanc,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCountIndex = 0;
                                    });
                                  },
                                  child: Container(
                                    width: screenWidth * 0.14,
                                    // height: screenHeight * 0.04,
                                    decoration: BoxDecoration(
                                      color: _selectedCountIndex == 0
                                          ? AppColors.vert
                                          : const Color.fromARGB(
                                              255, 235, 245, 227),
                                      borderRadius: BorderRadius.circular(12),
                                      // boxShadow: const [
                                      //   BoxShadow(
                                      //     color: AppColors.gris,
                                      //     spreadRadius: 1,
                                      //     blurRadius: 1,
                                      //     offset: Offset(0, 2),
                                      //   ),
                                      // ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$nombreColliersNormaux',
                                        style: TextStyle(
                                          color: _selectedCountIndex == 0
                                              ? AppColors.blanc
                                              : AppColors.vert,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCountIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    width: screenWidth * 0.14,
                                    // height: screenHeight * 0.04,
                                    decoration: BoxDecoration(
                                      color: _selectedCountIndex == 1
                                          ? const Color(0xFFFF9500)
                                          : const Color.fromARGB(
                                              255, 235, 245, 227),
                                      borderRadius: BorderRadius.circular(12),
                                      // boxShadow: const [
                                      //   BoxShadow(
                                      //     color: AppColors.gris,
                                      //     spreadRadius: 1,
                                      //     blurRadius: 1,
                                      //     offset: Offset(0, 2),
                                      //   ),
                                      // ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$nombreColliersSensibles',
                                        style: TextStyle(
                                          color: _selectedCountIndex == 1
                                              ? AppColors.blanc
                                              : const Color(0xFFFF9500),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCountIndex = 2;
                                    });
                                  },
                                  child: Container(
                                    width: screenWidth * 0.14,
                                    // height: screenHeight * 0.04,
                                    decoration: BoxDecoration(
                                      color: _selectedCountIndex == 2
                                          ? const Color(0xFFFF3B30)
                                          : const Color.fromARGB(
                                              255, 235, 245, 227),
                                      borderRadius: BorderRadius.circular(12),
                                      // boxShadow: const [
                                      //   BoxShadow(
                                      //     color: AppColors.gris,
                                      //     spreadRadius: 1,
                                      //     blurRadius: 1,
                                      //     offset: Offset(0, 2),
                                      //   ),
                                      // ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$nombreColliersAnormaux',
                                        style: TextStyle(
                                          color: _selectedCountIndex == 2
                                              ? AppColors.blanc
                                              : const Color(0xFFFF3B30),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Container(
                        height: screenHeight * 0.565,
                        width: screenWidth * 0.94,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: filteredAnimaux.isEmpty
                                ? [selectedContainer]
                                : filteredAnimaux.map<Widget>((animal) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        height: screenHeight * 0.08,
                                        width: screenWidth * 0.94,
                                        decoration: BoxDecoration(
                                          color: _selectedCountIndex == 0
                                              ? AppColors.vertClair
                                              : _selectedCountIndex == 1
                                                  ? const Color(0xFFFFEFD9)
                                                  : const Color(0xFFFFE2E0),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: AppColors.gris,
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10, top: 12),
                                                    child: Text(
                                                      animal['name']!,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF39434F),
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          screenHeight * 0.01),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      '${animal['sexe']}    ${animal['race']}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                // padding: const EdgeInsets.all(5),
                                                width: screenWidth * 0.38,
                                                height: screenHeight * 0.04,
                                                decoration: BoxDecoration(
                                                  color: _selectedCountIndex ==
                                                          0
                                                      ? AppColors.vert
                                                      : _selectedCountIndex == 1
                                                          ? const Color(
                                                              0xFFFF9500)
                                                          : const Color(
                                                              0xFFFF3B30),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  100),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  100)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 20),
                                                    Text(
                                                      animal['necklace_id']
                                                              ['identifier']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors.blanc,
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showAnimalDetails(
                                                            context, animal);
                                                      },
                                                      child: Container(
                                                        width:
                                                            screenWidth * 0.13,
                                                        height:
                                                            screenHeight * 0.04,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _selectedCountIndex ==
                                                                  0
                                                              ? const Color.fromARGB(
                                                                  255,
                                                                  81,
                                                                  170,
                                                                  77)
                                                              : _selectedCountIndex ==
                                                                      1
                                                                  ? const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      248,
                                                                      170,
                                                                      62)
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      248,
                                                                      100,
                                                                      92),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.arrow_forward,
                                                          color:
                                                              AppColors.blanc,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
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
