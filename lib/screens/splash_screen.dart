import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';
import 'pin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      bool pinExists = checkIfPinExists(); // <-- Twoja logika sprawdzania PIN-u
      if (pinExists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PinScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  bool checkIfPinExists() {
    // Tutaj np. pobierasz z SharedPreferences lub innego storage
    // Na razie dla testu:
    return true; // <- ustaw false, żeby od razu login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.account_circle, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                "Obywatel+",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Secure Citizen App",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
