import 'package:flutter/material.dart';
import 'package:mahingo/routes/routes.dart';
import 'package:mahingo/routes/paths.dart';
import 'package:mahingo/services/toggle/bloc/toggle_bloc.dart';
import 'package:mahingo/services/background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('fr_FR', null);
  // WidgetsFlutterBinding.ensureInitialized();
  // initializeService();
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


// import 'package:flutter/material.dart';
// import 'package:mahingo/routes/routes.dart';
// import 'package:mahingo/routes/paths.dart';
// import 'package:mahingo/services/toggle/bloc/toggle_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:provider/provider.dart';
// import 'models/event_mod.dart';
// import 'services/background_service.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:io';


// // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //     FlutterLocalNotificationsPlugin();


// // void callbackDispatcher() {
// //   Workmanager().executeTask((task, inputData) async {
// //     // Logique de ta tâche
// //     print("Tâche exécutée : $task");
// //     // Appelle la fonction qui gère les notifications
// //     await _showNotification('Titre', 'Corps de la notification');
// //     return Future.value(true);
// //   });
// // }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Configuration des notifications
//   // const AndroidInitializationSettings initializationSettingsAndroid =
//   //     AndroidInitializationSettings('@mipmap/ic_launcher');
//   // final InitializationSettings initializationSettings =
//   //     InitializationSettings(android: initializationSettingsAndroid);
//   // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   // // Initialisation de Workmanager pour le travail en arrière-plan
//   // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

//   // // Enregistrement d'une tâche périodique qui s'exécutera toutes les 15 minutes
//   // Workmanager().registerPeriodicTask(
//   //   "1",
//   //   "simpleTask",
//   //   frequency: const Duration(minutes: 2),
//   // );

//   runApp(MyApp());
// }


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (BuildContext context) => ToggleBloc(),
//         )
//       ],
//       child: const MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: AppPaths.start,
//         onGenerateRoute: AppRoutes.generateRoute,
//       ),
//     );
//   }
// }

// // Future<void> _showNotification(String title, String body) async {
// //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //       AndroidNotificationDetails(
// //     'mahingo_channel',
// //     'Notifications des événements de Mahingo',
// //     channelDescription:
// //         'Ce canal envoie des notifications pour les événements et rappels concernant les animaux.',
// //     importance: Importance.max,
// //     priority: Priority.high,
// //   );
// //   const NotificationDetails platformChannelSpecifics =
// //       NotificationDetails(android: androidPlatformChannelSpecifics);
// //   await flutterLocalNotificationsPlugin.show(
// //     0,
// //     title,
// //     body,
// //     platformChannelSpecifics,
// //     payload: 'item x',
// //   );
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Test Notifications',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: const NotificationTestPage(), // Page de test
// //     );
// //   }
// // }

// // Page de test des notifications avec un bouton
// // class NotificationTestPage extends StatelessWidget {
// //   const NotificationTestPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Test Notifications'),
// //       ),
// //       body: Center(
// //         child: ElevatedButton(
// //           onPressed: () {
// //             _showNotification(
// //                 'Test Notification', 'Ceci est une notification de test.');
// //           },
// //           child: const Text('Envoyer Notification'),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // Future<void> _showNotification(String title, String body) async {
// //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //       AndroidNotificationDetails(
// //     'mahingo_channel',
// //     'Notifications des événements de Mahingo',
// //     channelDescription:
// //         'Ce canal envoie des notifications pour les événements et rappels concernant les animaux.',
// //     importance: Importance.max,
// //     priority: Priority.high,
// //   );
// //   const NotificationDetails platformChannelSpecifics =
// //       NotificationDetails(android: androidPlatformChannelSpecifics);
// //   await flutterLocalNotificationsPlugin.show(
// //     0,
// //     title,
// //     body,
// //     platformChannelSpecifics,
// //     payload: 'item x',
// //   );
// // }
