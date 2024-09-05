import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahingo/screens/forget_password_screen1.dart';
import 'package:mahingo/services/toggle/bloc/toggle_bloc.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:mahingo/routes/paths.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // bool _obscureText = true;

  // void _togglePasswordVisibility() {
  //   setState(() {
  //     _obscureText = !_obscureText;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.blanc,
              AppColors.vert,
            ],
            stops: [0.3, 0.3],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30),
              height: 200,
              child: Image.asset(
                'assets/images/tetes_bovins.png',
                width: 400,
                // height: 200,
              ),
              decoration: const BoxDecoration(
                color: AppColors.vert,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 602,
                  decoration: const BoxDecoration(
                    color: AppColors.blanc,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(70),
                      // topLeft: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        'S\'identifier',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.noir,
                        ),
                      ),
                      const SizedBox(height: 50),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          prefixIcon:
                              const Icon(Icons.phone, color: AppColors.vert),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<ToggleBloc, ToggleState>(
                          builder: (content, state) {
                        // print(state);
                        return TextField(
                          obscureText: state.isFirstPasswordObscured,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
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
                      }),
                      const SizedBox(height: 50),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppPaths.home);
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
                          child: const Text('Se connecter'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PhoneScreen()),
                            );
                          },
                          child: const Text(
                            'Mot de passe oublié?',
                            style: TextStyle(
                              color: AppColors.vert,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 30),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Text('Vous n\'avez pas de compte?'),
                      //     TextButton(
                      //       onPressed: () {
                      //         // Code pour inscription
                      //       },
                      //       child: const Text(
                      //         'S\'inscrire',
                      //         style: TextStyle(
                      //           color: AppColors.vert,
                      //           decoration: TextDecoration.underline,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
