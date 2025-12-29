import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinInputView extends StatelessWidget {
  final bool isLoading;
  final bool isError;
  final int resetToken;
  final StreamController<ErrorAnimationType> errorController;
  final Function(String) onCompleted;

  const PinInputView({
    super.key,
    required this.isLoading,
    required this.isError,
    required this.resetToken,
    required this.errorController,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLockIcon(),
        const SizedBox(height: 40),
        Text(
          LocaleKeys.pinVerification_title.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(height: 50),
        _buildPinField(context),
        const SizedBox(height: 60),
        // Wykorzystanie AppButton bez zbędnych kontenerów
        AppButton(
          labelKey: LocaleKeys
              .pinVerification_unlock_button, // Przekazujemy klucz (enterprise zazwyczaj tak robi)
          onPressed: isLoading
              ? null
              : () {
                  // Logika ręcznego odblokowania, jeśli potrzebna
                },
          isLoading: isLoading,
        ),
      ],
    );
  }

  Widget _buildLockIcon() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF00f0ff).withValues(alpha: 0.05),
        border: Border.all(
          color: const Color(0xFF00f0ff).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00f0ff).withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.lock_person_outlined,
        size: 50,
        color: Color(0xFF00f0ff),
      ),
    );
  }

  Widget _buildPinField(BuildContext context) {
    // Naprawiony błąd lintera: Usunięto niepotrzebny Container
    return SizedBox(
      width: 280,
      child: PinCodeTextField(
        key: ValueKey<int>(resetToken),
        appContext: context,
        length: 4,
        obscureText: true,
        blinkWhenObscuring: true,
        autoFocus: true,
        keyboardType: TextInputType.number,
        animationType: AnimationType.scale,
        errorAnimationController: errorController,
        cursorColor: const Color(0xFF00f0ff),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(16),
          fieldHeight: 65,
          fieldWidth: 55,
          borderWidth: 2,
          activeColor: const Color(0xFF00f0ff),
          selectedColor: const Color(0xFF00f0ff),
          inactiveColor: isError
              ? AppColors.error
              : Colors.white.withValues(alpha: 0.1),
          activeFillColor: Colors.transparent,
          selectedFillColor: const Color(0xFF00f0ff).withValues(alpha: 0.05),
          inactiveFillColor: Colors.transparent,
        ),
        onCompleted: onCompleted,
        onChanged: (_) {},
      ),
    );
  }
}
