import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinInputView extends StatelessWidget {
  final bool isEnabled;
  final bool isError;
  final int resetToken;
  final StreamController<ErrorAnimationType> errorController;
  final ValueChanged<String> onCompleted;

  const PinInputView({
    super.key,
    required this.isEnabled,
    required this.isError,
    required this.resetToken,
    required this.errorController,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const accent = Color(0xFF00f0ff);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.pinVerification_title.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            LocaleKeys.pinVerification_subtitle.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // PIN
        AbsorbPointer(
          absorbing: !isEnabled,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isEnabled ? 1 : 0.5,
            child: PinCodeTextField(
              key: ValueKey(resetToken),
              appContext: context,
              length: 4,
              obscureText: true,
              blinkWhenObscuring: true,
              autoFocus: true,
              enabled: isEnabled,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              errorAnimationController: errorController,
              cursorColor: accent,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 54,
                fieldWidth: 48,
                borderWidth: 1.5,
                activeColor: accent,
                selectedColor: accent,
                inactiveColor: isError
                    ? AppColors.error
                    : Colors.white.withValues(alpha: 0.15),
                activeFillColor: Colors.transparent,
                selectedFillColor: accent.withValues(alpha: 0.12),
                inactiveFillColor: Colors.transparent,
              ),
              onCompleted: onCompleted,
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}
