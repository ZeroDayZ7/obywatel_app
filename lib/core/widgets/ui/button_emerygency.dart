import 'package:flutter/material.dart';

/// =====================
/// Emergency Button
/// =====================

class EmergencyButton extends StatefulWidget {
  const EmergencyButton({super.key});

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton>
    with SingleTickerProviderStateMixin {
  int _tapCount = 0;
  double _scale = 1.0;
  bool _showConfirmButton = false;

  void _handleTap() {
    setState(() {
      _tapCount++;
      _scale = 1.0 + (_tapCount * 0.1); // powiększenie przy każdym kliknięciu

      if (_tapCount >= 3) {
        _showConfirmButton = true;
      }
    });
  }

  void _reset() {
    setState(() {
      _tapCount = 0;
      _scale = 1.0;
      _showConfirmButton = false;
    });
  }

  void _triggerEmergency() {
    // 🔧 Tutaj w przyszłości logika alarmu (GPS, powiadomienia)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('🚨 Emergency triggered!')));
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _handleTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100 * _scale,
              height: 100 * _scale,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.warning, color: Colors.white, size: 36),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_showConfirmButton)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.call),
              label: const Text('Call Emergency'),
              onPressed: _triggerEmergency,
            ),
          if (_tapCount > 0 && !_showConfirmButton)
            Text(
              'Tap ${3 - _tapCount} more times to activate',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

/// =====================
/// Example usage in Scaffold
/// =====================

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Button Demo')),
      body: const Center(child: EmergencyButton()),
    );
  }
}
