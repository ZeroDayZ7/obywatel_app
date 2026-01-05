import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_notifier.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';
import 'package:obywatel_plus/core/utils/duration_utils.dart';

class LockTimerText extends ConsumerWidget {
  const LockTimerText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pinVerificationProvider);

    final remaining = state.maybeWhen(
      locked: (rem) => rem,
      orElse: () => Duration.zero,
    );

    return Text(
      formatDuration(remaining),
      style: const TextStyle(
        color: Color(0xFF00f0ff),
        fontSize: 56,
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace',
      ),
    );
  }
}

class LockReasonText extends ConsumerWidget {
  const LockReasonText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Słuchamy tylko zmian w pinVerificationProvider
    final state = ref.watch(pinVerificationProvider);
    final remaining = state.maybeWhen(
      locked: (rem) => formatDuration(rem),
      orElse: () => "0s",
    );

    return Text(
      LocaleKeys.pinVerification_errors_too_many_attempts.tr(
        namedArgs: {'time': remaining},
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white70),
    );
  }
}
