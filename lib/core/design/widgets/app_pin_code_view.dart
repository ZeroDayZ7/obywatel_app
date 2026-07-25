import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/design/widgets/ui/glow_icon.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AppPinCodeView extends StatelessWidget {
  final String titleKey;
  final String subtitleKey;
  final String buttonKey;
  final IconData icon;
  final int length;
  final bool isLoading;
  final bool isError;
  final int resetToken;
  final StreamController<ErrorAnimationType>? errorController;
  final Function(String) onCompleted;
  final VoidCallback? onButtonPressed;

  const AppPinCodeView({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
    required this.buttonKey,
    required this.icon,
    this.length = 4,
    required this.isLoading,
    required this.isError,
    required this.resetToken,
    this.errorController,
    required this.onCompleted,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppGlowIcon(icon: icon, color: const Color(0xFF00f0ff)),
        const SizedBox(height: 32),
        Text(
          titleKey.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitleKey.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 40),

        SizedBox(
          width: length == 4 ? 280 : 340,
          child: PinCodeTextField(
            key: ValueKey<int>(resetToken),
            appContext: context,
            length: length,
            obscureText: length == 4,
            autoFocus: true,
            enabled: !isLoading,
            
            keyboardType: TextInputType.number,
            animationType: AnimationType.scale,
            errorAnimationController: errorController,
            cursorColor: const Color(0xFF00f0ff),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(12),
              fieldHeight: 60,
              fieldWidth: length == 4 ? 60 : 45,
              borderWidth: 2,
              activeColor: const Color(0xFF00f0ff),
              selectedColor: const Color(0xFF00f0ff),
              inactiveColor: isError
                  ? AppColors.error
                  : Colors.white.withValues(alpha: 0.1),
              activeFillColor: Colors.transparent,
              selectedFillColor: const Color(
                0xFF00f0ff,
              ).withValues(alpha: 0.05),
            ),
            beforeTextPaste: (text) {
              // Pozwalamy na wklejanie.
              // Możesz tu dodać logikę sprawdzającą np. czy text to same cyfry.
              return true;
            },
            onCompleted: onCompleted,
            onChanged: (_) {},
          ),
        ),

        const SizedBox(height: 48),
        AppButton(
          label: buttonKey.tr(),
          onPressed: isLoading ? null : onButtonPressed,
          isLoading: isLoading,
          fullWidth: true,
        ),
      ],
    );
  }
}
