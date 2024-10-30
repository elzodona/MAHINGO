import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:mahingo/routes/routes.dart';
import 'package:mahingo/routes/paths.dart';
import 'package:mahingo/services/call_api/event_service.dart';
import 'package:mahingo/services/toggle/bloc/toggle_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Map<DateTime, List<dynamic>> _events = {};
// int id = 3;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('fr_FR', null);

  // tz.initializeTimeZones();

  // var initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');
  // var initializationSettings =
  //     InitializationSettings(android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Workmanager().registerPeriodicTask(
  //   "1",
  //   "checkUpcomingEventsTask",
  //   frequency: Duration(minutes: 15),
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ToggleBloc(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppPaths.start,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

// callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     await _loadUserInfo();
//     return Future.value(true);
//   });
// }

// Future<void> scheduleNotification(
//     String title, String body, DateTime time) async {
//   var androidDetails = const AndroidNotificationDetails(
//     'channel_id',
//     'channel_name',
//     importance: Importance.high,
//     priority: Priority.high,
//   );
//   var generalNotificationDetails = NotificationDetails(android: androidDetails);

//   int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
//   await flutterLocalNotificationsPlugin.show(
//     notificationId,
//     title,
//     body,
//     const NotificationDetails(
//         android: AndroidNotificationDetails(
//       'debug_channel',
//       'Debug Channel',
//       importance: Importance.high,
//       priority: Priority.high,
//     )),
//   );
// }

// Future<void> _loadUserInfo() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   if (prefs.containsKey('user')) {
//     String userString = prefs.getString('user')!;
//     Map<String, dynamic> userData = json.decode(userString);
//     id = userData["id"];

//     await _loadEvents(id);
//     await _getUpcomingEvents();
//   } else {
//     print('Aucun utilisateur trouvé dans les préférences partagées');
//   }
// }

// Future<void> _loadEvents(int id) async {
//   print('Début du chargement des événements pour l\'utilisateur : $id');
//   try {
//     Api2Service apiService = Api2Service();
//     List<dynamic> events = await apiService.fetchEvents(id);

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
//     print('Événements récupérés : $_events');
//   } catch (e) {
//     print('Erreur : $e');
//   }
// }

// Future<void> _getUpcomingEvents() async {
//   print('Chargement des événements à venir...');

//   DateTime now = DateTime.now();
//   List<Map<String, dynamic>> upcomingEvents = [];

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

//         if (difference.inSeconds <= 1800 && difference.inSeconds > 0) {
//           upcomingEvents.add(event);
//         }
//       }
//     }
//   }

//   if (upcomingEvents.isNotEmpty) {
//     for (var event in upcomingEvents) {
//       String title = event["titre"] ?? "Événement à venir";
//       String body = event["description"] ?? "Un événement est prévu sous peu.";

//       if (title.isNotEmpty && body.isNotEmpty) {
//         await scheduleNotification(
//           title,
//           body,
//           DateTime.parse(event['dateEvent']).add(
//             Duration(
//               hours: int.parse(event['heureDebut'].split(':')[0]),
//               minutes: int.parse(event['heureDebut'].split(':')[1]),
//             ),
//           ),
//         );
//       } else {
//         await scheduleNotification(
//           "title",
//           "body",
//           DateTime.parse(event['dateEvent']).add(
//             Duration(
//               hours: int.parse(event['heureDebut'].split(':')[0]),
//               minutes: int.parse(event['heureDebut'].split(':')[1]),
//             ),
//           ),
//         );
//       }
//     }
//   }
// }
