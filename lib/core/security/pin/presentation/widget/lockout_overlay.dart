import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

import 'lock_timer_text.dart';

class LockoutOverlay extends StatelessWidget {
  const LockoutOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.85),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.timer_off_outlined,
            color: Colors.redAccent,
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            LocaleKeys.pinVerification_system_locked.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              LocaleKeys.pinVerification_errors_too_many_attempts.tr(
                namedArgs: {'time': ''},
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 40),
          const LockTimerText(),
          const SizedBox(height: 20),
          const SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white10,
              color: Color(0xFF00f0ff),
            ),
          ),
        ],
      ),
    );
  }
}
