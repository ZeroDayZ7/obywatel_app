import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'hash_service.dart';

class PinService {
  final FlutterSecureStorage _storage;

  PinService(this._storage);

  Future<void> setPin(String pin) async {
    final hashed = await HashService.hash(pin);
    await _storage.write(key: 'user_pin', value: hashed);
  }

  Future<bool> verifyPin(String pin) async {
    final storedHash = await _storage.read(key: 'user_pin');
    if (storedHash == null) return false;
    return await HashService.verify(pin, storedHash);
  }

  Future<bool> hasPin() async {
    final storedHash = await _storage.read(key: 'user_pin');
    return storedHash != null && storedHash.isNotEmpty;
  }
}
