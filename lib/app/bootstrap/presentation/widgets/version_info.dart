import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/constants_dev.dart';

class VersionInfo extends StatelessWidget {
  const VersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    const config = ApiConstants();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.shield_outlined, size: 14, color: Colors.white30),
        const SizedBox(width: 8),
        Text(
          'SECURE CONNECTION v${config.appVersion}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
