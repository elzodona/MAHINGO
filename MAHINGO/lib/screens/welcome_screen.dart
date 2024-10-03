import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mahingo/utils/colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late GoogleMapController mapController;
  final Location location = Location();
  LatLng _initialPosition = const LatLng(14.6928, -17.4467);
  bool _showInZone = true;

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
        'altitude': "14.6960", // Coordonnées dans la zone
        'longitude': "-17.4450",
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
        'altitude': "14.6950", // Coordonnées dans la zone
        'longitude': "-17.4435",
      },
      'etat': 'sensible'
    },
    {
      'id': 3,
      'identifier': 'V001',
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
      'identifier': 'V002',
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
      'identifier': 'V003',
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
      'identifier': 'V004',
      'timestamp': '12:40',
      'batterie': "70%",
      'position': "debout",
      'température': {'value': "15°C", 'etat': "sensible"},
      'frequence': {'value': "15bpm", 'etat': "normale"},
      'localisation': {
        'altitude': "14.7000", // Coordonnées hors zone
        'longitude': "-17.4490",
      },
      'etat': 'anormal'
    },
  ];

  final List<Map<String, dynamic>> _animals = [
    {
      "id": 1,
      "photo": null,
      "name": "Dudu",
      "date_birth": "2024-09-01",
      "sexe": "Male",
      "race": "Ladoum",
      "taille": 2,
      "poids": 200,
      "necklace_id": {
        "id": 1,
        "identifier": "M001",
      }
    },
    {
      "id": 2,
      "photo": null,
      "name": "Abdou",
      "date_birth": "2024-09-01",
      "sexe": "Male",
      "race": "Ladoum",
      "taille": 2,
      "poids": 200,
      "necklace_id": {
        "id": 2,
        "identifier": "M002",
      }
    },
    {
      "id": 3,
      "photo": null,
      "name": "Tapha",
      "date_birth": "2024-09-01",
      "sexe": "Male",
      "race": "Ladoum",
      "taille": 2,
      "poids": 200,
      "necklace_id": {
        "id": 3,
        "identifier": "V001",
      }
    },
    {
      "id": 4,
      "photo": null,
      "name": "Meuz",
      "date_birth": "2024-09-01",
      "sexe": "Male",
      "race": "Ladoum",
      "taille": 2,
      "poids": 200,
      "necklace_id": {
        "id": 4,
        "identifier": "V003",
      }
    },
    {
      "id": 5,
      "photo": null,
      "name": "Ass",
      "date_birth": "2024-09-01",
      "sexe": "Male",
      "race": "Ladoum",
      "taille": 2,
      "poids": 200,
      "necklace_id": {
        "id": 5,
        "identifier": "V004",
      }
    },
    {
      "id": 6,
      "photo": null,
      "name": "Wesh",
      "date_birth": "2024-09-01",
      "sexe": "Male",
      "race": "Ladoum",
      "taille": 2,
      "poids": 200,
      "necklace_id": {
        "id": 6,
        "identifier": "V002",
      }
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

  Set<Marker> _buildMarkers() {
    return colliers.map((collar) {
      LatLng position = LatLng(
        double.parse(collar['localisation']['altitude']),
        double.parse(collar['localisation']['longitude']),
      );

      bool isInZone = _isPointInPolygon(position, _pastureZone);

      String? animalName;
      for (var animal in _animals) {
        if (animal['necklace_id']['identifier'] == collar['identifier']) {
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

  @override
  Widget build(BuildContext context) {
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
    List<Map<String, dynamic>> animals = _animals.where((animal) {
      final collar = colliers.firstWhere(
        (c) => c['id'] == animal['necklace_id']['id'],
        orElse: () => {},
      );

      if (collar == null)
        return false; 
        
      LatLng collarPosition = LatLng(
        double.parse(collar['localisation']['altitude']),
        double.parse(collar['localisation']['longitude']),
      );

      return _showInZone
          ? _isPointInPolygon(collarPosition, _pastureZone)
          : !_isPointInPolygon(collarPosition, _pastureZone);
    }).toList();

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
                            : AssetImage(
                                'assets/images/me.jpeg'),
                      ),
                      title: Text(
                        animal['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                        ),
                      ),
                      // subtitle: Text(
                      //     _showInZone ? "Dans la zone" : "Hors de la zone"),
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
