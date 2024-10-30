import 'package:flutter/material.dart';
import 'package:mahingo/screens/home_screen.dart';
import 'package:mahingo/services/call_api/locationNotif_service.dart';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mahingo/services/call_api/event_service.dart';
import 'package:mahingo/services/call_api/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedOption1 = 'un';
  String selectedOption2 = 'one';

  List<dynamic> _animals = [];

  final List<Map<String, dynamic>> colliers = [
    {
      'id': 1,
      'identifier': 'M002',
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
      'identifier': 'V002',
      'timestamp': '2024-10-30',
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
      'timestamp': '2024-10-30',
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
      'timestamp': '2024-10-30',
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
      'timestamp': '2024-10-30',
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
      'timestamp': '2024-10-30',
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
      'timestamp': '2024-10-30',
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
      'timestamp': '2024-10-30',
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
      'timestamp': '2024-10-30',
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
      'timestamp': '2024-10-30',
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

  final List<LatLng> _pastureZone = [
    LatLng(14.6940, -17.4470),
    LatLng(14.6940, -17.4420),
    LatLng(14.6980, -17.4420),
    LatLng(14.6980, -17.4470),
  ];

  List<Map<String, dynamic>> animalsOutsideZone = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int id = 2;
  Map<DateTime, List<dynamic>> _events = {};
  List<dynamic> _nextThreeEvents = [];
  List<dynamic> _notifs = [];
  List<dynamic> _notifsNonLues = [];
  List<dynamic> _locationNotifs = [];
  List<dynamic> _locationNotifsNonLues = [];

  // List<dynamic> notifsEvents = [
  //   {
  //     "id": 12,
  //     "etat": "lu",
  //     "user": {
  //       "id": 3,
  //       "first_name": "Chàabane",
  //       "last_name": "Diallo",
  //       "telephone": "781235623",
  //       "address": "Colobane rue 64x32, Dakar",
  //       "profession": "IoT",
  //       "email": "shabane@gmail.com",
  //       "email_verified_at": null,
  //       "role": "client",
  //       "photo": null
  //     },
  //     "animal": {
  //       "id": 2,
  //       "photo": null,
  //       "name": "Jemmy",
  //       "date_birth": "2024-09-01",
  //       "sexe": "Male",
  //       "race": "Ladoum",
  //       "taille": 2,
  //       "poids": 200,
  //       "necklace_id": 2,
  //       "categorie_id": 1,
  //       "user_id": 3
  //     },
  //     "titre": "traitement",
  //     "description": "hey you",
  //     "dateEvent": "2024-10-12",
  //     "heureDebut": "19:00:00",
  //     "heureFin": "19:30:00"
  //   },
  //   {
  //     "id": 13,
  //     "etat": "non_lu",
  //     "user": {
  //       "id": 3,
  //       "first_name": "Chàabane",
  //       "last_name": "Diallo",
  //       "telephone": "781235623",
  //       "address": "Colobane rue 64x32, Dakar",
  //       "profession": "IoT",
  //       "email": "shabane@gmail.com",
  //       "email_verified_at": null,
  //       "role": "client",
  //       "photo": null
  //     },
  //     "animal": {
  //       "id": 1,
  //       "photo": null,
  //       "name": "Douks",
  //       "date_birth": "2020-03-28",
  //       "sexe": "Male",
  //       "race": "Malaka",
  //       "taille": 2,
  //       "poids": 200,
  //       "necklace_id": 1,
  //       "categorie_id": 1,
  //       "user_id": 2
  //     },
  //     "titre": "vaccination",
  //     "description": "Bah, on se reproduit nous.",
  //     "dateEvent": "2024-10-12",
  //     "heureDebut": "20:26:00",
  //     "heureFin": "21:26:00"
  //   },
  //   {
  //     "id": 14,
  //     "etat": "non_lu",
  //     "user": {
  //       "id": 3,
  //       "first_name": "Chàabane",
  //       "last_name": "Diallo",
  //       "telephone": "781235623",
  //       "address": "Colobane rue 64x32, Dakar",
  //       "profession": "IoT",
  //       "email": "shabane@gmail.com",
  //       "email_verified_at": null,
  //       "role": "client",
  //       "photo": null
  //     },
  //     "animal": {
  //       "id": 1,
  //       "photo": null,
  //       "name": "Douks",
  //       "date_birth": "2020-03-28",
  //       "sexe": "Male",
  //       "race": "Malaka",
  //       "taille": 2,
  //       "poids": 200,
  //       "necklace_id": 1,
  //       "categorie_id": 1,
  //       "user_id": 2
  //     },
  //     "titre": "reproduction",
  //     "description": "Bah, on se reproduit nous.",
  //     "dateEvent": "2024-10-12",
  //     "heureDebut": "22:26:00",
  //     "heureFin": "23:26:00"
  //   },
  //   {
  //     "id": 15,
  //     "etat": "lu",
  //     "user": {
  //       "id": 3,
  //       "first_name": "Chàabane",
  //       "last_name": "Diallo",
  //       "telephone": "781235623",
  //       "address": "Colobane rue 64x32, Dakar",
  //       "profession": "IoT",
  //       "email": "shabane@gmail.com",
  //       "email_verified_at": null,
  //       "role": "client",
  //       "photo": null
  //     },
  //     "animal": {
  //       "id": 1,
  //       "photo": null,
  //       "name": "Douks",
  //       "date_birth": "2020-03-28",
  //       "sexe": "Male",
  //       "race": "Malaka",
  //       "taille": 2,
  //       "poids": 200,
  //       "necklace_id": 1,
  //       "categorie_id": 1,
  //       "user_id": 2
  //     },
  //     "titre": "vaccination",
  //     "description": "Bah, on se reproduit nous.",
  //     "dateEvent": "2024-10-12",
  //     "heureDebut": "21:26:00",
  //     "heureFin": "22:26:00"
  //   },
  // ];

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
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadUserInfo();
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

      await _loadLocationNotifs(id);
      await _loadEvents(id);
      await _loadNotifs(id);
      await _getUpcomingEvents();
      await _loadAnimals(id);
    } else {
      print('Aucun utilisateur trouvé dans les préférences partagées');
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

      // print(_events);
    } catch (e) {
      print('Erreur : $e');
    }
  }

  Future<void> _loadNotifs(int id) async {
    try {
      Api3Service apiService = Api3Service();
      _notifs = await apiService.fetchNotifs(id);
      // print(_notifs);

      List<dynamic> _notifsNLues = [];

      for (var notif in _notifs) {
        if (notif['etat'] == 'non_lu') {
          _notifsNLues.add(notif);
        }
      }

      setState(() {
        _notifsNonLues = _notifsNLues;
      });
    } catch (e) {
      print('Erreur : $e');
    }
  }

  Future<void> _getUpcomingEvents() async {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> upcomingEvents = [];

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

          Duration difference = fullEventDateTime.difference(now);

          if (difference.inSeconds <= 1800 && difference.inSeconds > 0) {
            upcomingEvents.add(event);
          }
        }
      }
    }

    if (upcomingEvents.isNotEmpty) {
      try {
        Api3Service apiService = Api3Service();
        List<dynamic> notifs = await apiService.fetchNotifs(id);

        for (var event in upcomingEvents) {
          Map<String, dynamic> newNotif = {
            'animal_id':
                (event["animal"] != null && event["animal"]["id"] != null)
                    ? event["animal"]["id"]
                    : null,
            'user_id': (event["user"] != null && event["user"]["id"] != null)
                ? event["user"]["id"]
                : null,
            'titre': event["titre"] ?? '',
            'dateEvent': event["dateEvent"] ?? '',
            'heureDebut': event["heureDebut"] ?? '',
            'heureFin': event["heureFin"] ?? '',
            'description': event["description"] ?? '',
          };

          bool exists = notifs.any((notif) =>
              notif["titre"] == newNotif["titre"] &&
              notif["dateEvent"] == newNotif["dateEvent"] &&
              notif["heureDebut"] == newNotif["heureDebut"]);

          if (!exists) {
            dynamic response = await Api3Service().createNotif(newNotif);
            print("Notification créée : $response");
          } else {
            print("Notification déjà existante : ${newNotif['titre']}");
          }
        }

        _loadNotifs(id);
        _loadEvents(id);
      } catch (e) {
        print('Erreur lors de la création des notifications : $e');
      }

      setState(() {
        _nextThreeEvents = upcomingEvents;
      });
    } else {
      setState(() {
        _nextThreeEvents = [];
      });
    }
  }

  Future<void> _loadAnimals(int id) async {
    try {
      ApiService apiService = ApiService();
      _animals = await apiService.fetchAnimalsb(id);
      // print(_animals);

      setState(() {
        animalsOutsideZone = _animals
            .where((animal) {
              var collar = colliers.firstWhere(
                (c) => c['identifier'] == animal['necklace_id']['identifier'],
                orElse: () => {},
              );

              if (collar != null) {
                LatLng position = LatLng(
                  double.parse(collar['localisation']['altitude']),
                  double.parse(collar['localisation']['longitude']),
                );

                return !_isPointInPolygon(position, _pastureZone);
              }

              return false;
            })
            .cast<Map<String, dynamic>>()
            .toList();
      });
      // print(animalsOutsideZone);
      await _saveLocation(animalsOutsideZone);
    } catch (e) {
      print('Erreur : $e');
    }
  }

  Future<void> _loadLocationNotifs(int id) async {
    try {
      Api4Service apiService = Api4Service();
      _locationNotifs = await apiService.fetchNotifs(id);
      // print(_locationNotifs);

      List<dynamic> _notifsNLues = [];

      for (var notif in _locationNotifs) {
        if (notif['etat'] == 'non_lu') {
          _notifsNLues.add(notif);
        }
      }

      setState(() {
        _locationNotifsNonLues = _notifsNLues;
      });
      // print(_locationNotifsNonLues);
    } catch (e) {
      print('Erreur : $e');
    }
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

  Future<void> _saveLocation(
      List<Map<String, dynamic>> animalsOutsideZone) async {
    try {
      Api4Service apiService = Api4Service();

      for (var animal in animalsOutsideZone) {
        var collar = colliers.firstWhere(
          (c) => c['identifier'] == animal['necklace_id']['identifier'],
          orElse: () => {},
        );

        if (collar != null) {
          // print(collar);

          Map<String, dynamic> newNotif = {
            'animal_id': animal["id"],
            'user_id': animal["user_id"]["id"],
            'dateSave': collar["timestamp"],
            'altitude': collar["localisation"]["altitude"],
            'longitude': collar["localisation"]["longitude"],
          };

            dynamic response = await Api4Service().createNotif(newNotif);
            print("Notification créée : $response");

        }
      }

      _loadLocationNotifs(id);
    } catch (e) {
      print('Erreur lors de la création des notifications : $e');
    }
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                  ),
                  const Spacer(),
                  const Center(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
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
            Container(
              height: screenHeight * 0.86,
              width: screenWidth,
              decoration: const BoxDecoration(
                color: AppColors.blanc,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(23),
                  topLeft: Radius.circular(23),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.055,
                    width: screenWidth,
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      // color: AppColors.vert,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(23),
                        topLeft: Radius.circular(23),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                            height: screenHeight * 0.03,
                            width: screenWidth * 0.42,
                            // padding: EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.vertClair,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption1 = 'un';
                                      });
                                    },
                                    child: Container(
                                        height: screenHeight * 0.03,
                                        width: screenWidth * 0.135,
                                        // padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: selectedOption1 == 'un'
                                              ? AppColors.vert
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/images/icon_good_health.png',
                                            color: selectedOption1 == 'un'
                                                ? AppColors.blanc
                                                : AppColors.vert,
                                            height: 20,
                                            width: 20,
                                          ),
                                        )),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption1 = 'dos';
                                      });
                                    },
                                    child: Container(
                                        height: screenHeight * 0.03,
                                        width: screenWidth * 0.135,
                                        // padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: selectedOption1 == 'dos'
                                              ? AppColors.vert
                                              : Colors.transparent,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/images/loca.png',
                                            color: selectedOption1 == 'dos'
                                                ? AppColors.blanc
                                                : AppColors.vert,
                                            height: 18,
                                            width: 18,
                                          ),
                                        )),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption1 = 'tres';
                                      });
                                    },
                                    child: Container(
                                        height: screenHeight * 0.03,
                                        width: screenWidth * 0.135,
                                        // padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: selectedOption1 == 'tres'
                                              ? AppColors.vert
                                              : Colors.transparent,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/images/calendar.png',
                                            color: selectedOption1 == 'tres'
                                                ? AppColors.blanc
                                                : AppColors.vert,
                                            height: 18,
                                            width: 18,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            )),
                        Spacer(),
                        Container(
                            height: screenHeight * 0.03,
                            width: screenWidth * 0.425,
                            // padding: EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.vertClair,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption2 = 'one';
                                      });
                                    },
                                    child: Container(
                                        height: screenHeight * 0.03,
                                        width: screenWidth * 0.21,
                                        // padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: selectedOption2 == 'one'
                                              ? AppColors.vert
                                              : Colors.transparent,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Toutes",
                                            style: TextStyle(
                                                color: selectedOption2 == 'one'
                                                    ? AppColors.blanc
                                                    : AppColors.noir,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption2 = 'two';
                                      });
                                    },
                                    child: Container(
                                        height: screenHeight * 0.03,
                                        width: screenWidth * 0.21,
                                        // padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: selectedOption2 == 'two'
                                              ? AppColors.vert
                                              : Colors.transparent,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Non lues",
                                            style: TextStyle(
                                                color: selectedOption2 == 'two'
                                                    ? AppColors.blanc
                                                    : AppColors.noir,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                      child: Container(
                          // height: screenHeight * 0.63,
                          width: screenWidth,
                          decoration: const BoxDecoration(
                            // color: AppColors.vert,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(23),
                              topLeft: Radius.circular(23),
                            ),
                          ),
                          child: selectedOption1 == 'tres'
                              ? selectedOption2 == 'one'
                                  ? Column(
                                      children: _notifs.map((event) {
                                        DateTime eventDate =
                                            DateTime.parse(event['dateEvent']);
                                        String formattedDate =
                                            '${eventDate.day}.${eventDate.month}.${eventDate.year}';
                                        String time = event['heureDebut'];

                                        return Dismissible(
                                          key: Key(event['id'].toString()),
                                          onDismissed: (direction) async {
                                            _notifs.remove(event);

                                            Api3Service apiService =
                                                Api3Service();

                                            try {
                                              dynamic response =
                                                  await apiService
                                                      .deleteNotif(event['id']);
                                              print(
                                                  "Notification deleted: $response");

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        '${event['titre']} supprimé')),
                                              );
                                            } catch (e) {
                                              print(
                                                  "Erreur lors de la suppression de la notification: $e");

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Erreur lors de la suppression de la notification")),
                                              );

                                              _notifs.add(event);
                                            }
                                          },
                                          // background: Container(color: Colors.red),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: GestureDetector(
                                              onTap: () async {
                                                _showEventDetails(
                                                    context, event);
                                                Api3Service apiService =
                                                    Api3Service();
                                                try {
                                                  dynamic response =
                                                      await apiService
                                                          .updateNotif(
                                                              event['id']);
                                                  print(
                                                      "Notification mise à jour : $response");
                                                  _loadNotifs(id);
                                                } catch (e) {
                                                  print(
                                                      "Erreur lors de la mise à jour de la notification : $e");
                                                }
                                              },
                                              child: Container(
                                                height: screenHeight * 0.082,
                                                width: screenWidth * 0.88,
                                                decoration: BoxDecoration(
                                                  color: event["etat"] == "lu"
                                                      ? AppColors.blanc
                                                      : AppColors.vertClair,
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: AppColors.gris,
                                                      spreadRadius: 3,
                                                      blurRadius: 6,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 70,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        color: event["etat"] ==
                                                                "lu"
                                                            ? AppColors.blanc
                                                            : AppColors
                                                                .vertClair,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: (event['titre'] ==
                                                              'vaccination')
                                                          ? Image.asset(
                                                              'assets/images/vaccination.png',
                                                              color: event[
                                                                          "etat"] ==
                                                                      "lu"
                                                                  ? Color(
                                                                      0xFF808B9A)
                                                                  : AppColors
                                                                      .vert,
                                                              width: 8,
                                                              height: 8,
                                                            )
                                                          : (event['titre'] ==
                                                                  'visite medicale')
                                                              ? Image.asset(
                                                                  'assets/images/visite_medicale.png',
                                                                  color: event[
                                                                              "etat"] ==
                                                                          "lu"
                                                                      ? Color(
                                                                          0xFF808B9A)
                                                                      : AppColors
                                                                          .vert,
                                                                  width: 8,
                                                                  height: 8,
                                                                )
                                                              : (event['titre'] ==
                                                                      'traitement')
                                                                  ? Image.asset(
                                                                      'assets/images/traitement.png',
                                                                      color: event["etat"] ==
                                                                              "lu"
                                                                          ? Color(
                                                                              0xFF808B9A)
                                                                          : AppColors
                                                                              .vert,
                                                                      width: 8,
                                                                      height: 8,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .event,
                                                                      color: event["etat"] ==
                                                                              "lu"
                                                                          ? Color(
                                                                              0xFF808B9A)
                                                                          : AppColors
                                                                              .vert,
                                                                      size: 24,
                                                                    ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          event['titre'],
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                AppColors.noir,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          '$formattedDate | $time',
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF808B9A),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      width: 50,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            '13:30',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF808B9A),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 7),
                                                            child:
                                                                event["etat"] ==
                                                                        "lu"
                                                                    ? Image
                                                                        .asset(
                                                                        'assets/images/lue.png',
                                                                        height:
                                                                            18,
                                                                        width:
                                                                            18,
                                                                      )
                                                                    : Image
                                                                        .asset(
                                                                        'assets/images/non_lue.png',
                                                                        height:
                                                                            18,
                                                                        width:
                                                                            18,
                                                                      ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  : Column(
                                      children: _notifsNonLues.map((event) {
                                        DateTime eventDate =
                                            DateTime.parse(event['dateEvent']);
                                        String formattedDate =
                                            '${eventDate.day}.${eventDate.month}.${eventDate.year}';
                                        String time = event['heureDebut'];

                                        return Dismissible(
                                            key: Key(event['id'].toString()),
                                            onDismissed: (direction) async {
                                              _notifs.remove(event);

                                              Api3Service apiService =
                                                  Api3Service();

                                              try {
                                                dynamic response =
                                                    await apiService
                                                        .deleteNotif(
                                                            event['id']);
                                                print(
                                                    "Notification deleted: $response");

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          '${event['titre']} supprimé')),
                                                );
                                              } catch (e) {
                                                print(
                                                    "Erreur lors de la suppression de la notification: $e");

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          "Erreur lors de la suppression de la notification")),
                                                );
                                                _notifs.add(event);
                                              }
                                            },
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    _showEventDetails(
                                                        context, event);
                                                    Api3Service apiService =
                                                        Api3Service();
                                                    try {
                                                      dynamic response =
                                                          await apiService
                                                              .updateNotif(
                                                                  event['id']);
                                                      print(
                                                          "Notification mise à jour : $response");
                                                      _loadNotifs(id);
                                                    } catch (e) {
                                                      print(
                                                          "Erreur lors de la mise à jour de la notification : $e");
                                                    }
                                                  },
                                                  child: Container(
                                                    height:
                                                        screenHeight * 0.082,
                                                    width: screenWidth * 0.88,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.vertClair,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: AppColors.gris,
                                                          spreadRadius: 3,
                                                          blurRadius: 6,
                                                          offset: Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 70,
                                                          width: 70,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .vertClair,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          child: (event[
                                                                      'titre'] ==
                                                                  'vaccination')
                                                              ? Image.asset(
                                                                  'assets/images/vaccination.png',
                                                                  color:
                                                                      AppColors
                                                                          .vert,
                                                                  width: 8,
                                                                  height: 8,
                                                                )
                                                              : (event['titre'] ==
                                                                      'visite medicale')
                                                                  ? Image.asset(
                                                                      'assets/images/visite_medicale.png',
                                                                      color: AppColors
                                                                          .vert,
                                                                      width: 8,
                                                                      height: 8,
                                                                    )
                                                                  : (event['titre'] ==
                                                                          'traitement')
                                                                      ? Image
                                                                          .asset(
                                                                          'assets/images/traitement.png',
                                                                          color:
                                                                              AppColors.vert,
                                                                          width:
                                                                              8,
                                                                          height:
                                                                              8,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .event,
                                                                          color:
                                                                              AppColors.vert,
                                                                          size:
                                                                              24,
                                                                        ),
                                                        ),
                                                        const SizedBox(
                                                            width: 16),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              event['titre'],
                                                              style:
                                                                  const TextStyle(
                                                                color: AppColors
                                                                    .noir,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Text(
                                                              '$formattedDate | $time',
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF808B9A),
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Container(
                                                          width: 50,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Text(
                                                                '13:30',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .noir,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/non_lue.png',
                                                                  color:
                                                                      AppColors
                                                                          .vert,
                                                                  height: 12,
                                                                  width: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )));
                                      }).toList(),
                                    )
                              : selectedOption1 == 'dos'
                                  ? selectedOption2 == 'one'
                                      ? Column(
                                          children:
                                              _locationNotifs.map((event) {
                                            return Dismissible(
                                              key: Key(event['id'].toString()),
                                              onDismissed: (direction) async {
                                                _locationNotifs.remove(event);

                                                Api4Service apiService =
                                                    Api4Service();

                                                try {
                                                  dynamic response =
                                                      await apiService
                                                          .deleteNotif(
                                                              event['id']);
                                                  print(
                                                      "Notification deleted: $response");

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Notification supprimé')),
                                                  );
                                                } catch (e) {
                                                  print(
                                                      "Erreur lors de la suppression de la notification: $e");

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "Erreur lors de la suppression de la notification")),
                                                  );

                                                  _locationNotifs.add(event);
                                                }
                                              },
                                              // background: Container(color: Colors.red),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    _showLocationNotifDetails(
                                                        context, event);
                                                    Api4Service apiService =
                                                        Api4Service();
                                                    try {
                                                      dynamic response =
                                                          await apiService
                                                              .updateNotif(
                                                                  event['id']);
                                                      print(
                                                          "Notification mise à jour : $response");
                                                      _loadLocationNotifs(id);
                                                    } catch (e) {
                                                      print(
                                                          "Erreur lors de la mise à jour de la notification : $e");
                                                    }
                                                  },
                                                  child: Container(
                                                    height:
                                                        screenHeight * 0.082,
                                                    width: screenWidth * 0.88,
                                                    decoration: BoxDecoration(
                                                      color: event["etat"] ==
                                                              "lu"
                                                          ? AppColors.blanc
                                                          : AppColors.vertClair,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: AppColors.gris,
                                                          spreadRadius: 3,
                                                          blurRadius: 6,
                                                          offset: Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            height: 70,
                                                            width: 70,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: event[
                                                                          "etat"] ==
                                                                      "lu"
                                                                  ? AppColors
                                                                      .blanc
                                                                  : AppColors
                                                                      .vertClair,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            child: (Image.asset(
                                                              'assets/images/loc.png',
                                                              color: event[
                                                                          "etat"] ==
                                                                      "lu"
                                                                  ? Color(
                                                                      0xFF808B9A)
                                                                  : AppColors
                                                                      .vert,
                                                              width: 8,
                                                              height: 8,
                                                            ))),
                                                        const SizedBox(
                                                            width: 16),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              event['animal']
                                                                  ['name'],
                                                              style:
                                                                  const TextStyle(
                                                                color: AppColors
                                                                    .noir,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const Text(
                                                              'Localisé hors de la zone',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF808B9A),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Container(
                                                          width: 50,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Text(
                                                                '13:30',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF808B9A),
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            7),
                                                                child: event[
                                                                            "etat"] ==
                                                                        "lu"
                                                                    ? Image
                                                                        .asset(
                                                                        'assets/images/lue.png',
                                                                        height:
                                                                            18,
                                                                        width:
                                                                            18,
                                                                      )
                                                                    : Image
                                                                        .asset(
                                                                        'assets/images/non_lue.png',
                                                                        height:
                                                                            18,
                                                                        width:
                                                                            18,
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        )
                                      : Column(
                                          children: _locationNotifsNonLues
                                              .map((event) {
                                            return Dismissible(
                                                key:
                                                    Key(event['id'].toString()),
                                                onDismissed: (direction) async {
                                                  _locationNotifs.remove(event);

                                                  Api4Service apiService =
                                                      Api4Service();

                                                  try {
                                                    dynamic response =
                                                        await apiService
                                                            .deleteNotif(
                                                                event['id']);
                                                    print(
                                                        "Notification deleted: $response");

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Notification supprimé')),
                                                    );
                                                  } catch (e) {
                                                    print(
                                                        "Erreur lors de la suppression de la notification: $e");

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              "Erreur lors de la suppression de la notification")),
                                                    );
                                                    _locationNotifs.add(event);
                                                  }
                                                },
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        _showLocationNotifDetails(
                                                            context, event);
                                                        Api4Service apiService =
                                                            Api4Service();
                                                        try {
                                                          dynamic response =
                                                              await apiService
                                                                  .updateNotif(
                                                                      event[
                                                                          'id']);
                                                          print(
                                                              "Notification mise à jour : $response");
                                                          _loadLocationNotifs(
                                                              id);
                                                        } catch (e) {
                                                          print(
                                                              "Erreur lors de la mise à jour de la notification : $e");
                                                        }
                                                      },
                                                      child: Container(
                                                        height: screenHeight *
                                                            0.082,
                                                        width:
                                                            screenWidth * 0.88,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .vertClair,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: AppColors
                                                                  .gris,
                                                              spreadRadius: 3,
                                                              blurRadius: 6,
                                                              offset:
                                                                  Offset(0, 3),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 70,
                                                              width: 70,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .vertClair,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child:
                                                                  (Image.asset(
                                                                'assets/images/loc.png',
                                                                color: AppColors
                                                                    .vert,
                                                                width: 8,
                                                                height: 8,
                                                              )),
                                                            ),
                                                            const SizedBox(
                                                                width: 16),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  event['animal']
                                                                      ['name'],
                                                                  style:
                                                                      const TextStyle(
                                                                    color:
                                                                        AppColors
                                                                            .noir,
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  'Localisé hors de la zone',
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF808B9A),
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            Container(
                                                              width: 50,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                    '13:30',
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColors
                                                                          .noir,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'Poppins',
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/non_lue.png',
                                                                      color: AppColors
                                                                          .vert,
                                                                      height:
                                                                          12,
                                                                      width: 12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )));
                                          }).toList(),
                                        )
                                  : Container()))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      event['etat'] = "non_lu";

      int index = _notifs.indexWhere((e) => e['id'] == event['id']);
      if (index != -1) {
        _notifs[index]['etat'] = "non_lu";
      }
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.4,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 5,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Container(
                  height: screenHeight * 0.27,
                  width: screenWidth * 0.8,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (event['titre'] == 'vaccination')
                            Image.asset(
                              'assets/images/vaccination.png',
                              color: AppColors.vert,
                              width: 22,
                              height: 22,
                            )
                          else if (event['titre'] == 'visite medicale')
                            Image.asset(
                              'assets/images/visite_medicale.png',
                              color: AppColors.vert,
                              width: 22,
                              height: 22,
                            )
                          else if (event['titre'] == 'traitement')
                            Image.asset(
                              'assets/images/traitement.png',
                              color: AppColors.vert,
                              width: 22,
                              height: 22,
                            )
                          else
                            const Icon(
                              Icons.event,
                              color: Colors.green,
                              size: 22,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            event['titre'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        event['description'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Date: ${event['dateEvent']}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Heure: ${event['heureDebut']} - ${event['heureFin']}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
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
  }

  void _showLocationNotifDetails(
      BuildContext context, Map<String, dynamic> event) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      event['etat'] = "non_lu";

      int index = _locationNotifs.indexWhere((e) => e['id'] == event['id']);
      if (index != -1) {
        _locationNotifs[index]['etat'] = "non_lu";
      }
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.4,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 5,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Container(
                  height: screenHeight * 0.27,
                  width: screenWidth * 0.8,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/loc.png',
                            color: AppColors.vert,
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Alerte sécurité',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '${event['animal']['name']} a été localisé hors de la zone',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Date: ${event['dateSave']}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
