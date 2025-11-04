import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SimplePinScreen extends StatefulWidget {
  const SimplePinScreen({super.key});

  @override
  State<SimplePinScreen> createState() => _SimplePinScreenState();
}

class _SimplePinScreenState extends State<SimplePinScreen> {
  final _storage = const FlutterSecureStorage();
  final _pinController = TextEditingController();
  String _savedPin = '';

  @override
  void initState() {
    super.initState();
    _loadPin();
  }

  Future<void> _loadPin() async {
    final pin = await _storage.read(key: 'pin') ?? '';
    setState(() => _savedPin = pin);
  }

  Future<void> _verifyPin() async {
    if (_savedPin.isEmpty) {
      await _storage.write(key: 'pin', value: _pinController.text);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('PIN ustawiony!')));
    } else if (_pinController.text == _savedPin) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ Poprawny PIN!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Błędny PIN!')));
    }
    _pinController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
                  inactiveColor: Colors.white24,
                  activeColor: Colors.white,
                  selectedColor: Colors.blueAccent,
                ),
                textStyle: const TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (_) {},
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _verifyPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
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
