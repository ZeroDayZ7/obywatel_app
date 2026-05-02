import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart';

class AppNameSection extends StatelessWidget {
  const AppNameSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
              colorScheme.primary,
            ],
          ).createShader(bounds),
          child: Text(
            apiConstants.appName.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: 250,
          height: 2,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                colorScheme.primary,
                colorScheme.secondary,
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            apiConstants.appDescription.toUpperCase(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 14,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
