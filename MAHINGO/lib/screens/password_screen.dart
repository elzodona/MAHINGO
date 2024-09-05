import 'package:flutter/material.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:mahingo/routes/paths.dart';


class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

@override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool _obscureText = true;
  bool _obscureText2 = true;


  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _togglePasswordVisibility2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

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
                  TextField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Nouveau mot de passe',
                      prefixIcon: const Icon(Icons.lock, color: AppColors.vert),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.vert,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                      height: 20),
                  TextField(
                    obscureText: _obscureText2,
                    decoration: InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      prefixIcon: const Icon(Icons.lock, color: AppColors.vert),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.vert,
                        ),
                        onPressed: _togglePasswordVisibility2,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
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
