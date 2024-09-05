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
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Entrez le code qui vous a été envoyé",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "Code",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.vert,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCodeBox(context),
                _buildCodeBox(context),
                _buildCodeBox(context),
                _buildCodeBox(context),
              ],
            ),
            const SizedBox(height: 90),
            ElevatedButton(
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
              child: const Text('Continuer'),
            ),
            const SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBox(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
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
    );
  }
}
