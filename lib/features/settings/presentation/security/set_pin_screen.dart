import 'package:flutter/material.dart';

class SetPinModal extends StatefulWidget {
  const SetPinModal({super.key});

  @override
  State<SetPinModal> createState() => _SetPinModalState();
}

class _SetPinModalState extends State<SetPinModal> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _pinController.text.isNotEmpty &&
      _confirmController.text.isNotEmpty &&
      _pinController.text == _confirmController.text;

  void _savePin() {
    if (_canSave) {
      // Tutaj zapisujesz PIN np. w Riverpod lub SharedPreferences
      Navigator.of(context).pop(_pinController.text);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('PIN saved successfully!')));
    } else {
      setState(() {
        _error = 'PINs do not match';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Set your PIN',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPinField(_pinController, 'Enter PIN'),
          const SizedBox(height: 12),
          _buildPinField(_confirmController, 'Confirm PIN'),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canSave ? _savePin : null,
              child: const Text('Save PIN'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: true,
      maxLength: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: label,
        counterText: '',
      ),
      onChanged: (_) {
        setState(() {
          _error = null; // usuń błąd gdy zmienia się input
        });
      },
    );
  }
}
