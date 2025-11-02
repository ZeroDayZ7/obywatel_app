import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obywatel_plus/app/config/storage_keys.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../auth/presentation/login_screen.dart';
import '../../../app/theme/app_colors.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  late StreamController<ErrorAnimationType> _errorController;

  String _correctPin = '';

  @override
  void initState() {
    super.initState();
    _errorController = StreamController<ErrorAnimationType>();
    _loadPin();
  }

  Future<void> _loadPin() async {
    final pin = await _storage.read(key: StorageKeys.pinHash);
    if (!mounted) return;
    setState(() => _correctPin = pin ?? '');
  }

  @override
  void dispose() {
    _errorController.close();
    _pinController.dispose();
    super.dispose();
  }

  void _verifyPin() {
    if (_pinController.text == _correctPin && _correctPin.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      _errorController.add(ErrorAnimationType.shake);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Niepoprawny PIN"),
          backgroundColor: AppColors.error,
        ),
      );
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color white20 = Colors.white.withAlpha((0.2 * 255).toInt());
    Color white70 = Colors.white.withAlpha((0.7 * 255).toInt());

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.primaryColor.withAlpha(220), theme.primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Wprowadź PIN",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  errorAnimationController: _errorController,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    activeColor: Colors.white,
                    selectedColor: white70,
                    inactiveColor: Colors.white38,
                    activeFillColor: white20,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onChanged: (_) {},
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _verifyPin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Odblokuj",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Anuluj",
                    style: TextStyle(
                      color: white70,
                      fontWeight: FontWeight.w500,
                    ),
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
