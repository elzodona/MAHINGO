import 'package:flutter/material.dart';
import 'package:mahingo/services/toggle/bloc/toggle_bloc.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:mahingo/routes/paths.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

@override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Mot de passe'),
            ),
        body: Column(
          children: [
            // const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(40),
              child: const Center(
                child: Text(
                  "Choisissez un nouveau mot de passe. Les mots de passe les plus efficaces comportent des lettres et chiffres.",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  BlocBuilder<ToggleBloc, ToggleState>(
                    builder: (context, state) {
                      return TextField(
                        obscureText: state.isFirstPasswordObscured,
                        decoration: InputDecoration(
                          labelText: 'Nouveau mot de passe',
                          prefixIcon:
                              const Icon(Icons.lock, color: AppColors.vert),
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isFirstPasswordObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.vert,
                            ),
                            onPressed: () => context
                                .read<ToggleBloc>()
                                .add(ToggleFirstPasswordVisibility()),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ToggleBloc, ToggleState>(
                    builder: (context, state) {
                      return TextField(
                        obscureText: state.isSecondPasswordObscured,
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          prefixIcon:
                              const Icon(Icons.lock, color: AppColors.vert),
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isSecondPasswordObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.vert,
                            ),
                            onPressed: () => context
                                .read<ToggleBloc>()
                                .add(ToggleSecondPasswordVisibility()),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppPaths.login,
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vert,
                  foregroundColor: AppColors.blanc,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Enregistrer'),
              ),
            ),
          ],
        ));
  }
}
