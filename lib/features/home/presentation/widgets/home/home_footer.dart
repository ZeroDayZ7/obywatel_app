import 'package:flutter/material.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 31, 46, 36), width: 1),
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.shield, color: Color(0xFF00FF88), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Połączenie zabezpieczone • Szyfrowanie E2E',
              style: TextStyle(
                color: Color(0xFF6B6B7A),
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
