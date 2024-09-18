import 'package:flutter/material.dart';
import 'package:mahingo/screens/code_screen.dart';
import 'package:mahingo/screens/forget_password_screen2.dart';
import 'package:mahingo/utils/colors.dart';


class PhoneScreen extends StatelessWidget {
  const PhoneScreen({super.key});

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
            child: Row(
              children: [
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
                
              ]
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
                        'Mot de passe oublié',
                        style: TextStyle(
                            fontSize: 24,
                            color: AppColors.vert,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Center(
                      child: Text(
                        'Veuillez entrer votre numéro de téléphone pour recevoir le code de réinitialisation',
                        style: TextStyle(
                          color: AppColors.noir,
                          fontSize: 14,
                          // fontWeight: FontWeight.w600
                        ),
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

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MailScreen()),
                          );
                        },
                        child: const Text(
                          'Utilisez plutot votre adresse mail',
                          style: TextStyle(
                            color: AppColors.vert,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),

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
                        child: const Text('Envoyer'),
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
