import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<dynamic> _animals = [];
  int id = 2;

  late GoogleMapController mapController;
  final Location location = Location();
  LatLng _initialPosition = const LatLng(14.6928, -17.4467);
  bool _showInZone = true;
  TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> colliers = [
    {
      'id': 1,
      'identifier': 'M001',
      'timestamp': '2024-10-30',
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
      'identifier': 'M002',
      'timestamp': '2024-10-30',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "anormale"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.6950", // Coordonnées dans la zone
        'longitude': "-17.4435",
      },
      'etat': 'sensible'
    },
    {
      'id': 3,
      'identifier': 'M003',
      'timestamp': '2024-10-30',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "anormale"},
      'localisation': {
        'altitude': "14.6970", // Coordonnées dans la zone
        'longitude': "-17.4430",
      },
      'etat': 'sensible'
    },
    {
      'id': 12,
      'identifier': 'V002',
      'timestamp': '2024-10-30',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "normale"},
      'frequence': {'value': "15bpm", 'etat': "anormale"},
      'localisation': {
        'altitude': "14.6980", // Coordonnées dans la zone
        'longitude': "-17.4460",
      },
      'etat': 'normal'
    },
    {
      'id': 13,
      'identifier': 'V003',
      'timestamp': '2024-10-30',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "normale"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.6995", // Coordonnées hors zone
        'longitude': "-17.4480",
      },
      'etat': 'normal'
    },
    {
      'id': 16,
      'identifier': 'V001',
      'timestamp': '2024-10-30',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "normale"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7000",
        'longitude': "-17.4490",
      },
      'etat': 'anormal'
    },
    {
      'id': 17,
      'identifier': 'V004',
      'timestamp': '2024-10-30',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "normale"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7005",
        'longitude': "-17.4495",
      },
      'etat': 'anormal'
    },
    {
      'id': 18,
      'identifier': 'M004',
      'timestamp': '2024-10-30',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "normale"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7010",
        'longitude': "-17.4500",
      },
      'etat': 'normal'
    },
    {
      'id': 19,
      'identifier': 'M005',
      'timestamp': '2024-10-30',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "normale"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7015",
        'longitude': "-17.4505",
      },
      'etat': 'normal'
    },
    {
      'id': 20,
      'identifier': 'M006',
      'timestamp': '2024-10-30',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "normale"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7020",
        'longitude': "-17.4510",
      },
      'etat': 'normal'
    },
  ];
  final List<LatLng> _pastureZone = [
    LatLng(14.6940, -17.4470),
    LatLng(14.6940, -17.4420),
    LatLng(14.6980, -17.4420),
    LatLng(14.6980, -17.4470),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    // _getUserLocation();
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

  Widget _buildAnimalInfo(Map<String, dynamic> animal) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            animal['name'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Image.asset(
            animal['photo'],
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  void showAnimalPositionByName(String animalName) {
    animalName = animalName.toLowerCase();
    Set<Marker> _markers = {};

    Map<String, dynamic>? animal = _animals.firstWhere(
      (animal) => animal['name'].toLowerCase() == animalName,
      orElse: () => {},
    );

    if (animal != null && animal['necklace_id'] != null) {
      Map<String, dynamic>? collar = colliers.firstWhere(
        (collar) => collar['identifier'] == animal['necklace_id']['identifier'],
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
      title: const Text(
        'Localisation des animaux',
        style: TextStyle(
          color: AppColors.blanc,
        ),
      ),
      backgroundColor: AppColors.vert,
      elevation: 0,
    ),
      body: Stack(
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
            top: 10,
            left: 10,
            right: 60,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                      color: Color.fromARGB(255, 200, 199, 197)),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    showAnimalPositionByName(value.trim());
                  });
                },
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 80,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "inZone",
                  onPressed: () {
                    setState(() {
                      _showInZone = true;
                      _showAnimalList();
                    });
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.check_circle, color: Colors.white),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: "outZone",
                  onPressed: () {
                    setState(() {
                      _showInZone = false;
                      _showAnimalList();
                    });
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.warning, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAnimalList() {
    List<Map<String, dynamic>> animals = _animals
        .where((animal) {
          final collar = colliers.firstWhere(
            (c) => c['identifier'] == animal['necklace_id']['identifier'],
            orElse: () => {},
          );

          if (collar == null ||
              collar['localisation'] == null ||
              collar['localisation']['altitude'] == null ||
              collar['localisation']['longitude'] == null) {
            return false;
          }

          LatLng collarPosition = LatLng(
            double.tryParse(collar['localisation']['altitude']) ?? 0.0,
            double.tryParse(collar['localisation']['longitude']) ?? 0.0,
          );

          return _showInZone
              ? _isPointInPolygon(collarPosition, _pastureZone)
              : !_isPointInPolygon(collarPosition, _pastureZone);
        })
        .cast<Map<String, dynamic>>()
        .toList();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                _showInZone ? 'Animaux dans la zone' : 'Animaux hors zone',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: animals.length,
                  itemBuilder: (context, index) {
                    final animal = animals[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: animal['photo'] != null
                            ? AssetImage(animal['photo'])
                            : const AssetImage('assets/images/me.jpeg'),
                      ),
                      title: Text(
                        animal['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => _buildAnimalInfo(animal),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
