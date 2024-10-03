import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahingo/screens/forget_password_screen1.dart';
import 'package:mahingo/services/call_api/auth_service.dart';
import 'package:mahingo/services/toggle/bloc/toggle_bloc.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:mahingo/routes/paths.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.vert,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30),
            height: screenHeight * 0.25,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: AppColors.vert,
            ),
            child: Image.asset(
              'assets/images/tetes_bovins.png',
              width: 400,
            ),
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
                        'S\'identifier',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.vert,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextField(
                      controller: _phoneController,
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
                      builder: (context, state) {
                        return TextField(
                          controller: _passwordController,
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
                      },
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final phone = _phoneController.text.trim();
                          final password = _passwordController.text.trim();

                          if (phone.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Veuillez remplir tous les champs'),
                              ),
                            );
                            return;
                          }

                          final success =
                              await _authService.login(phone, password);
                          if (success) {
                            Navigator.pushReplacementNamed(
                                context, AppPaths.home);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Erreur de connexion. Vérifiez vos identifiants.'),
                              ),
                            );
                          }
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
                            MaterialPageRoute(
                                builder: (context) => const PhoneScreen()),
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
