import 'package:flutter/material.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOutSine,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Zewnętrzny pierścień - lekko pulsuje (skalowanie)
            Transform.scale(
              scale: 1.0 + (value * 0.05),
              child: _Ring(
                size: 180,
                color: const Color(0xFF00f0ff),
                opacity: 0.3 - (value * 0.1),
              ),
            ),
            // Środkowy pierścień - obraca się (opcjonalnie)
            _Ring(size: 150, color: const Color(0xFFff00ff), opacity: 0.2),
            // Główny kontener z ikoną i poświatą (Glow)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF00f0ff,
                    ).withValues(alpha: 0.4 + (value * 0.1)),
                    blurRadius: 30 + (value * 10),
                    spreadRadius: 5,
                  ),
                ],
                gradient: const RadialGradient(
                  colors: [Color(0xFF00f0ff), Colors.transparent],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Ring extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  const _Ring({required this.size, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: opacity), width: 2),
      ),
    );
  }
}
