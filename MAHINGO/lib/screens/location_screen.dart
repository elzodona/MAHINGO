import 'package:flutter/material.dart';
import 'package:mahingo/screens/welcome_screen.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<dynamic> _animals = [];
  int id = 2;

  TextEditingController _searchController = TextEditingController();

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
    _loadUserInfo();
    // _getUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Set<Marker> _markers = {};

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

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      String userString = prefs.getString('user')!;
      Map<String, dynamic> userData = json.decode(userString);
      setState(() {
        id = userData["id"];
      });
      // print("User ID: ${id}");

      await _loadAnimals(id);
    } else {
      print('Aucun utilisateur trouvé dans les préférences partagées');
    }
  }

  Future<void> _loadAnimals(int id) async {
    try {
      ApiService apiService = ApiService();
      _animals = await apiService.fetchAnimalsb(id);
      // print(_animals);
      setState(() {});
    } catch (e) {
      print('Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void showAnimalPositionByName(String animalName) {
      animalName = animalName.toLowerCase();

      Map<String, dynamic>? animal = _animals.firstWhere(
        (animal) => animal['name'].toLowerCase() == animalName,
        orElse: () => {},
      );

      if (animal != null && animal['necklace_id'] != null) {
        Map<String, dynamic>? collar = colliers.firstWhere(
          (collar) =>
              collar['identifier'] == animal['necklace_id']['identifier'],
          orElse: () => {},
        );

        if (collar != null) {
          LatLng animalPosition = LatLng(
            double.parse(collar['localisation']['altitude']),
            double.parse(collar['localisation']['longitude']),
          );

          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(animalPosition, 18.0),
          );

          setState(() {
            _markers = _buildMarkers();
          });
        } else {
          print("Collier introuvable pour cet animal.");
        }
      } else {
        print("Animal non trouvé.");
      }
    }

    List<Map<String, dynamic>> animalsOutsideZone = _animals
        .where((animal) {
          var collar = colliers.firstWhere(
            (c) => c['identifier'] == animal['necklace_id']['identifier'],
            orElse: () =>
                {},
          );

          if (collar != null) {
            LatLng position = LatLng(
              double.parse(collar['localisation']['altitude']),
              double.parse(collar['localisation']['longitude']),
            );

            return !_isPointInPolygon(
                position, _pastureZone);
          }

          return false;
        })
        .cast<Map<String, dynamic>>()
        .toList();

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30),
                height: screenHeight * 0.14,
                color: AppColors.vert,
                child: const Center(
                  child: Text(
                    'Localisation',
                    style: TextStyle(
                      color: AppColors.blanc,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.7852,
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: AppColors.blanc,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(23),
                    topLeft: Radius.circular(23),
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              // height: screenHeight,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _searchController,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
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
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: AppColors.gris, width: 1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: AppColors.gris, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: AppColors.vert, width: 2),
                                      ),
                                      fillColor: AppColors.blanc,
                                      filled: true,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        showAnimalPositionByName(value.trim());
                                      });
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.025),
                                  Container(
                                    height: screenHeight * 0.35,
                                    width: screenWidth * 0.85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Stack(
                                      children: [
                                        GoogleMap(
                                          onMapCreated: (controller) {
                                            mapController = controller;
                                            // Aucune animation automatique vers l'utilisateur
                                            // _getUserLocation(); ne doit pas être appelé ici
                                          },
                                          initialCameraPosition: CameraPosition(
                                            target:
                                                _initialPosition, // position sur la zone délimitée
                                            zoom: 14.0,
                                          ),
                                          myLocationEnabled:
                                              true, // Option pour activer le bouton de localisation
                                          polygons: {
                                            Polygon(
                                              polygonId: const PolygonId(
                                                  'pastureZone'),
                                              points: _pastureZone,
                                              fillColor:
                                                  Colors.green.withOpacity(0.3),
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
                                  Container(
                                    height: screenHeight * 0.09,
                                    width: screenWidth * 0.85,
                                    decoration: BoxDecoration(
                                      color: AppColors.vertb,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Médina rue 22, Dakar",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                              height: screenHeight * 0.005),
                                          const Text(
                                            "09.06.2023  |  16:00",
                                            style: TextStyle(fontSize: 13),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.018),
                                  Container(
                                    height: screenHeight,
                                    // decoration: BoxDecoration(
                                    //   color: AppColors.vertb,
                                    // ),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Animaux hors zone",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: screenHeight * 0.01),
                                        Column(
                                          children: [
                                            ...animalsOutsideZone
                                                .map<Widget>((animal) {
                                              var collar = colliers.firstWhere(
                                                (c) =>
                                                    c['identifier'] ==
                                                    animal['necklace_id']
                                                        ['identifier'],
                                                orElse: () => {},
                                              );

                                              String etat = collar != null
                                                  ? collar['etat']
                                                  : 'normal';

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Container(
                                                  height: screenHeight * 0.1,
                                                  width: screenWidth * 0.94,
                                                  decoration: BoxDecoration(
                                                    color: getCollarColor(
                                                        etat),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
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
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10,
                                                                      top: 12),
                                                              child: Text(
                                                                animal['name']!,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                      0xFF39434F),
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    screenHeight *
                                                                        0.01),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
                                                              child: Text(
                                                                '${animal['sexe']}    ${animal['race']}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width:
                                                            screenWidth * 0.38,
                                                        height:
                                                            screenHeight * 0.04,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: getCollarColor2(
                                                              etat),
                                                          borderRadius:
                                                              const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    100),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    100),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            const SizedBox(
                                                                width: 20),
                                                            Text(
                                                              animal['name'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: AppColors
                                                                    .blanc,
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            GestureDetector(
                                                              onTap: () {
                                                                showAnimalPositionByName(
                                                                    animal[
                                                                        'name']);
                                                              },
                                                              child: Container(
                                                                width:
                                                                    screenWidth *
                                                                        0.13,
                                                                height:
                                                                    screenHeight *
                                                                        0.04,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: getCollarColor3(
                                                                          etat),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            5),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            5),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward,
                                                                  color:
                                                                      AppColors
                                                                          .blanc,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList()
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getCollarColor(String etat) {
    switch (etat) {
      case 'normal':
        return AppColors.vertClair;
      case 'sensible':
        return Color(0xFFFFEFD9);
      case 'anormal':
        return Color(0xFFFFE2E0);
      default:
        return AppColors.gris;
    }
  }

  Color getCollarColor2(String etat) {
    switch (etat) {
      case 'normal':
        return AppColors.vert;
      case 'sensible':
        return const Color(0xFFFF9500);
      case 'anormal':
        return const Color(0xFFFF3B30);
      default:
        return AppColors.gris;
    }
  }

  Color getCollarColor3(String etat) {
    switch (etat) {
      case 'normal':
        return Color.fromARGB(255, 81, 170, 77);
      case 'sensible':
        return Color.fromARGB(255, 248, 170, 62);
      case 'anormal':
        return Color.fromARGB(255, 248, 100, 92);
      default:
        return AppColors.gris;
    }
  }


}
