import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/utils/duration_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinVerificationScreen extends ConsumerStatefulWidget {
  const PinVerificationScreen({super.key});
  @override
  ConsumerState<PinVerificationScreen> createState() =>
      _PinVerificationScreenState();
}

class _PinVerificationScreenState extends ConsumerState<PinVerificationScreen> {
  // Zmiana tego pola wymusi przebudowanie PinCodeTextField (czyści wpis)
  int _resetToken = 0;

  @override
  void initState() {
    super.initState();

    // Nasłuch stanu PIN (Riverpod). Gdy pojawi się błąd -> resetujemy pole.
    ref.listenManual<PinVerificationState>(pinVerificationProvider, (
      previous,
      next,
    ) {
      if (!mounted) return;

      if (next.lockRemaining != null) {
        final lockText = formatDuration(next.lockRemaining!);
        _showMessage('Zbyt wiele prób! Spróbuj za $lockText');
        HapticFeedback.mediumImpact();
      } else if (next.isError) {
        _showMessage('Błędny PIN! Spróbuj ponownie.', isError: true);
        HapticFeedback.vibrate();
        setState(() {
          _resetToken++; // reset pola i autofocus
        });
      } else if (next.isSuccess) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            ref.read(securityServiceProvider.notifier).confirmUnlock();
          }
        });
      }
    });
  }

  void _showMessage(String text, {bool isError = false}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.redAccent : Colors.blueAccent,
        content: Text(text, style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _verifyPin(String pin) {
    ref.read(pinVerificationProvider.notifier).verifyPin(ref: ref, pin: pin);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pinVerificationProvider);

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

              // key: ValueKey(_resetToken) -> zmiana tokena wymusi pełny rebuild i wyczyszczenie pola
              PinCodeTextField(
                key: ValueKey<int>(_resetToken),
                appContext: context,
                autoFocus: true, // autofocus bez FocusNode
                length: 4,
                obscureText: true,
                obscuringCharacter: '•',
                keyboardType: TextInputType.number,
                animationType: AnimationType.none,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  inactiveColor: state.isError
                      ? Colors.redAccent
                      : Colors.white24,
                  activeColor: Colors.white,
                  selectedColor: Colors.blueAccent,
                ),
                textStyle: const TextStyle(color: Colors.white, fontSize: 20),
                onCompleted: (value) {
                  if (!state.isLoading) {
                    _verifyPin(value);
                  }
                },
                onChanged: (_) {},
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                        // Nie mamy controlleru, więc nic tu nie robimy —
                        // użytkownik może wpisać PIN i nacisnąć "ZATWIERDŹ" (użyj onCompleted lub innego mechanizmu).
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: state.isLoading
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
