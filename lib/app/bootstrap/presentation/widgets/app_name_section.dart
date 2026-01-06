import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart'; // Upewnij się, że ścieżka do apiConstants jest poprawna

class AppNameSection extends StatelessWidget {
  const AppNameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Nazwa aplikacji z gradientem
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00f0ff), Color(0xFFff00ff), Color(0xFF00f0ff)],
          ).createShader(bounds),
          child: Text(
            apiConstants.appName.toUpperCase(),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Colors.white,
              shadows: [Shadow(color: Color(0xFF00f0ff), blurRadius: 20)],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Neonowe podkreślenie
        Container(
          width: 200,
          height: 2,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFF00f0ff),
                Color(0xFFff00ff),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00f0ff).withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Opis aplikacji (np. "System Bezpieczeństwa Cyfrowego")
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            apiConstants.appDescription.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
