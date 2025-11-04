import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/security/security_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/app/di/injector.dart';

import 'widgets/pin_tile.dart';
import 'widgets/biometric_tile.dart';
import 'widgets/pin_setup_dialog.dart';
import 'widgets/info_card.dart';
import 'widgets/skip_button.dart';

class SecuritySetupScreen extends ConsumerStatefulWidget {
  const SecuritySetupScreen({super.key});

  @override
  ConsumerState<SecuritySetupScreen> createState() =>
      _SecuritySetupScreenState();
}

class _SecuritySetupScreenState extends ConsumerState<SecuritySetupScreen> {
  final _storage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();

  bool _pinSet = false;
  bool _biometricAvailable = false;
  bool _biometricSet = false;

  late final AppLogger _logger;

  @override
  void initState() {
    super.initState();
    _logger = sl<AppLogger>(); // Fix: Inicjalizuj z DI
    _initSecurityOptions();
  }

  Future<void> _initSecurityOptions() async {
    _logger.d('SecuritySetup: Inicjalizacja opcji bezpieczeństwa...');
    try {
      final securityService = ref.read(securityServiceProvider);
      _pinSet = await securityService.pinService.hasPin();
      final biometric = await _storage.read(key: StorageKeys.biometric);
      _biometricAvailable = await _localAuth.canCheckBiometrics;

      if (!mounted) return;
      setState(() {
        _biometricSet = biometric == 'true';
      });

      _logger.i(
        'SecuritySetup: PIN: $_pinSet, biometria: $_biometricSet, dostępna: $_biometricAvailable',
      );
    } catch (e, st) {
      _logger.e('SecuritySetup: Błąd inicjalizacji', error: e, stackTrace: st);
    }
  }

  Future<void> _finishSetup() async {
    _logger.d('SecuritySetup: Kończenie setupu');
    if (!_pinSet) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Musisz ustawić PIN!')));
      return;
    }

    final securityService = ref.read(securityServiceProvider);
    await securityService.completeSetup();

    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  Future<void> _skipSetup() async {
    _logger.i('SecuritySetup: Skip setup');
    ref.read(securityServiceProvider).skipPinSetup();
    if (!mounted) return;
    if (context.mounted) {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _onSetupPin() async {
    _logger.d('SecuritySetup: Otwieram dialog PIN');
    final result = await showDialog<String>(
      context: context,
      builder: (_) =>
          const Dialog(child: SingleChildScrollView(child: PinSetupDialog())),
    );

    if (result == null || result.isEmpty) return;

    try {
      await ref.read(securityServiceProvider).setPin(result);

      if (!mounted) return;
      setState(() => _pinSet = true);
      _logger.i('SecuritySetup: PIN ustawiony');
    } catch (e, s) {
      _logger.e('SecuritySetup: Błąd ustawiania PIN', error: e, stackTrace: s);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  Future<void> _onSetupBiometric() async {
    if (!_pinSet) {
      _logger.w('SecuritySetup: Biometria bez PIN – blokada');
      return;
    }

    _logger.d('SecuritySetup: Setup biometrii');
    try {
      final success = await _localAuth.authenticate(
        localizedReason: 'Potwierdź biometrię',
        biometricOnly: true,
      );

      if (!success) {
        _logger.w('SecuritySetup: Biometria nieudana');
        return;
      }

      await _storage.write(key: StorageKeys.biometric, value: 'true');
      if (!mounted) return;
      setState(() => _biometricSet = true);
      _logger.i('SecuritySetup: Biometria włączona');
    } catch (e, s) {
      _logger.e('SecuritySetup: Błąd biometrii', error: e, stackTrace: s);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nie udało się włączyć biometrii')),
        );
      }
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
