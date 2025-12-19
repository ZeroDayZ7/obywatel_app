import 'package:local_auth/local_auth.dart';

abstract class LocalAuthProvider {
  Future<bool> authenticate();
}

class LocalAuthProviderImpl implements LocalAuthProvider {
  LocalAuthProviderImpl(this._auth);

  final LocalAuthentication _auth;

  @override
  Future<bool> authenticate() async {
    final canAuthenticate =
        await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

    if (!canAuthenticate) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'Potwierdź tożsamość',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    }
  }
}
