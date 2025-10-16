import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
    );
  }
}
