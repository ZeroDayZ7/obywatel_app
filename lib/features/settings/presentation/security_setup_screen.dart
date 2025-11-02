import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/config/storage_keys.dart';
import 'package:obywatel_plus/core/security/security_service_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _initSecurityOptions();
  }

  Future<void> _initSecurityOptions() async {
    final pin = await _storage.read(key: StorageKeys.pinHash);
    final biometric = await _storage.read(key: StorageKeys.biometric);
    final canCheckBiometrics = await _localAuth.canCheckBiometrics;

    if (!mounted) return;
    setState(() {
      _pinSet = pin != null && pin.isNotEmpty;
      _biometricSet = biometric == 'true';
      _biometricAvailable = canCheckBiometrics;
    });
  }

  Future<void> _finishSetup() async {
    if (!_pinSet) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Musisz ustawić PIN, inaczej będziesz się logował za każdym razem!',
          ),
        ),
      );
      return;
    }

    final pin = await _storage.read(key: StorageKeys.pinHash);
    if (pin != null && pin.isNotEmpty) {
      await ref.read(securityServiceProvider).setPin(pin);
    }

    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  Future<void> _skipSetup() async {
    ref.read(securityServiceProvider).skipPinSetup();
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  void _onSetupPin() {
    showDialog<String>(
      context: context,
      builder: (_) =>
          Dialog(child: SingleChildScrollView(child: PinSetupDialog())),
    ).then((result) async {
      if (result != null && result.isNotEmpty) {
        await _storage.write(key: StorageKeys.pinHash, value: result);
        if (!mounted) return;
        setState(() => _pinSet = true);
      }
    });
  }

  Future<void> _onSetupBiometric() async {
    if (!_pinSet) return;

    try {
      final success = await _localAuth.authenticate(
        localizedReason: 'Potwierdź biometrię, aby włączyć blokadę',
        biometricOnly: true,
      );

      if (!success) return;

      await _storage.write(key: StorageKeys.biometric, value: 'true');

      if (!mounted) return;
      setState(() => _biometricSet = true);
    } catch (_) {
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
                description:
                    'Ustaw PIN lub biometrię, aby chronić dostęp do aplikacji. '
                    'Możesz pominąć, ale będziesz musiał logować się przy każdym uruchomieniu.',
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
