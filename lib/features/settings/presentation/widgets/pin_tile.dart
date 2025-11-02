import 'package:flutter/material.dart';

class PinTile extends StatelessWidget {
  final bool pinSet;
  final VoidCallback onSetup;

  const PinTile({required this.pinSet, required this.onSetup, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.lock),
      title: Text(pinSet ? 'PIN ustawiony' : 'Ustaw PIN'),
      trailing: ElevatedButton(
        onPressed: pinSet ? null : onSetup,
        child: const Text('Ustaw'),
      ),
    );
  }
}
