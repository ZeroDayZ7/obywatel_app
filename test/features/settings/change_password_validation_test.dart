import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/utils/validators.dart';

void main() {
  group('Change password validation', () {
    test('requires the backend password policy to be enforced in UI', () {
      expect(Validators.validatePassword('pass', minLength: 8), isNotNull);
      expect(Validators.validatePassword('Password1!', minLength: 8), isNull);
      expect(Validators.validatePassword('password1!', minLength: 8), isNotNull);
      expect(Validators.validatePassword('Password!', minLength: 8), isNotNull);
      expect(Validators.validatePassword('Password1', minLength: 8), isNotNull);
    });
  });
}
