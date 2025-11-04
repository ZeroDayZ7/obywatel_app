// lib/features/security/pin_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:obywatel_plus/core/core_providers.dart';

class PinVerificationScreen extends ConsumerStatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  ConsumerState<PinVerificationScreen> createState() =>
      _PinVerificationScreenState();
}

class _PinVerificationScreenState extends ConsumerState<PinVerificationScreen> {
  final _pinController = TextEditingController();
  bool _error = false;
  bool _loading = false;

  Future<void> _verifyPin() async {
    final pin = _pinController.text.trim();
    if (pin.isEmpty) return;

    setState(() {
      _loading = true;
      _error = false;
    });

    final pinService = ref.read(pinServiceProvider);
    final securityService = ref.read(securityServiceProvider.notifier);
    final logger = ref.read(appLoggerProvider);

    try {
      setState(() => _loading = true);

      final isValid = await pinService.verifyPin(pin);
      logger.i('🔐 Weryfikacja PIN: wynik=$isValid');

      if (!mounted) return; // 🧠 kluczowy moment — ochrona po await

      if (isValid) {
        await securityService.unlockApp();

        if (!mounted) return; // 🔒 kolejny bezpiecznik po kolejnym await

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Poprawny PIN — aplikacja odblokowana'),
          ),
        );
      } else {
        setState(() => _error = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Błędny PIN! Spróbuj ponownie.')),
        );
      }
    } catch (e, s) {
      ref
          .read(appLoggerProvider)
          .e('Błąd podczas weryfikacji PIN', error: e, stackTrace: s);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('⚠️ Błąd: ${e.toString()}')));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        _pinController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _loading;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Wprowadź PIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              PinCodeTextField(
                appContext: context,
                controller: _pinController,
                length: 4,
                obscureText: true,
                obscuringCharacter: '•',
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  inactiveColor: _error ? Colors.redAccent : Colors.white24,
                  activeColor: Colors.white,
                  selectedColor: Colors.blueAccent,
                ),
                textStyle: const TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (_) => setState(() => _error = false),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isBusy ? null : _verifyPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isBusy
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'ZATWIERDŹ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
