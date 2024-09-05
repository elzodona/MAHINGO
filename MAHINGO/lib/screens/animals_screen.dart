import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  _AnimalsScreenState createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  int _selectedFilterIndex = 0;
  int _selectedCountIndex = 0;
  String couleur = 'couleur';

  final List<Map<String, dynamic>> animaux = [
    {
      'id': 1,
      'libelle': "Mouton",
      'animaux': [
        {
          'id': 1,
          'nom': "MacGyver",
          'sexe': "Male",
          'dateNaiss': "28/03/2020",
          'photo': "image.jpeg",
          'race': "Ladoum",
          'poids': "150kg",
          'taille': "30Cm",
          'idCategorie': 1,
          'idCollier': 1
        },
        {
          'id': 2,
          'nom': "Bozer",
          'sexe': "Male",
          'dateNaiss': "28/03/2020",
          'photo': "image.jpeg",
          'race': "Ladoum",
          'poids': "130kg",
          'taille': "35cm",
          'idCategorie': 1,
          'idCollier': 2
        },
        {
          'id': 6,
          'nom': "Diallo",
          'sexe': "Male",
          'dateNaiss': "28/03/2020",
          'photo': "image.jpeg",
          'race': "Ladoum",
          'poids': "130kg",
          'taille': "35cm",
          'idCategorie': 1,
          'idCollier': 6
        },
        {
          'id': 7,
          'nom': "Douks",
          'sexe': "Male",
          'dateNaiss': "28/03/2020",
          'photo': "image.jpeg",
          'race': "Ladoum",
          'poids': "130kg",
          'taille': "35cm",
          'idCategorie': 1,
          'idCollier': 7
        }
      ]
    },
    {
      'id': 2,
      'libelle': "Vache",
      'animaux': [
        // {
        //   'id': 3,
        //   'nom': "Maty",
        //   'sexe': "Femelle",
        //   'dateNaiss': "28/03/2020",
        //   'photo': "image.jpeg",
        //   'race': "race 1",
        //   'poids': "150kg",
        //   'taille': "30m",
        //   'idCategorie': 2,
        //   'idCollier': 3
        // },
        // {
        //   'id': 4,
        //   'nom': "Riley",
        //   'sexe': "Femelle",
        //   'dateNaiss': "28/03/2020",
        //   'photo': "image.jpeg",
        //   'race': "race 2",
        //   'poids': "130kg",
        //   'taille': "33m",
        //   'idCategorie': 2,
        //   'idCollier': 4
        // },
        {
          'id': 5,
          'nom': "Jack",
          'sexe': "Male",
          'dateNaiss': "28/03/2020",
          'photo': "image.jpeg",
          'race': "race 3",
          'poids': "110kg",
          'taille': "30m",
          'idCategorie': 2,
          'idCollier': 5
        }
      ]
    },
  ];

  final List<Map<String, dynamic>> colliers = [
    {
      'id': 1,
      'batterie': "70%",
      'position': "debout",
      'température': "15°C",
      'frequence': "20bpm",
      'localisation': {
        'altitude': "",
        'longitude': "",
        'lieu': "Dakar",
        'date': "28/03/2024",
        'heure': "15:40"
      },
      'etat': 'normal'
    },
    {
      'id': 2,
      'batterie': "95%",
      'position': "couché",
      'température': "17°C",
      'frequence': "23bpm",
      'localisation': {
        'altitude': "",
        'longitude': "",
        'lieu': "Dakar",
        'date': "28/03/2024",
        'heure': "15:40"
      },
      'etat': 'sensible'
    },
    {
      'id': 3,
      'batterie': "100%",
      'position': "en marche",
      'température': "15°C",
      'frequence': "21bpm",
      'localisation': {
        'altitude': "",
        'longitude': "",
        'lieu': "Dakar",
        'date': "28/03/2024",
        'heure': "15:40"
      },
      'etat': 'sensible'
    },
    {
      'id': 4,
      'batterie': "95%",
      'position': "couché",
      'température': "17°C",
      'frequence': "23bpm",
      'localisation': {
        'altitude': "",
        'longitude': "",
        'lieu': "Dakar",
        'date': "28/03/2024",
        'heure': "15:40"
      },
      'etat': 'normal'
    },
    {
      'id': 5,
      'batterie': "95%",
      'position': "couché",
      'température': "17°C",
      'frequence': "23bpm",
      'localisation': {
        'altitude': "",
        'longitude': "",
        'lieu': "Dakar",
        'date': "28/03/2024",
        'heure': "15:40"
      },
      'etat': 'anormal'
    },
    {
      'id': 6,
      'batterie': "95%",
      'position': "couché",
      'température': "17°C",
      'frequence': "23bpm",
      'localisation': {
        'altitude': "",
        'longitude': "",
        'lieu': "Dakar",
        'date': "28/03/2024",
        'heure': "15:40"
      },
      'etat': 'normal'
    },
    {
      'id': 7,
      'batterie': "95%",
      'position': "couché",
      'température': "17°C",
      'frequence': "23bpm",
      'localisation': {
        'altitude': "",
        'longitude': "",
        'lieu': "Dakar",
        'date': "28/03/2024",
        'heure': "15:40"
      },
      'etat': 'normal'
    }
  ];

  @override
  Widget build(BuildContext context) {
    Widget selectedContainer = Container();

    if (_selectedCountIndex == 0) {
      selectedContainer = Container(
        margin: EdgeInsets.only(top: 30),
        height: 350,
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
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/images/vert.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_selectedCountIndex == 1) {
      selectedContainer = Container(
        margin: EdgeInsets.only(top: 30),
        height: 350,
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
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/images/orangeb.png',
                  width: 115,
                  height: 115,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_selectedCountIndex == 2) {
      selectedContainer = Container(
        margin: EdgeInsets.only(top: 30),
        height: 350,
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
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/images/rouge (2).png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ],
        ),
      );
    }

    int nombreMoutons = animaux
        .firstWhere((categorie) => categorie['libelle'] == 'Mouton')['animaux']
        .length;
    int nombreVaches = animaux
        .firstWhere((categorie) => categorie['libelle'] == 'Vache')['animaux']
        .length;

    int nombreColliersNormaux = 0;
    int nombreColliersSensibles = 0;
    int nombreColliersAnormaux = 0;

    for (var animal in animaux[_selectedFilterIndex]['animaux']) {
      Map<String, dynamic>? collier = colliers.firstWhere(
        (c) => c['id'] == animal['idCollier'],
        orElse: () => <String, dynamic>{},
      );

      if (collier != null) {
        if (collier['etat'] == 'normal') {
          nombreColliersNormaux++;
        } else if (collier['etat'] == 'sensible') {
          nombreColliersSensibles++;
        } else if (collier['etat'] == 'anormal') {
          nombreColliersAnormaux++;
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

    List<Map<String, dynamic>> filteredAnimaux =
        animaux[_selectedFilterIndex]['animaux'].where((animal) {
      Map<String, dynamic>? collier = colliers.firstWhere(
        (c) => c['id'] == animal['idCollier'],
        orElse: () => <String, dynamic>{},
      );

      if (collier != null) {
        if (_selectedCountIndex == 0 && collier['etat'] == 'normal') {
          return true;
        } else if (_selectedCountIndex == 1 && collier['etat'] == 'sensible') {
          return true;
        } else if (_selectedCountIndex == 2 && collier['etat'] == 'anormal') {
          return true;
        }
      }

      return false;
    }).toList();

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
              height: 130,
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
                  height: 650,
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
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.blanc,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.gris,
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const TextField(
                                style: TextStyle(
                                  color: AppColors.gris,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 200, 199, 197),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: AppColors.gris,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  border: InputBorder.none,
                                  fillColor: AppColors.blanc,
                                  filled: true,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 36,
                            width: 48,
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
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Container(
                            width: 135,
                            height: 30,
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
                                    width: 67,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: _selectedFilterIndex == 0
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
                                    width: 67,
                                    height: 35,
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
                          const SizedBox(width: 59),
                          Container(
                            width: 170,
                            height: 30,
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
                                    width: 55,
                                    height: 30,
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
                                    width: 55,
                                    height: 30,
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
                                    width: 55,
                                    height: 30,
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
                      const SizedBox(height: 18),
                      Container(
                        height: 460,
                        width: double.infinity,
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
                                        height: 70,
                                        width: double.infinity,
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
                                                    padding: EdgeInsets.only(
                                                        left: 10, top: 12),
                                                    child: Text(
                                                      animal['nom']!,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF39434F),
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      '${animal['sexe']}    ${animal['race']}',
                                                      style: TextStyle(
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
                                                width: 140,
                                                height: 30,
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
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  100),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  100)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 20),
                                                    Text(
                                                      'N ' +
                                                          animal['idCollier']
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
                                                    Container(
                                                      width: 50,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: _selectedCountIndex ==
                                                                0
                                                            ? Color.fromARGB(
                                                                255,
                                                                81,
                                                                170,
                                                                77)
                                                            : _selectedCountIndex ==
                                                                    1
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        248,
                                                                        170,
                                                                        62)
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        248,
                                                                        100,
                                                                        92),
                                                        borderRadius:
                                                            BorderRadius.only(
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
                                                        color: AppColors.blanc,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ],
                                                )),
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
