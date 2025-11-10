import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF0A0A0F),
      ),
      body: Center(
        child: Text(
          '$title – w budowie',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
