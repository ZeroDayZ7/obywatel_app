import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/utils/duration_utils.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/features/auth/application/pin_verification_provider.dart';

class PinVerificationScreen extends ConsumerStatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  ConsumerState<PinVerificationScreen> createState() =>
      _PinVerificationScreenState();
}

class _PinVerificationScreenState extends ConsumerState<PinVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // 🎞️ Shake animation setup
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 24,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    // 🧭 Auto focus po wejściu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _resetInput() {
    _pinController.clear();
    _pinFocusNode.requestFocus();
  }

  void _verifyPin(String pin) {
    ref.read(pinVerificationProvider.notifier).verifyPin(ref: ref, pin: pin);
  }

  void _showMessage(BuildContext context, String text, {bool isError = false}) {
    if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pinVerificationProvider);

    // 👂 Słuchacz zmian stanu
    ref.listen(pinVerificationProvider, (previous, next) async {
      if (!mounted) return;

      if (next.lockRemaining != null) {
        final lockText = formatDuration(next.lockRemaining!);
        _showMessage(context, 'Zbyt wiele prób! Spróbuj za $lockText');
        HapticFeedback.mediumImpact();
        _resetInput();
      } else if (next.isError) {
        _showMessage(context, 'Błędny PIN! Spróbuj ponownie.', isError: true);
        HapticFeedback.vibrate();
        _shakeController.forward(from: 0);
        await Future.delayed(const Duration(milliseconds: 350));
        _resetInput();
      } else if (!next.isSuccess) {
        // ✔️ weryfikacja poprawna, ale jeszcze bez redirectu
        await Future.delayed(const Duration(milliseconds: 300));
      } else if (next.isSuccess) {
        if (mounted) context.go(AppRoutes.home);
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            final offset = _shakeAnimation.value;
            return Transform.translate(
              offset: Offset(offset - 12, 0),
              child: child,
            );
          },
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
                  focusNode: _pinFocusNode,
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
                  onChanged: (value) {
                    if (value.length == 4 && !state.isLoading) {
                      _verifyPin(value);
                    }
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          final pin = _pinController.text.trim();
                          if (pin.isNotEmpty) {
                            _verifyPin(pin);
                          }
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
      ),
    );
  }
}
