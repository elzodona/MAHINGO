import 'package:flutter/material.dart';
import 'package:mahingo/screens/welcome_screen.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<dynamic> animaux = [];

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
      'etat': 'anormal'
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
      'etat': 'anormal'
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

  final List<Map<String, dynamic>> _animals = [
    {
      'id': 1,
      'name': 'MacGyver',
      'position': LatLng(14.6950, -17.4440),
      'photo': 'assets/images/one.jpeg'
    },
    {
      'id': 2,
      'name': 'Bozer',
      'position': LatLng(14.6960, -17.4450),
      'photo': 'assets/images/two.jpeg'
    },
    {
      'id': 3,
      'name': 'Maty',
      'position': LatLng(14.6970, -17.4430),
      'photo': 'assets/images/three.jpeg'
    },
    {
      'id': 4,
      'name': 'Riley',
      'position': LatLng(14.6980, -17.4460),
      'photo': 'assets/images/four.jpeg'
    },
    {
      'id': 5,
      'name': 'Jack',
      'position': LatLng(14.6990, -17.4450),
      'photo': 'assets/images/five.jpeg'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadAnimals();
    _getUserLocation();
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
    return _animals.map((animal) {
      bool isInZone = _isPointInPolygon(animal['position'], _pastureZone);

      return Marker(
        markerId: MarkerId(animal['id'].toString()),
        position: animal['position'],
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isInZone ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: animal['name'],
          onTap: () {
            // showModalBottomSheet(
            //   context: context,
            //   builder: (context) => _buildAnimalInfo(animal),
            // );
          },
        ),
      );
    }).toSet();
  }

  Future<void> _loadAnimals() async {
    try {
      ApiService apiService = ApiService();
      animaux = await apiService.fetchAnimals(2);
      // print(animaux);
      setState(() {});
    } catch (e) {
      print('Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // List<Map<String, dynamic>> animauxAnormaux = [];
    // for (var categorie in animaux) {
    //   var listeAnimaux = categorie['animaux'];
    //   for (var animal in listeAnimaux) {
    //     var collier = colliers.firstWhere(
    //         (c) => c['identifier'] == animal['necklace_id']['identifier'],
    //         orElse: () => <String, dynamic>{});

    //     if (collier.isNotEmpty && collier['etat'] == 'anormal') {
    //       animauxAnormaux.add(animal);
    //     }
    //   }
    // }

    // for (var animal in animauxAnormaux) {
    //   print(animal['name']);
    // }


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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight * 0.98,
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
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              // height: screenHeight * 0.05,
                              child: Column(
                                children: [
                                  TextField(
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
                                    onChanged: (value) {},
                                  ),
                                  SizedBox(height: screenHeight * 0.025),
                                  Container(
                                    height: screenHeight * 0.35,
                                    width: screenWidth * 0.85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          Colors.white,
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
                                          top:
                                              0,
                                          right:
                                              0,
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

                                            // ...animauxAnormaux
                                            //     .map<Widget>((animal) {
                                            //   return Padding(
                                            //     padding: const EdgeInsets.only(
                                            //         bottom: 8.0),
                                            //     child: Container(
                                            //       height: screenHeight * 0.08,
                                            //       width: screenWidth * 0.94,
                                            //       decoration: BoxDecoration(
                                            //         color: const Color(
                                            //                     0xFFFFE2E0),
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 14),
                                            //         boxShadow: const [
                                            //           BoxShadow(
                                            //             color: AppColors.gris,
                                            //             spreadRadius: 1,
                                            //             blurRadius: 1,
                                            //             offset: Offset(0, 1),
                                            //           ),
                                            //         ],
                                            //       ),
                                            //       child: Row(
                                            //         children: [
                                            //           Expanded(
                                            //             child: Column(
                                            //               crossAxisAlignment:
                                            //                   CrossAxisAlignment
                                            //                       .start,
                                            //               children: [
                                            //                 Padding(
                                            //                   padding:
                                            //                       const EdgeInsets
                                            //                           .only(
                                            //                           left: 10,
                                            //                           top: 12),
                                            //                   child: Text(
                                            //                     animal['name']!,
                                            //                     style:
                                            //                         const TextStyle(
                                            //                       fontSize: 16,
                                            //                       color: Color(
                                            //                           0xFF39434F),
                                            //                       fontFamily:
                                            //                           'Roboto',
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .w600,
                                            //                     ),
                                            //                   ),
                                            //                 ),
                                            //                 SizedBox(
                                            //                     height:
                                            //                         screenHeight *
                                            //                             0.01),
                                            //                 Padding(
                                            //                   padding:
                                            //                       const EdgeInsets
                                            //                           .only(
                                            //                           left: 10),
                                            //                   child: Text(
                                            //                     '${animal['sexe']}    ${animal['race']}',
                                            //                     style:
                                            //                         const TextStyle(
                                            //                       fontSize: 14,
                                            //                       fontFamily:
                                            //                           'Roboto',
                                            //                     ),
                                            //                   ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ),
                                            //           Container(
                                            //               // padding: const EdgeInsets.all(5),
                                            //               width: screenWidth *
                                            //                   0.38,
                                            //               height: screenHeight *
                                            //                   0.04,
                                            //               decoration:
                                            //                   const BoxDecoration(
                                            //                 color: Color(
                                            //                             0xFFFF3B30),
                                            //                 borderRadius: BorderRadius
                                            //                     .only(
                                            //                     topLeft: Radius
                                            //                         .circular(
                                            //                             100),
                                            //                     bottomLeft: Radius
                                            //                         .circular(
                                            //                             100)),
                                            //               ),
                                            //               child: Row(
                                            //                 children: [
                                            //                   const SizedBox(
                                            //                       width: 20),
                                            //                   Text(
                                            //                     animal['necklace_id']
                                            //                             [
                                            //                             'identifier']
                                            //                         .toString(),
                                            //                     style:
                                            //                         const TextStyle(
                                            //                       fontSize: 16,
                                            //                       color:
                                            //                           AppColors
                                            //                               .blanc,
                                            //                       fontFamily:
                                            //                           'Roboto',
                                            //                       fontWeight:
                                            //                           FontWeight
                                            //                               .w600,
                                            //                     ),
                                            //                   ),
                                            //                   const Spacer(),
                                            //                   GestureDetector(
                                            //                     onTap: () {
                                                                  
                                            //                     },
                                            //                     child:
                                            //                         Container(
                                            //                       width:
                                            //                           screenWidth *
                                            //                               0.13,
                                            //                       height:
                                            //                           screenHeight *
                                            //                               0.04,
                                            //                       decoration:
                                            //                           const BoxDecoration(
                                            //                         color:  Color.fromARGB(
                                            //                                     255,
                                            //                                     248,
                                            //                                     100,
                                            //                                     92),
                                            //                         borderRadius:
                                            //                             BorderRadius
                                            //                                 .only(
                                            //                           topLeft: Radius
                                            //                               .circular(
                                            //                                   5),
                                            //                           bottomLeft:
                                            //                               Radius.circular(
                                            //                                   5),
                                            //                         ),
                                            //                       ),
                                            //                       child:
                                            //                           const Icon(
                                            //                         Icons
                                            //                             .arrow_forward,
                                            //                         color: AppColors
                                            //                             .blanc,
                                            //                         size: 20,
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ],
                                            //               )),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //   );
                                            // }).toList()
                                          
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
            ),
          ],
        ),
      ),
    );
  }
}
