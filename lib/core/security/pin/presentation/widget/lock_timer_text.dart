import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_notifier.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';
import 'package:obywatel_plus/core/utils/duration_utils.dart';

class LockTimerText extends ConsumerWidget {
  const LockTimerText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Słuchamy stanu weryfikacji - to spowoduje przebudowanie TYLKO tego widgetu
    final state = ref.watch(pinVerificationProvider);

    final remaining = state.maybeWhen(
      locked: (rem) => rem,
      orElse: () => Duration.zero,
    );

    return Text(
      formatDuration(remaining),
      style: const TextStyle(
        color: Color(0xFF00f0ff), // Twój kolor cyber-cyan
        fontSize: 56,
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace', // Ważne dla liczb, żeby nie "skakały"
      ),
    );
  }
}
