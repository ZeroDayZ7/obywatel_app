import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';

class SecuritySetupScreen extends StatefulWidget {
  const SecuritySetupScreen({super.key});

  @override
  State<SecuritySetupScreen> createState() => _SecuritySetupScreenState();
}

class _SecuritySetupScreenState extends State<SecuritySetupScreen> {
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
    // 1️⃣ Sprawdzenie zapisanych ustawień
    final pin = await _storage.read(key: 'user_pin');
    final biometric = await _storage.read(key: 'biometric');

    // 2️⃣ Sprawdzenie dostępności biometrii
    final canCheckBiometrics = await _localAuth.canCheckBiometrics;

    setState(() {
      _pinSet = pin != null && pin.isNotEmpty;
      _biometricSet = biometric == 'true';
      _biometricAvailable = canCheckBiometrics;
    });
  }

  Future<void> _setupPin() async {
    final pin = await showDialog<String>(
      context: context,
      builder: (_) => _PinSetupDialog(),
    );

    if (pin != null && pin.isNotEmpty) {
      await _storage.write(key: 'user_pin', value: pin);
      setState(() => _pinSet = true);
    }
  }

  Future<void> _setupBiometric() async {
    try {
      final success = await _localAuth.authenticate(
        localizedReason: 'Potwierdź biometrię, aby włączyć blokadę',
        biometricOnly: true,
      );

      if (success) {
        await _storage.write(key: 'biometric', value: 'true');
        setState(() => _biometricSet = true);
      }
    } on PlatformException catch (e) {
      debugPrint('Biometric setup failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie udało się ustawić biometrii')),
      );
    }
  }

  void _finishSetup() {
    if (!_pinSet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Musisz najpierw ustawić PIN')),
      );
      return;
    }
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia bezpieczeństwa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ustaw swoje zabezpieczenia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // 🔹 Sekcja PIN
            ListTile(
              leading: const Icon(Icons.lock),
              title: Text(_pinSet ? 'PIN ustawiony' : 'Ustaw PIN'),
              trailing: ElevatedButton(
                onPressed: _pinSet ? null : _setupPin,
                child: const Text('Ustaw'),
              ),
            ),
            const SizedBox(height: 20),
            // 🔹 Sekcja Biometria
            if (_biometricAvailable)
              ListTile(
                leading: const Icon(Icons.fingerprint),
                title: Text(
                  _biometricSet ? 'Biometria włączona' : 'Włącz biometrię',
                ),
                trailing: ElevatedButton(
                  onPressed: _biometricSet ? null : _setupBiometric,
                  child: const Text('Włącz'),
                ),
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _pinSet ? _finishSetup : null,
              child: const Text('Zakończ konfigurację'),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Dialog do ustawiania PIN
class _PinSetupDialog extends StatefulWidget {
  @override
  State<_PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<_PinSetupDialog> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  void _submit() {
    if (_pinController.text.length < 4) {
      setState(() => _error = 'PIN musi mieć minimum 4 cyfry');
      return;
    }
    if (_pinController.text != _confirmController.text) {
      setState(() => _error = 'PINy nie są zgodne');
      return;
    }
    Navigator.of(context).pop(_pinController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ustaw PIN'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'PIN'),
          ),
          TextField(
            controller: _confirmController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Potwierdź PIN'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Zapisz')),
      ],
    );
  }
}
