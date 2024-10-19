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
