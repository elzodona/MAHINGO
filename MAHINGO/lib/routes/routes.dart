import 'package:flutter/material.dart';
import 'package:mahingo/screens/home_screen.dart';
import 'package:mahingo/screens/animals_screen.dart';
import 'package:mahingo/screens/location_screen.dart';
import 'package:mahingo/screens/events_screen.dart';
import 'package:mahingo/screens/settings_screen.dart';
import 'package:mahingo/screens/login_screen.dart';
import 'package:mahingo/routes/paths.dart';
import 'package:mahingo/screens/starting_screen.dart';


class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppPaths.start:
        return MaterialPageRoute(builder: (_) => const StartingScreen());
      case AppPaths.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppPaths.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppPaths.animals:
        return MaterialPageRoute(builder: (_) => const AnimalsScreen());
      case AppPaths.location:
        return MaterialPageRoute(builder: (_) => LocationScreen());
      case AppPaths.events:
        return MaterialPageRoute(builder: (_) => const EventsScreen());
      case AppPaths.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
