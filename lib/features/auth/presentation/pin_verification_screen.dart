// lib/features/security/pin_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/widgets/ui/app_toast.dart';

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
    final pinLimiter = ref.read(pinAttemptLimiterProvider.notifier);
    final logger = ref.read(appLoggerProvider);

    try {
      // Pobieramy stan limitera po async
      final limiterState = ref.read(pinAttemptLimiterProvider);

      // jeśli zablokowany, od razu pokaż komunikat
      if (limiterState.isLocked) {
        if (!mounted) return;
        final remaining = limiterState.lockUntil!.difference(DateTime.now());
        AppToast.show(
          context,
          message: '❌ Zbyt wiele prób! Spróbuj za ${remaining.inSeconds}s',
          type: ToastType.info,
        );
        return;
      }

      final isValid = await pinService.verifyPin(pin);
      logger.i('🔐 Weryfikacja PIN: wynik=$isValid');

      if (!mounted) return;

      if (isValid) {
        await pinLimiter.reset(); // resetujemy licznik po poprawnym PIN
        await securityService.unlockApp();

        if (!mounted) return;
        AppToast.show(
          context,
          message: '✅ Poprawny PIN — aplikacja odblokowana',
          type: ToastType.success,
        );
      } else {
        await pinLimiter.registerFailedAttempt();
        if (!mounted) return;
        setState(() => _error = true);

        AppToast.show(
          context,
          message: '❌ Błędny PIN! Spróbuj ponownie.',
          type: ToastType.error,
        );
      }
    } catch (e, s) {
      logger.e('Błąd podczas weryfikacji PIN', error: e, stackTrace: s);

      if (!mounted) return;

      AppToast.show(
        context,
        message: '⚠️ Błąd: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _pinController.clear();
        });
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
