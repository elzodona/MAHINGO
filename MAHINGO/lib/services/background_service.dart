// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:mahingo/services/call_api/notification_service.dart';
// import 'package:mahingo/services/call_api/event_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';


// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       onForeground: onStart,
//       onBackground: null,
//     ),
//   );

//   service.startService();
// }

// void onStart(ServiceInstance service) async {
//   Timer.periodic(const Duration(minutes: 15), (timer) async {
//     await checkAndSaveUpcomingEvents();
//   });
// }

// Future<void> checkAndSaveUpcomingEvents() async {
//   try {
//     // Charger les événements à partir de l'API
//     int? userId = await _getUserIdFromPrefs();
//     if (userId == null) {
//       print("Utilisateur non trouvé");
//       return;
//     }

//     List<dynamic> events = await Api2Service().fetchEvents(userId);
//     if (events.isEmpty) {
//       print("Aucun événement trouvé");
//       return;
//     }

//     print("Événements récupérés : $events");

//     DateTime now = DateTime.now();
//     Map<String, dynamic>? nextEvent;
//     Duration?
//         shortestDuration; // Pour stocker la plus petite différence de temps

//     for (var event in events) {
//       DateTime eventDate = DateTime.parse(event['dateEvent']);
//       TimeOfDay eventTime = TimeOfDay(
//         hour: int.parse(event['heureDebut'].split(':')[0]),
//         minute: int.parse(event['heureDebut'].split(':')[1]),
//       );

//       DateTime fullEventDateTime = DateTime(
//         eventDate.year,
//         eventDate.month,
//         eventDate.day,
//         eventTime.hour,
//         eventTime.minute,
//       );

//       Duration difference = fullEventDateTime.difference(now);

//       print("Événement : $event, Différence de temps : $difference");

//       // Sélectionner le premier événement qui est dans le futur et qui est le plus proche
//       if (difference > Duration.zero &&
//           (shortestDuration == null || difference < shortestDuration)) {
//         shortestDuration = difference;
//         nextEvent = event;
//       }
//     }

//     if (nextEvent != null) {
//       print("Prochain événement trouvé : $nextEvent");

//       // Sauvegarder l'événement le plus proche sous forme de notification
//       await _saveNotification(nextEvent);
//       print("Notification enregistrée pour l'événement : $nextEvent");
//     } else {
//       print("Aucun événement à venir trouvé");
//     }
//   } catch (e) {
//     print("Erreur lors du chargement des événements : $e");
//   }
// }

// Future<int?> _getUserIdFromPrefs() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   if (prefs.containsKey('user')) {
//     String userString = prefs.getString('user')!;
//     Map<String, dynamic> userData = json.decode(userString);
//     return userData["id"];
//   }
//   return null;
// }

// Future<void> _saveNotification(Map<String, dynamic> event) async {
//   try {
//     Map<String, dynamic> newNotif = {
//       'animal_id': (event["animal"] != null && event["animal"]["id"] != null)
//           ? event["animal"]["id"]
//           : null,
//       'user_id': (event["user"] != null && event["user"]["id"] != null)
//           ? event["user"]["id"]
//           : null,
//       'titre': event["titre"] ?? '',
//       'dateEvent': event["dateEvent"] ?? '',
//       'heureDebut': event["heureDebut"] ?? '',
//       'heureFin': event["heureFin"] ?? '',
//       'description': event["description"] ?? '',
//     };

//     await Api3Service().createNotif(newNotif);
//     print('Notification créée avec succès');

//   } catch (e) {
//     print('Erreur lors de la création de la notification : $e');
//   }
  
// }
