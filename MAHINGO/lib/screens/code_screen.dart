import 'dart:async'; // Importer pour utiliser Timer
import 'package:flutter/material.dart';
import 'package:mahingo/screens/password_screen.dart';
import 'package:mahingo/utils/colors.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  int _start = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resendCode() {
    setState(() {
      _start = 30;
    });
    _startTimer();
  }

  @override
    Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.vert,
      body: Column(
        children: [
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
                        'Vérification',
                        style: TextStyle(
                            fontSize: 24,
                            color: AppColors.vert,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Center(
                      child: Text(
                        'Veuillez saisir le code de réinitialisation reçu',
                        style: TextStyle(
                          color: AppColors.noir,
                          fontSize: 14,
                          // fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCodeBox(context),
                        _buildCodeBox(context),
                        _buildCodeBox(context),
                        _buildCodeBox(context),
                      ],
                    ),
                    const SizedBox(height: 10),
                                Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: _start == 0 ? _resendCode : null,
                        child: Text(
                          _start == 0
                              ? 'Renvoyer le code'
                              : 'Renvoyer le code dans 0:${_start.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: AppColors.vert,
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
                                builder: (context) => const PasswordScreen()),
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
                        child: const Text('Valider'),
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

  Widget _buildCodeBox(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.blanc,
        boxShadow: [
          BoxShadow(
            color: AppColors.gris,
            spreadRadius: 1.5,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusColor: AppColors.vert,
            counterText: '',
          ),
          style: const TextStyle(fontSize: 24),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty) {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }

}
