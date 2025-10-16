import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'login_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final String _correctPin =
      "1234"; // na start hardkodowane (później z backend)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter PIN to Unlock",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _pinController,
                onChanged: (_) {},
                pinTheme: PinTheme(
                  activeColor: Colors.white,
                  selectedColor: Colors.white70,
                  inactiveColor: Colors.white38,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_pinController.text == _correctPin) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Incorrect PIN")),
                    );
                  }
                },
                child: const Text("Unlock"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
