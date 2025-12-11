// scripts/generate_locale_keys.dart
// dart run scripts/generate_locale_keys.dart
import 'dart:io';

void main() {
  final result = Process.runSync('dart', [
    'run',
    'easy_localization:generate',
    '-S',
    'assets/translations',
    '-O',
    'lib/core/lang',
    '-o',
    'locale_keys.g.dart',
    '-f',
    'keys',
  ], runInShell: true);

  stdout.write(result.stdout);
  stderr.write(result.stderr);

  if (result.exitCode == 0) {
    print('✅ locale_keys.g.dart wygenerowany pomyślnie');
  } else {
    print('❌ Błąd generowania kluczy');
  }
}
