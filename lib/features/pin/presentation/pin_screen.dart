// lib/features/pin/presentation/pin_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Nowy import: dla Consumer
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../app/theme/app_colors.dart'; // Dostosuj ścieżkę
import '../../../../auth/presentation/login_screen.dart'; // Dostosuj
import '../providers/pin_provider.dart'; // Nowy import: twój provider

class PinScreen extends ConsumerStatefulWidget {
  // Zmień na ConsumerStatefulWidget
  const PinScreen({
    super.key,
  }); // Usuń required pinService – ref.watch to obsłuży

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  // Zmień na ConsumerState
  final TextEditingController _pinController = TextEditingController();
  late StreamController<ErrorAnimationType> _errorController;

  @override
  void initState() {
    super.initState();
    _errorController = StreamController<ErrorAnimationType>();
    // Nie ładujemy niczego tu – serwis zrobi to w verifyPin()
  }

  @override
  void dispose() {
    _errorController.close();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyPin() async {
    final pin = _pinController.text;
    if (pin.isEmpty) {
      _showError('Wprowadź PIN');
      return;
    }

    // Pobierz serwis via ref (z Riverpod)
    final pinService = ref.read(
      pinServiceProvider,
    ); // Lub ref.watch, jeśli chcesz reaktywność
    final isValid = await pinService.verifyPin(pin);

    if (isValid) {
      if (mounted) {
        // Przekazanie dalej: nawigacja (użyj GoRouter.contextOf(context).go('/login') jeśli chcesz)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } else {
      _showError('Niepoprawny PIN');
    }
  }

  void _showError(String message) {
    _errorController.add(ErrorAnimationType.shake);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
    }
    _pinController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // ref jest dostępny tu automatycznie dzięki ConsumerStatefulWidget

    final theme = Theme.of(context);

    Color white20 = Colors.white.withAlpha((0.2 * 255).toInt());
    Color white70 = Colors.white.withAlpha((0.7 * 255).toInt());

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.primaryColor.withAlpha(220), theme.primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Wprowadź PIN",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  errorAnimationController: _errorController,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    activeColor: Colors.white,
                    selectedColor: white70,
                    inactiveColor: Colors.white38,
                    activeFillColor: white20,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onChanged: (_) {}, // Opcjonalnie: debounce + auto-verify
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _verifyPin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Odblokuj",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Anuluj",
                    style: TextStyle(
                      color: white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
