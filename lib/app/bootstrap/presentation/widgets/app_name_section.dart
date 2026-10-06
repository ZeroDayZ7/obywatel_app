import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';

class AppNameSection extends StatelessWidget {
  const AppNameSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

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
              color: colorScheme.primary,
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
            style: textTheme.titleLarge?.copyWith(
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
