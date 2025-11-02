import 'package:flutter/material.dart';

class BiometricTile extends StatelessWidget {
  final bool enabled;
  final VoidCallback onSetup;

  const BiometricTile({
    required this.enabled,
    required this.onSetup,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.fingerprint),
      title: Text(enabled ? 'Biometria włączona' : 'Włącz biometrię'),
      trailing: ElevatedButton(
        onPressed: enabled ? null : onSetup,
        child: const Text('Włącz'),
      ),
    );
  }
}
