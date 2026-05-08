// scripts/generate_locale_keys.dart
// dart run scripts/generate_locale_keys.dart
import 'dart:io';

void main() {
  final rootDir = Directory.current.path;

  print('🚀 Start generowania kluczy w: $rootDir');

  final result = Process.runSync(
    'dart',
    [
      'run',
      'easy_localization:generate',
      '-S',
      'assets/translations',
      '-O',
      'lib/app/lang',
      '-o',
      'locale_keys.g.dart',
      '-f',
      'keys',
    ],
    runInShell: true,
    workingDirectory: rootDir,
  );

  if (result.exitCode == 0) {
    stdout.write(result.stdout);
    print('✅ Sukces: locale_keys.g.dart został wygenerowany w lib/app/lang/');
  } else {
    stderr.write(result.stderr);
    print('❌ Błąd: Generowanie kluczy nie powiodło się.');
    exit(1);
  }
}
