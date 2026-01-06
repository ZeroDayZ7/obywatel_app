import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class LoadingSection extends StatelessWidget {
  const LoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00f0ff)),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          LocaleKeys.system_initialization.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
            color: Color(0xFF00f0ff),
          ),
        ),
      ],
    );
  }
}
