import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mahingo/screens/location_screen.dart';
import 'package:mahingo/screens/welcome_screen.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahingo/widgets/app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  _AccueilScreenState createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  Map<String, dynamic> user = {};
  List<dynamic> animaux = [];
  List<dynamic> _animals = [];
  double? percentage;

  late GoogleMapController mapController;
  final Location location = Location();
  LatLng _initialPosition = const LatLng(14.6928, -17.4467);
  bool _showInZone = true;

  final List<LatLng> _pastureZone = [
    LatLng(14.6940, -17.4470),
    LatLng(14.6940, -17.4420),
    LatLng(14.6980, -17.4420),
    LatLng(14.6980, -17.4470),
  ];

  // final List<Map<String, dynamic>> animaux =
  // [
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
  //       }
  //     ]
  //   },
  //   {
  //     'id': 2,
  //     'libelle': "Vache",
  //     'animaux': [
  //       {
  //         'id': 3,
  //         'nom': "Maty",
  //         'sexe': "Femelle",
  //         'dateNaiss': "28/03/2020",
  //         'photo': "image.jpeg",
  //         'race': "race 1",
  //         'poids': "150kg",
  //         'taille': "30m",
  //         'idCategorie': 2,
  //         'idCollier': 3
  //       },
  //       {
  //         'id': 4,
  //         'nom': "Riley",
  //         'sexe': "Femelle",
  //         'dateNaiss': "28/03/2020",
  //         'photo': "image.jpeg",
  //         'race': "race 2",
  //         'poids': "130kg",
  //         'taille': "33m",
  //         'idCategorie': 2,
  //         'idCollier': 4
  //       },
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
      'identifier': 'M002',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.6960", // Coordonnées dans la zone
        'longitude': "-17.4450",
      },
      'etat': 'normal'
    },
    {
      'id': 2,
      'identifier': 'V002',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.6950", // Coordonnées dans la zone
        'longitude': "-17.4435",
      },
      'etat': 'sensible'
    },
    {
      'id': 3,
      'identifier': 'V003',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.6970", // Coordonnées dans la zone
        'longitude': "-17.4430",
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
        'altitude': "14.6980", // Coordonnées dans la zone
        'longitude': "-17.4460",
      },
      'etat': 'normal'
    },
    {
      'id': 5,
      'identifier': 'V001',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.6995", // Coordonnées hors zone
        'longitude': "-17.4480",
      },
      'etat': 'normal'
    },
    {
      'id': 6,
      'identifier': 'M006',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7000",
        'longitude': "-17.4490",
      },
      'etat': 'anormal'
    },
    {
      'id': 6,
      'identifier': 'M001',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7005",
        'longitude': "-17.4495",
      },
      'etat': 'anormal'
    },
    {
      'id': 7,
      'identifier': 'M007',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7010",
        'longitude': "-17.4500",
      },
      'etat': 'normal'
    },
    {
      'id': 8,
      'identifier': 'M008',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7015",
        'longitude': "-17.4505",
      },
      'etat': 'normal'
    },
    {
      'id': 9,
      'identifier': 'V006',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7020",
        'longitude': "-17.4510",
      },
      'etat': 'normal'
    },
  
  ];

  // final List<Map<String, dynamic>> _animals = [
  //   {
  //     "id": 1,
  //     "photo": null,
  //     "name": "Dudu",
  //     "date_birth": "2024-09-01",
  //     "sexe": "Male",
  //     "race": "Ladoum",
  //     "taille": 2,
  //     "poids": 200,
  //     "necklace_id": {
  //       "id": 1,
  //       "identifier": "M001",
  //     }
  //   },
  //   {
  //     "id": 2,
  //     "photo": null,
  //     "name": "Abdou",
  //     "date_birth": "2024-09-01",
  //     "sexe": "Male",
  //     "race": "Ladoum",
  //     "taille": 2,
  //     "poids": 200,
  //     "necklace_id": {
  //       "id": 2,
  //       "identifier": "M002",
  //     }
  //   },
  //   {
  //     "id": 3,
  //     "photo": null,
  //     "name": "Tapha",
  //     "date_birth": "2024-09-01",
  //     "sexe": "Male",
  //     "race": "Ladoum",
  //     "taille": 2,
  //     "poids": 200,
  //     "necklace_id": {
  //       "id": 3,
  //       "identifier": "V001",
  //     }
  //   },
  //   {
  //     "id": 4,
  //     "photo": null,
  //     "name": "Meuz",
  //     "date_birth": "2024-09-01",
  //     "sexe": "Male",
  //     "race": "Ladoum",
  //     "taille": 2,
  //     "poids": 200,
  //     "necklace_id": {
  //       "id": 4,
  //       "identifier": "V003",
  //     }
  //   },
  //   {
  //     "id": 5,
  //     "photo": null,
  //     "name": "Ass",
  //     "date_birth": "2024-09-01",
  //     "sexe": "Male",
  //     "race": "Ladoum",
  //     "taille": 2,
  //     "poids": 200,
  //     "necklace_id": {
  //       "id": 5,
  //       "identifier": "V004",
  //     }
  //   },
  //   {
  //     "id": 6,
  //     "photo": null,
  //     "name": "Wesh",
  //     "date_birth": "2024-09-01",
  //     "sexe": "Male",
  //     "race": "Ladoum",
  //     "taille": 2,
  //     "poids": 200,
  //     "necklace_id": {
  //       "id": 6,
  //       "identifier": "V002",
  //     }
  //   },
  // ];

  @override
  void initState() {
    super.initState();
    // _loadUserInfo();
    _loadUserInfo().then((_) {
      calculateGoodStatePercentage(_animals, colliers);
    });
    // _getUserLocation();
  }

  @override
  void didPopNext() {
    _loadUserInfo();
    // _loadAnimals();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      String userString = prefs.getString('user')!;
      Map<String, dynamic> userData = json.decode(userString);
      setState(() {
        user = userData;
      });
      print("User ID: ${user["id"]}");

      await _loadAnimals();
    } else {
      print('Aucun utilisateur trouvé dans les préférences partagées');
    }
  }

  Future<void> _loadAnimals() async {
    try {
      ApiService apiService = ApiService();
      animaux = await apiService.fetchAnimals(user["id"]);
      _animals = await apiService.fetchAnimalsb(user["id"]);
      // print(animaux);
      setState(() {});
    } catch (e) {
      print('Erreur : $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _userLocation;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _userLocation = await location.getLocation();
    setState(() {
      _initialPosition =
          LatLng(_userLocation.latitude!, _userLocation.longitude!);
    });

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _initialPosition, zoom: 14.0),
      ),
    );
  }

  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length - 1; j++) {
      if ((polygon[j].longitude <= point.longitude &&
              polygon[j + 1].longitude > point.longitude) ||
          (polygon[j].longitude > point.longitude &&
              polygon[j + 1].longitude <= point.longitude)) {
        double atX = (point.longitude - polygon[j].longitude) /
                (polygon[j + 1].longitude - polygon[j].longitude) *
                (polygon[j + 1].latitude - polygon[j].latitude) +
            polygon[j].latitude;
        if (point.latitude < atX) {
          intersectCount++;
        }
      }
    }
    return intersectCount % 2 != 0;
  }

  Set<Marker> _buildMarkers() {
    return colliers.where((collar) {
      return _animals.any((animal) =>
          animal['necklace_id'] != null &&
          animal['necklace_id']['identifier'] != null &&
          collar != null &&
          collar['identifier'] != null &&
          animal['necklace_id']['identifier'] == collar['identifier']);
    }).map((collar) {
      LatLng position = LatLng(
        double.parse(collar['localisation']['altitude']),
        double.parse(collar['localisation']['longitude']),
      );

      bool isInZone = _isPointInPolygon(position, _pastureZone);

      String? animalName;
      for (var animal in _animals) {
        if (animal['necklace_id'] != null &&
            animal['necklace_id']['identifier'] != null &&
            collar != null &&
            collar['identifier'] != null &&
            animal['necklace_id']['identifier'] == collar['identifier']) {
          animalName = animal['name'];
          break;
        }
      }

      return Marker(
        markerId: MarkerId(collar['identifier']),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isInZone ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: animalName ?? 'Animal inconnu',
          snippet: isInZone ? "Dans la zone" : "Hors de la zone",
        ),
      );
    }).toSet();
  }

  void calculateGoodStatePercentage(
      List<dynamic> animals, List<Map<String, dynamic>> colliers) {
    // Cast de la liste des animaux pour correspondre au type Map<String, dynamic>
    List<Map<String, dynamic>> animalsWithCollar = animals
        .where((animal) {
          return colliers.any((collar) =>
              collar['identifier'] == animal['necklace_id']['identifier']);
        })
        .cast<Map<String, dynamic>>()
        .toList(); // Conversion ici

    // Vérifier le nombre d'animaux avec un collier en état "normal"
    int goodStateAnimals = animalsWithCollar.where((animal) {
      final collar = colliers.firstWhere(
          (collar) =>
              collar['identifier'] == animal['necklace_id']['identifier'],
          orElse: () => {});

      if (collar != null && collar['etat'] == 'normal') {
        return true;
      }
      return false;
    }).length;

    // Calcul du pourcentage si des animaux avec des colliers existent
    if (animalsWithCollar.isNotEmpty) {
      setState(() {
        percentage = (goodStateAnimals / animalsWithCollar.length) * 100;
      });
    } else {
      setState(() {
        percentage = 0; // Aucun animal avec collier trouvé
      });
    }

    print(
        "Pourcentage d'animaux avec des colliers en bon état : ${percentage?.toStringAsFixed(2) ?? '0.00'}%");

  }


  @override
  Widget build(BuildContext context) {
    int nombreMoutons = animaux
        .firstWhere((categorie) => categorie['libelle'] == 'Mouton',
            orElse: () => {'animaux': []})['animaux']
        .length;

    int nombreVaches = animaux
        .firstWhere((categorie) => categorie['libelle'] == 'Vache',
            orElse: () => {'animaux': []})['animaux']
        .length;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: const CustomAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mon troupeau',
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.noir,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.12,
                        width: screenWidth * 0.3,
                        decoration: BoxDecoration(
                          color: AppColors.blanc,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: AppColors.vert,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.sheep,
                                color: AppColors.vert, size: 26),
                            Text(
                              '$nombreMoutons',
                              style: TextStyle(
                                color: AppColors.vert,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Moutons',
                              style: TextStyle(
                                color: AppColors.vert,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.12,
                        width: screenWidth * 0.3,
                        decoration: BoxDecoration(
                          color: AppColors.blanc,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: AppColors.vert,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.cow, color: AppColors.vert, size: 26),
                            Text(
                              '$nombreVaches',
                              style: TextStyle(
                                color: AppColors.vert,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Vaches',
                              style: TextStyle(
                                color: AppColors.vert,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.12,
                        width: screenWidth * 0.3,
                        decoration: const BoxDecoration(
                          color: AppColors.vert,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/icon_good_health.png',
                              color: AppColors.blanc,
                              height: 26,
                              width: 26,
                            ),
                            Text(
                              '${percentage?.toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: AppColors.blanc,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Bon état',
                              style: TextStyle(
                                color: AppColors.blanc,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        height: screenHeight * 0.35,
                        width: screenWidth * 0.9,
                        decoration: const BoxDecoration(
                          // color: Color.fromARGB(255, 203, 222, 201),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.5),
                            topRight: Radius.circular(12.5),
                          ),
                        ),
                        child: Stack(
                          children: [
                            GoogleMap(
                              onMapCreated: (controller) {
                                mapController = controller;
                              },
                              initialCameraPosition: CameraPosition(
                                target: _initialPosition,
                                zoom: 14.0,
                              ),
                              myLocationEnabled: true,
                              polygons: {
                                Polygon(
                                  polygonId: const PolygonId('pastureZone'),
                                  points: _pastureZone,
                                  fillColor: Colors.green.withOpacity(0.3),
                                  strokeColor: Colors.green,
                                  strokeWidth: 2,
                                ),
                              },
                              markers: _buildMarkers(),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WelcomeScreen()),
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/zoom.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        height: screenHeight * 0.065,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: AppColors.vert,
                          border: Border.all(
                            color: AppColors.vert,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Colobane rue 39×22, Dakar',
                          style: TextStyle(
                              color: AppColors.blanc,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Prochains évènements',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.noir,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.007),

                      Container(
                        // padding: const EdgeInsets.all(8.0),
                        height: screenHeight * 0.068,
                        width: screenWidth * 0.96,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF4EB),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: AppColors.vert,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Image.asset(
                                'assets/images/vaccination.png',
                                color: AppColors.blanc,
                                height: 26,
                                width: 26,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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

                      SizedBox(height: screenHeight * 0.006),

                      Container(
                        // padding: const EdgeInsets.all(8.0),
                        height: screenHeight * 0.068,
                        width: screenWidth * 0.96,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF4EB),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: AppColors.vert,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Image.asset(
                                'assets/images/visite_medicale.png',
                                color: AppColors.blanc,
                                height: 26,
                                width: 26,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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

                      SizedBox(height: screenHeight * 0.006),

                      Container(
                        // padding: const EdgeInsets.all(8.0),
                        height: screenHeight * 0.068,
                        width: screenWidth * 0.96,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF4EB),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: AppColors.vert,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Image.asset(
                                'assets/images/traitement.png',
                                color: AppColors.blanc,
                                height: 26,
                                width: 26,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
              ],
            ),
          ),
        
        ));
  }
}
