// import 'package:flutter/material.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:mahingo/services/call_api/event_service.dart';
// import 'package:mahingo/services/call_api/notification_service.dart';
// import 'package:mahingo/models/event_mod.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Map<DateTime, List<dynamic>> _events = {};
// List<dynamic> _nextThreeEvents = [];

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print('Exécution de la tâche de fond : $task');

//     await _loadUserInfo();

//     await _showNotification(
//         'Test Notification', 'Cette notification vient de la tâche de fond.');

//     print('Notification envoyée depuis la tâche de fond');
//     return Future.value(true);
//   });
// }

// Future<void> _showNotification(String title, String body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'mahingo_channel',
//     'Notifications des événements de Mahingo',
//     channelDescription:
//         'Ce canal envoie des notifications pour les événements et rappels concernant les animaux.',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     title,
//     body,
//     platformChannelSpecifics,
//     payload: 'item x',
//   );
// }

// Future<void> _loadUserInfo() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   if (prefs.containsKey('user')) {
//     String userString = prefs.getString('user')!;
//     Map<String, dynamic> userData = json.decode(userString);
//     int id = userData["id"];

//     await _loadEvents(id);
//     await _getUpcomingEvents(id);
//   } else {
//     print('Aucun utilisateur trouvé dans les préférences partagées');
//   }
// }

// Future<void> _loadEvents(int id) async {
//   try {
//     Api2Service apiService = Api2Service();
//     List<dynamic> events = await apiService.fetchEvents(id);

//     print('Événements récupérés : $events');

//     Map<DateTime, List<dynamic>> eventsMap = {};
//     for (var event in events) {
//       DateTime eventDate = DateTime.parse(event['dateEvent']);
//       DateTime eventKey =
//           DateTime(eventDate.year, eventDate.month, eventDate.day);

//       if (eventsMap[eventKey] == null) {
//         eventsMap[eventKey] = [];
//       }
//       eventsMap[eventKey]!.add(event);
//     }

//     _events = eventsMap;

//     print('Événements dans _events : $_events');
//   } catch (e) {
//     print('Erreur lors de la récupération des événements : $e');
//   }
// }

// Future<void> _getUpcomingEvents(int id) async {
//   DateTime now = DateTime.now();
//   List<Map<String, dynamic>> upcomingEvents = [];

//   if (_events.isEmpty) {
//     print('Aucun événement trouvé.');
//   } else {
//     print('Événements disponibles : ${_events.length}');
//   }

//   for (var key in _events.keys) {
//     List<dynamic> dayEvents = _events[key]!;

//     if (key.year == now.year && key.month == now.month && key.day == now.day) {
//       for (var event in dayEvents) {
//         TimeOfDay eventTime = TimeOfDay(
//           hour: int.parse(event['heureDebut'].split(':')[0]),
//           minute: int.parse(event['heureDebut'].split(':')[1]),
//         );

//         DateTime fullEventDateTime = DateTime(
//           key.year,
//           key.month,
//           key.day,
//           eventTime.hour,
//           eventTime.minute,
//         );

//         Duration difference = fullEventDateTime.difference(now);

//         print('Différence en secondes : ${difference.inSeconds}');

//         if (difference.inSeconds <= 1800 && difference.inSeconds > 0) {
//           upcomingEvents.add(event);
//         }
//       }
//     }
//   }

//   if (upcomingEvents.isNotEmpty) {
//     print('Événements imminents trouvés : ${upcomingEvents.length}');
//     await _showNotification('Événements à venir',
//         'Vous avez des événements dans les 30 prochaines minutes.');
//   } else {
//     print("Aucun événement à venir.");
//     await _showNotification('Événements à venir',
//         'Vous n\'avez pas d\'événements dans les 30 prochaines minutes.');
//   }
// }


// // Future<void> _getUpcomingEvents(int id) async {
// //   DateTime now = DateTime.now();
// //   List<Map<String, dynamic>> upcomingEvents = [];

// //   for (var key in _events.keys) {
// //     List<dynamic> dayEvents = _events[key]!;

// //     if (key.year == now.year && key.month == now.month && key.day == now.day) {
// //       for (var event in dayEvents) {
// //         TimeOfDay eventTime = TimeOfDay(
// //           hour: int.parse(event['heureDebut'].split(':')[0]),
// //           minute: int.parse(event['heureDebut'].split(':')[1]),
// //         );

// //         DateTime fullEventDateTime = DateTime(
// //           key.year,
// //           key.month,
// //           key.day,
// //           eventTime.hour,
// //           eventTime.minute,
// //         );

// //         Duration difference = fullEventDateTime.difference(now);

// //         if (difference.inSeconds <= 1800 && difference.inSeconds > 0) {
// //           upcomingEvents.add(event);
// //         }
// //       }
// //     }
// //   }

// //   if (upcomingEvents.isNotEmpty) {
// //     await _showNotification('Événements à venir',
// //         'Vous avez des événements dans les 30 prochaines minutes.');
// //     try {
// //       Api3Service apiService = Api3Service();
// //       List<dynamic> notifs = await apiService.fetchNotifs(id);

// //       for (var event in upcomingEvents) {
// //         Map<String, dynamic> newNotif = {
// //           'animal_id':
// //               (event["animal"] != null && event["animal"]["id"] != null)
// //                   ? event["animal"]["id"]
// //                   : null,
// //           'user_id': (event["user"] != null && event["user"]["id"] != null)
// //               ? event["user"]["id"]
// //               : null,
// //           'titre': event["titre"] ?? '',
// //           'dateEvent': event["dateEvent"] ?? '',
// //           'heureDebut': event["heureDebut"] ?? '',
// //           'heureFin': event["heureFin"] ?? '',
// //           'description': event["description"] ?? '',
// //         };

// //         bool exists = notifs.any((notif) =>
// //             notif["titre"] == newNotif["titre"] &&
// //             notif["dateEvent"] == newNotif["dateEvent"] &&
// //             notif["heureDebut"] == newNotif["heureDebut"]);

// //         if (!exists) {
// //           dynamic response = await apiService.createNotif(newNotif);
// //           print("Notification créée : $response");
// //         } else {
// //           print("Notification déjà existante : ${newNotif['titre']}");
// //         }
// //       }
// //     } catch (e) {
// //       print('Erreur lors de la création des notifications : $e');
// //     }

// //     _nextThreeEvents = upcomingEvents;
// //   } else {
// //     _nextThreeEvents = [];
// //     print("hey");

// //     await _showNotification('Événements à venir',
// //         'Vous \'avez pas d\'événements dans les 30 prochaines minutes.');
// //   }
// // }
