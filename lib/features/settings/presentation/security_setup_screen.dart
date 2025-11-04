import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

import 'widgets/biometric_tile.dart';
import 'widgets/info_card.dart';
import 'widgets/pin_setup_dialog.dart';
import 'widgets/pin_tile.dart';
import 'widgets/skip_button.dart';

final localAuthProvider = Provider<LocalAuthentication>((ref) {
  return LocalAuthentication();
});

class SecuritySetupScreen extends ConsumerStatefulWidget {
  const SecuritySetupScreen({super.key});

  @override
  ConsumerState<SecuritySetupScreen> createState() =>
      _SecuritySetupScreenState();
}

class _SecuritySetupScreenState extends ConsumerState<SecuritySetupScreen> {
  bool _pinSet = false;
  bool _biometricAvailable = false;
  bool _biometricSet = false;

  @override
  void initState() {
    super.initState();
    _initSecurityOptions();
  }

  Future<void> _initSecurityOptions() async {
    final logger = ref.read(appLoggerProvider);
    logger.d('SecuritySetup: Inicjalizacja opcji bezpieczeństwa...');
    try {
      final securityService = ref.read(securityServiceProvider.notifier);
      final storage = ref.read(secureStorageProvider);
      final localAuth = ref.read(localAuthProvider);

      _pinSet = await securityService.pinService.hasPin();
      _biometricAvailable = await localAuth.canCheckBiometrics;

      final biometricValue = await storage.read(key: StorageKeys.biometric);
      _biometricSet = biometricValue == 'true';

      if (!mounted) return;
      setState(() {});
      logger.i(
        'SecuritySetup: PIN: $_pinSet, biometria: $_biometricSet, dostępna: $_biometricAvailable',
      );
    } catch (e, st) {
      logger.e('SecuritySetup: Błąd inicjalizacji', error: e, stackTrace: st);
    }
  }

  Future<void> _finishSetup() async {
    final logger = ref.read(appLoggerProvider);
    logger.d('SecuritySetup: Kończenie setupu');
    if (!_pinSet) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Musisz ustawić PIN!')));
      return;
    }

    final securityService = ref.read(securityServiceProvider.notifier);
    await securityService.completeSetup();

    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  Future<void> _skipSetup() async {
    // wywołanie metody przez .notifier
    ref.read(securityServiceProvider.notifier).skipPinSetup();
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  Future<void> _onSetupPin() async {
    final logger = ref.read(appLoggerProvider);
    final result = await showDialog<String>(
      context: context,
      builder: (_) =>
          const Dialog(child: SingleChildScrollView(child: PinSetupDialog())),
    );

    if (result == null || result.isEmpty) return;

    try {
      // wywołanie setPin przez Notifier
      await ref.read(securityServiceProvider.notifier).setPin(result);
      if (!mounted) return;
      setState(() => _pinSet = true);
      logger.i('SecuritySetup: PIN ustawiony');
    } catch (e, st) {
      logger.e('SecuritySetup: Błąd ustawiania PIN', error: e, stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  Future<void> _onSetupBiometric() async {
    final logger = ref.read(appLoggerProvider);
    if (!_pinSet) {
      logger.w('SecuritySetup: Biometria bez PIN – blokada');
      return;
    }

    logger.d('SecuritySetup: Setup biometrii');
    try {
      final localAuth = ref.read(localAuthProvider);
      final storage = ref.read(secureStorageProvider);

      final success = await localAuth.authenticate(
        localizedReason: 'Potwierdź biometrię',
        biometricOnly: true,
      );

      if (!success) {
        logger.w('SecuritySetup: Biometria nieudana');
        return;
      }

      await storage.write(key: StorageKeys.biometric, value: 'true');
      if (!mounted) return;
      setState(() => _biometricSet = true);
      logger.i('SecuritySetup: Biometria włączona');
    } catch (e, st) {
      logger.e('SecuritySetup: Błąd biometrii', error: e, stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie udało się włączyć biometrii')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Ustawienia bezpieczeństwa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const InfoCard(
                icon: Icons.security,
                title: 'Dodatkowe zabezpieczenie',
                description: 'Ustaw PIN lub biometrię...',
              ),
              const SizedBox(height: 30),
              PinTile(pinSet: _pinSet, onSetup: _onSetupPin),
              const SizedBox(height: 20),
              if (_biometricAvailable)
                BiometricTile(
                  enabled: _biometricSet,
                  onSetup: _pinSet ? _onSetupBiometric : () {},
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _pinSet ? _finishSetup : null,
                child: const Text('Zakończ konfigurację'),
              ),
              const SizedBox(height: 20),
              SkipButton(onSkip: _skipSetup),
            ],
          ),
        ),
      ),
    );
  }
}
