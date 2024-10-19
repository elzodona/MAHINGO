import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mahingo/screens/location_screen.dart';
import 'package:mahingo/screens/welcome_screen.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahingo/widgets/app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:mahingo/services/call_api/event_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';

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
  int id = 2;
  Map<DateTime, List<dynamic>> _events = {};
  List<dynamic> _nextThreeEvents = [];


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
        id = userData["id"];
      });
      print("User ID: ${user["id"]}");

      await _loadAnimals();
      await _loadEvents(id);

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

      _getUpcomingEvents();
    } catch (e) {
      print('Erreur : $e');
    }
  }

  void _getUpcomingEvents() {
    List<dynamic> upcomingEvents = [];
    DateTime now = DateTime.now();

    for (var key in _events.keys) {
      List<dynamic> dayEvents = _events[key]!;

      if (key.year == now.year &&
          key.month == now.month &&
          key.day == now.day) {
        for (var event in dayEvents) {
          TimeOfDay eventTime = TimeOfDay(
            hour: int.parse(event['heureDebut'].split(':')[0]),
            minute: int.parse(event['heureDebut'].split(':')[1]),
          );

          DateTime fullEventDateTime = DateTime(
            key.year,
            key.month,
            key.day,
            eventTime.hour,
            eventTime.minute,
          );

          if (fullEventDateTime.isAfter(now)) {
            upcomingEvents.add(event);
          }
        }
      } else if (key.isAfter(now)) {
        upcomingEvents.addAll(dayEvents);
      }
    }

    upcomingEvents.sort((a, b) {
      DateTime dateA = DateTime.parse(a['dateEvent']);
      TimeOfDay timeA = TimeOfDay(
        hour: int.parse(a['heureDebut'].split(':')[0]),
        minute: int.parse(a['heureDebut'].split(':')[1]),
      );
      DateTime fullDateTimeA = DateTime(
        dateA.year,
        dateA.month,
        dateA.day,
        timeA.hour,
        timeA.minute,
      );

      DateTime dateB = DateTime.parse(b['dateEvent']);
      TimeOfDay timeB = TimeOfDay(
        hour: int.parse(b['heureDebut'].split(':')[0]),
        minute: int.parse(b['heureDebut'].split(':')[1]),
      );
      DateTime fullDateTimeB = DateTime(
        dateB.year,
        dateB.month,
        dateB.day,
        timeB.hour,
        timeB.minute,
      );

      return fullDateTimeA.compareTo(fullDateTimeB);
    });

    setState(() {
      _nextThreeEvents = upcomingEvents.take(3).toList();
    });
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
          padding: const EdgeInsets.all(16),
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
                              style: const TextStyle(
                                color: AppColors.vert,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const Text(
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
                              style: const TextStyle(
                                color: AppColors.vert,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const Text(
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
                              style: const TextStyle(
                                color: AppColors.blanc,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const Text(
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
                        padding: const EdgeInsets.all(6),
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.86,
                        decoration: BoxDecoration(
                          color: AppColors.vert,
                          border: Border.all(
                            color: AppColors.vert,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          user["address"] ?? '',
                          style: const TextStyle(
                              color: AppColors.blanc,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 6),
                        child: const Text(
                          'Prochains évènements',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.noir,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.007),

                      Column(
                        children: _nextThreeEvents.map((event) {
                          DateTime eventDate =
                              DateTime.parse(event['dateEvent']);
                          String formattedDate =
                              '${eventDate.day}.${eventDate.month}.${eventDate.year}';
                          String time = event['heureDebut'];

                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4),
                            child: GestureDetector(
                              onTap: () {
                                showEventDetails(context, event);
                              },
                              child: Container(
                                height: screenHeight * 0.068,
                                width: screenWidth * 0.87,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF4EB),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.vert,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: (event['titre'] == 'vaccination')
                                        ? Image.asset(
                                            'assets/images/vaccination.png',
                                            color: AppColors.blanc,
                                            width: 10,
                                            height: 10,
                                          )
                                        : (event['titre'] == 'visite medicale')
                                            ? Image.asset(
                                                'assets/images/visite_medicale.png',
                                                color: AppColors.blanc,
                                                width: 10,
                                                height: 10,
                                              )
                                            : (event['titre'] == 'traitement')
                                                ? Image.asset(
                                                    'assets/images/traitement.png',
                                                    color: AppColors.blanc,
                                                    width: 10,
                                                    height: 10,
                                                  )
                                                : const Icon(
                                                    Icons.event,
                                                    color: Colors.white,
                                                    size: 26,
                                                  ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          event['titre'],
                                          style: const TextStyle(
                                            color: AppColors.noir,
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '$formattedDate | $time',
                                          style: const TextStyle(
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
                            ),
                          );
                        }).toList(),
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
        
        ));
  }

  void closeAllDialogs(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void showEventDetails(BuildContext context, Map<String, dynamic> event) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    closeAllDialogs(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return Container(
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
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Détails de l’évènement",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.vert,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 36),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            showEventEditModal(context, event);
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: AppColors.vert,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.3,
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
                        event['animal'] != null &&
                                event['animal']['name'] != null
                            ? _buildDetailRow(
                                screenWidth, 'Animal', event['animal']['name'])
                            : SizedBox.shrink(),
                        _buildDetailRow(screenWidth, 'Titre', event['titre']),
                        _buildDetailRow(
                            screenWidth, 'Date', event['dateEvent']),
                        _buildDetailRow(
                            screenWidth, 'Heure de debut', event['heureDebut']),
                        _buildDetailRow(
                            screenWidth, 'Heure de fin', event['heureFin']),
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
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '',
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
                          decoration: InputDecoration(
                            hintText: event['description'] ??
                                'Pas de description disponible',
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(double screenWidth, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: screenWidth * 0.35,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                label,
                style: const TextStyle(
                    color: AppColors.noir, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  textAlign: TextAlign.right,
                  enabled: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(right: 12.0),
                    isDense: true,
                  ),
                  style: const TextStyle(color: Colors.black),
                  controller: TextEditingController(text: value),
                ),
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.gris),
      ],
    );
  }

  void showEventEditModal(BuildContext context, Map<String, dynamic> event) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    closeAllDialogs(context);

    TextEditingController animalController = TextEditingController(
      text: event['animal'] != null && event['animal']['name'] != null
          ? event['animal']['name']
          : '',
    );
    TextEditingController titreController =
        TextEditingController(text: event['titre']);
    TextEditingController dateController =
        TextEditingController(text: event['dateEvent']);
    TextEditingController debutController =
        TextEditingController(text: event['heureDebut']);
    TextEditingController finController =
        TextEditingController(text: event['heureFin']);
    TextEditingController descriptionController =
        TextEditingController(text: event['description'] ?? '');

    DateTime? selectedDate = DateTime.tryParse(event['dateEvent']);
    TimeOfDay? selectedHeureDebut = TimeOfDay(
        hour: int.parse(event['heureDebut'].split(':')[0]),
        minute: int.parse(event['heureDebut'].split(':')[1]));
    TimeOfDay? selectedHeureFin = TimeOfDay(
        hour: int.parse(event['heureFin'].split(':')[0]),
        minute: int.parse(event['heureFin'].split(':')[1]));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
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
                  SizedBox(height: screenHeight * 0.02),
                  const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Modifier l’évènement",
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
                    height: screenHeight * 0.35,
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
                        event['animal'] != null &&
                                event['animal']['name'] != null
                            ? _buildEditableDetailRow(
                                screenWidth, 'Animal', animalController)
                            : SizedBox.shrink(),
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
                                  .updateEvent(event['id'], newEventData);
                              // print('Événement mis à jour : $response');
                              showInfoDialoga(
                                  context,
                                  'Événement mis à jour avec succès.',
                                  'Succès', () {
                                _loadUserInfo();
                              });
                            } catch (e) {
                              print('Erreur lors de la mise à jour : $e');
                              showInfoDialoga(
                                  context,
                                  'Erreur lors de la mise à jour : ${e.toString()}',
                                  'Erreur', () {
                                _loadUserInfo();
                              });
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
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditableDetailRow(
      double screenWidth, String label, TextEditingController controller) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: screenWidth * 0.35,
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
