import 'package:flutter/material.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final pass = TextEditingController();
  final repeat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ustaw nowe hasło")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: pass,
              decoration: const InputDecoration(labelText: "Hasło"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: repeat,
              decoration: const InputDecoration(labelText: "Powtórz hasło"),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (pass.text == repeat.text) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Zapisz hasło"),
            ),
          ],
        ),
      ),
    );
  }
}
