import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.pinVerification_title.tr(),
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            LocaleKeys.pinVerification_subtitle.tr(),
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 32),
        AbsorbPointer(
          absorbing: !isEnabled,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isEnabled ? 1.0 : 0.5,
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
              cursorColor: colorScheme.primary,
              mainAxisAlignment: MainAxisAlignment.center,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(6),
                fieldHeight: 48,
                fieldWidth: 40,
                fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 4),
                borderWidth: 2,
                activeColor: colorScheme.primary,
                selectedColor: colorScheme.primary,
                inactiveColor: isError
                    ? colorScheme.error
                    : colorScheme.outlineVariant,
                activeFillColor: colorScheme.surfaceContainerHighest,
                selectedFillColor: colorScheme.primaryContainer,
                inactiveFillColor: colorScheme.surface,
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
