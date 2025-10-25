import 'package:dargon2_flutter/dargon2_flutter.dart';

class HashService {
  static Future<String> hash(String input) async {
    // Generuj sól o długości 16 bajtów
    final salt = Salt.newSalt();

    final result = await argon2.hashPasswordString(
      input,
      salt: salt,
      iterations: 3,
      memory: 65536, // 64 MiB
      parallelism: 1,
      length: 32, // Długość hasha (opcjonalne, domyślnie 32)
      type: Argon2Type.i, // Argon2id
    );
    return result.encodedString; // Zalecane: zawiera sól i parametry
  }

  static Future<bool> verify(String input, String encodedHash) async {
    return await argon2.verifyHashString(
      input, // Hasło jako pierwszy argument
      encodedHash, // Zakodowany hash jako drugi
      // type: Argon2Type.i,  // Opcjonalne, jeśli nie pasuje domyślne
    );
  }
}
