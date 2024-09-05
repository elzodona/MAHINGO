import 'package:flutter/material.dart';
import 'package:mahingo/screens/code_screen.dart';
import 'package:mahingo/screens/forget_password_screen1.dart';
import 'package:mahingo/utils/colors.dart';

class MailScreen extends StatelessWidget {
  const MailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // title: const Text('Nouvelle Page'),
            ),
        body: Column(
          children: [
            const SizedBox(height: 70),
            const Center(
              child: Text(
                "Entrer votre adresse email",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(40),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email, color: AppColors.vert),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CodeScreen()),
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
                child: const Text('Continuer'),
              ),
            ),
            const SizedBox(height: 50),
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
                  'Utilisez plutot votre numéro de téléphone',
                  style: TextStyle(
                    color: AppColors.vert,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
