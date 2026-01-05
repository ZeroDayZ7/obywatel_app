import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart'; // Import Twojego enuma
import 'package:obywatel_plus/core/design/widgets/responsive_content_wrapper.dart'; // Import Twojego ResponsiveContainer

import 'lock_timer_text.dart';

class LockoutOverlay extends StatelessWidget {
  const LockoutOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.92),
      child: ResponsiveContainer(
        size: ContainerSize.narrow,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.timer_off_outlined,
              color: Colors.redAccent,
              size: 80,
            ),
            const SizedBox(height: 32),
            Text(
              LocaleKeys.pinVerification_system_locked.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: LockReasonText(),
            ),
            const SizedBox(height: 48),
            const LockTimerText(),
            const SizedBox(height: 32),
            const SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white10,
                color: Color(0xFF00f0ff),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
