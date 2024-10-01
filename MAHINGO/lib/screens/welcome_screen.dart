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
    {
      'id': 4,
      'name': 'Shelly',
      'position': LatLng(14.6985, -17.4465),
      'photo': 'assets/images/four.jpeg'
    },
    {
      'id': 5,
      'name': 'Leonard',
      'position': LatLng(14.6995, -17.4455),
      'photo': 'assets/images/five.jpeg'
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
    _getUserLocation();
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
            showModalBottomSheet(
              context: context,
              builder: (context) => _buildAnimalInfo(animal),
            );
          },
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
    List<Map<String, dynamic>> animals = _animals
        .where((animal) => _showInZone
            ? _isPointInPolygon(animal['position'], _pastureZone)
            : !_isPointInPolygon(animal['position'], _pastureZone))
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: animals.length,
                  itemBuilder: (context, index) {
                    final animal = animals[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(animal['photo']),
                      ),
                      title: Text(animal['name']),
                      subtitle: Text(
                          _showInZone ? "Dans la zone" : "Hors de la zone"),
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
