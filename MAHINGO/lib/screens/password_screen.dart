import 'package:flutter/material.dart';
import 'package:mahingo/screens/login_screen.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.vert,
      body: Column(
        children: [
          // const Spacer(),

          Container(
            height: screenHeight * 0.25,
            width: screenWidth,
            child: Row(children: [
              Container(
                width: screenWidth * 0.2,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.blanc),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                width: screenWidth * 0.7,
                child: Image.asset(
                  'assets/images/tetes_bovins.png',
                  width: 400,
                ),
              )
            ]),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: screenHeight * 0.75,
                decoration: const BoxDecoration(
                  color: AppColors.blanc,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Center(
                      child: Text(
                        'Nouveau mot de passe',
                        style: TextStyle(
                            fontSize: 24,
                            color: AppColors.vert,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 50),
                    
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
                
                    const SizedBox(height: 100),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
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
                        child: const Text('Se connecter'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

