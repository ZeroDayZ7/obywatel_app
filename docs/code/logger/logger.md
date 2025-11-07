Świetnie — tu masz twój `AppLogger` z **czytelnymi komentarzami przy każdej opcji** oraz **usuniętymi ramkami** (czyli bez tych linii `───`, `┌`, `└`, itd.).
Trik polega na użyciu **`SimplePrinter`** zamiast `PrettyPrinter`.

---

```dart
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;

  final Logger _logger;

  AppLogger._internal()
    : _logger = Logger(
        // 📊 Poziom logów — w debug wszystkie, w release tylko warning/error
        level: kReleaseMode ? Level.warning : Level.debug,

        // 🖨️ Używamy prostego printera, bez ramek i ozdobników
        printer: kReleaseMode
            ? SimplePrinter(
                printTime: false, // ⏰ czy wypisywać czas — wyłączone
              )
            : PrettyPrinter(
                methodCount: 0, // 🔢 ile metod ze stosu pokazać (0 = brak)
                errorMethodCount: 3, // 🧩 ile metod przy błędach pokazać
                lineLength: 80, // 📏 maksymalna długość linii (nieistotne tu)
                colors: true, // 🎨 kolorowe logi w konsoli debug
                printEmojis: true, // 😎 emoji przy typach logów
                noBoxingByDefault: true, // 🚫 usuwa ramki wokół logów
              ),
      );

  // 🔹 Log typu DEBUG (szczegóły, tylko dev)
  void d(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.d(_format(message, module), error: error, stackTrace: stackTrace);

  // 🔹 Log typu INFO (ważne informacje)
  void i(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.i(_format(message, module), error: error, stackTrace: stackTrace);

  // ⚠️ Ostrzeżenie (nie krytyczne błędy)
  void w(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.w(_format(message, module), error: error, stackTrace: stackTrace);

  // ❌ Krytyczny błąd (np. do wysyłki do Sentry)
  void e(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.e(_format(message, module), error: error, stackTrace: stackTrace);

  // 🧱 Formatowanie wiadomości — dodaje prefix modułu, np. [Auth]
  String _format(String message, String? module) =>
      module != null ? '[$module] $message' : message;
}
```

---

### 🔧 Co tu się zmieniło

- ✅ `noBoxingByDefault: true` usuwa linie `┌─── ... └───`.
- ✅ W release używany `SimplePrinter`, czyli czysty tekst.
- ✅ Zostawiłem kolory i emoji tylko dla debug-builda.
- 🧠 Dodałem komentarze obok każdej ważnej opcji, więc wiesz, co dokładnie robi.

---

Chcesz, żebym dorzucił wersję, która **automatycznie wysyła błędy (`.e()`) do Sentry** tylko w release?
