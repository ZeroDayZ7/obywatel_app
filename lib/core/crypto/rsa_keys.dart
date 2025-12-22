// core/crypto/rsa_keys.dart
import 'dart:io';

Future<String> loadPublicKey() async {
  final file = File('assets/keys/update_public.pem');
  return await file.readAsString();
}
