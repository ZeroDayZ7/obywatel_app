Oto szczegółowa analiza Twojego kodu (Core, Security, Bootstrap) wraz z 30 konkretnymi punktami, co można poprawić, zoptymalizować lub uszczelnić. Analiza opiera się na dostarczonym kodzie oraz logach startowych.

### 🚀 Bootstrap & Inicjalizacja (StartupRunner)

1. **Równoległe wykonywanie zadań (Parallel Execution):** Obecnie `StartupRunner` wykonuje zadania sekwencyjnie (`await` w pętli). Zadania niezależne od siebie, takie jak `StorageInitTask` i `DeviceIntegrityTask`, powinny być uruchamiane równolegle za pomocą `Future.wait([])`, aby skrócić czas startu aplikacji.
2. **Timeout dla zadań startowych:** Brak mechanizmu timeoutu dla poszczególnych zadań. Jeśli `VersionCheckTask` (co widać w logach) wisi na połączeniu sieciowym, cała aplikacja wisi na Splash Screenie. Dodaj `.timeout()` do każdego `initialize()`.
3. **Granularność komunikatów na Splash Screenie:** `AppInitStatus` ma stan `loading`, ale użytkownik nie wie, co się dzieje. Warto rozszerzyć stan o `loading(String message)`, aby `StartupRunner` mógł emitować: "Sprawdzanie integralności...", "Łączenie z serwerem...".
4. **Obsługa błędu krytycznego (Retry Strategy):** W `ErrorApp` masz przycisk "Spróbuj ponownie", który woła `recheck()`. Warto dodać automatyczny *exponential backoff* dla błędów sieciowych podczas startu, zanim pokażesz ekran błędu.
5. **Optymalizacja `VersionCheckTask`:** Logi pokazują błąd połączenia (`SocketException`), co blokuje start. To zadanie nie powinno być krytyczne (blokujące). Jeśli API wersji nie odpowiada, aplikacja powinna wystartować z ostrzeżeniem (lub cicho), chyba że masz *Force Update*.
6. **Lazy Loading bazy danych:** Inicjalizacja Drift (`AppDatabase`) dzieje się synchronicznie w `database_provider.dart`. Przenieś otwarcie połączenia do osobnego `Task` w `StartupRunner`, aby mieć pewność, że baza jest gotowa i klucze szyfrujące są załadowane przed pierwszym użyciem.

### 🔐 Security Core & Cryptography

7. **Zabezpieczenie przed "Time-Travel":** W `PinAttemptLimiter` używasz `DateTime.now()` do blokady czasowej. Użytkownik może zmienić czas w telefonie, aby ominąć blokadę. Użyj czasu z serwera (NTP) lub `SystemClock.uptime()` (czas od uruchomienia urządzenia), aby to utrudnić.
8. **Wyczyszczenie schowka (Clipboard):** W `SecurityService` przy przechodzeniu w stan `paused/inactive` (w `didChangeAppLifecycleState`) powinieneś programowo czyścić schowek systemowy (`Clipboard.setData(ClipboardData(text: ''))`), aby wrażliwe dane nie zostały tam skopiowane.
9. **Handling `PlatformException` w SecureStorage:** `flutter_secure_storage` na Androidzie potrafi rzucić wyjątek, jeśli zmienią się biometrie systemowe lub klucze zostaną unieważnione. W `SecureStorageService` otocz odczyty blokiem `try-catch` i w razie błędu deszyfrowania automatycznie czyść storage (tzw. *self-healing*).
10. **Pamięć RAM (`SecureBuffer`):** Klasa `SecureBuffer` używa `calloc`. Jeśli aplikacja zostanie ubita przez system *zanim* wywołasz `dispose()`, pamięć może nie zostać wyzerowana (zależy od OS). Dodaj Dart `Finalizer`, aby spróbować wyczyścić pamięć przy Garbage Collection, jeśli programista zapomni o `dispose`.
11. **Generowanie Soli (Salt):** W `HashService` generujesz nową sól przy każdym hashowaniu. To poprawne dla zapisu. Przy weryfikacji (`verify`) musisz upewnić się, że wyciągasz sól z zapisanego hasha, a nie generujesz nowej – kod wygląda ok, ale warto dodać unit test (nie piszę o testach, ale sprawdź to ręcznie), czy weryfikacja faktycznie działa z wyciągniętą solą.
12. **Zależność od `LocalAuthentication`:** W `LocalAuthProvider` sprawdzasz `authenticate`. Na Androidzie, jeśli użytkownik usunie PIN systemowy lub odciski, klucze kryptograficzne mogą stać się nieważne. Dodaj sprawdzenie `getAvailableBiometrics()` przed każdą próbą autoryzacji, aby wykryć zmiany w konfiguracji systemu.
13. **Ukrywanie podglądu (Privacy Shield):** `SecureApplication` działa świetnie, ale na iOS warto dodać dedykowany obrazek `LaunchScreen.storyboard`, który jest pusty/rozmyty, bo system robi snapshoty jeszcze zanim Flutter narysuje `SecureGate`.
14. **Weryfikacja integralności (Device Integrity):** `SecurityIntegrityConfig` ma `expectedPackageHash`. Upewnij się, że ten hash jest aktualizowany w procesie CI/CD przy każdym buildzie produkcyjnym, inaczej aktualizacja aplikacji zablokuje dostęp użytkownikom.

### 🔑 Autoryzacja & Sesja

15. **Wyścig (Race Condition) przy starcie:** Logi pokazują: `[Security Init: Done]` -> `AuthController initialized`. `AuthController` w metodzie `build()` woła `_restoreSession`, która też woła `securityService.init()`. To redundantne, skoro `StartupRunner` już to zrobił. `AuthController` powinien polegać na stanie zainicjowanym przez Bootstrap.
16. **Auto-Logout (Idle Timer):** Brakuje mechanizmu automatycznego wylogowania po X minutach braku aktywności użytkownika. W `SessionService` lub `SecurityService` dodaj `Timer`, który jest resetowany przy dotknięciu ekranu (można to zrobić globalnym `Listener` na `HitTestBehavior`).
17. **Odświeżanie Tokena (Concurrency):** `TokenRefreshInterceptor` używa `Completer` do blokowania zapytań. To dobre rozwiązanie. Upewnij się jednak, że w przypadku błędu odświeżania (`catch`), `_refreshCompleter` jest zawsze zerowany (`null`), inaczej aplikacja utknie w wiecznym oczekiwaniu na future.
18. **Przechowywanie PINu w RAM:** `PinService` czyści PIN z pamięci po użyciu (`pinCodes[i] = 0`). Bardzo dobrze. Rozważ jednak trzymanie *tymczasowego* hasha PINu w `SecurityService` (w `SecureString`), aby przy wybudzeniu aplikacji (resume) nie pytać o PIN, jeśli minęło np. < 30 sekund.
19. **Logika `Redirect`:** Guardy w `redirect_guards.dart` są skomplikowane. Rozważ rozdzielenie logiki: `AuthGuard` (zalogowany/niezalogowany) i `SecurityGuard` (PIN/Biometria). Obecnie mieszają się te odpowiedzialności, co może prowadzić do pętli przekierowań.

### 🌐 Sieć & API (Dio)

20. **Obsługa Localhost:** W logach masz błąd `SocketException` na `localhost:8085`. Android Emulator nie widzi `localhost`. W `ServicesConfig` dodaj wykrywanie: `if (Platform.isAndroid) return '10.0.2.2:8085';`.
21. **Cache'owanie Fingerprintu:** `DeviceInterceptor` generuje fingerprint przy *każdym* zapytaniu (`getSecureFingerprint`). To operacja kryptograficzna (hashowanie). Powinieneś to obliczyć raz (singleton/provider keepAlive) i trzymać w RAMie, zamiast liczyć od nowa dla każdego requestu HTTP.
22. **User-Agent:** Dodaj niestandardowy nagłówek `User-Agent` w `DioFactory`, zawierający wersję aplikacji, build number i system. Ułatwi to debugowanie problemów po stronie serwera i blokowanie starych wersji.
23. **Maskowanie Logów:** `LoggingInterceptor` maskuje `password`, `token` itp. Upewnij się, że maskuje też `pin`, `pesel` i `dowod_osobisty`, jeśli przesyłasz je w JSONie. Twoja lista `_sensitiveKeys` jest dobra, ale warto ją rozszerzyć o dane PII.

### 🏗️ Architektura & Riverpod

24. **Globalny `GlobalErrorListener`:** Obecnie jest w `AppBootstrapHandler`. Powinien być wyżej, nad `MaterialApp` lub w `builder` w `MaterialApp`, aby mógł obsługiwać błędy nawet spoza routingu (np. błędy w overlayach).
25. **Użycie `ref.watch` w metodach:** W `ActiveSessions` (provider) robisz `ref.watch` wewnątrz metody `_fetch`. To zadziała, ale w Riverpod 2.x/3.x zaleca się przekazywanie zależności w konstruktorze lub czytanie ich raz w `build`.
26. **Provider Scope:** `activePrefsProvider` rzuca `UnimplementedError` domyślnie. To ryzykowne. Lepiej, aby zwracał `AsyncValue` i był ładowany jak inne serwisy, lub użyj `ProviderContainer` w `main.dart` do inicjalizacji przed `runApp`.
27. **Dispose Kontrolerów:** W `LoginForm` tworzysz `TextEditingController`. Pamiętaj, że w Riverpod widgety często są `const`. Upewnij się, że kontrolery są tworzone w `State` (co robisz, super) lub użyj `flutter_hooks`, żeby kod był czystszy i mniejszy.

### 💅 UI/UX (w kontekście kodu)

28. **RepaintBoundary:** W `SplashScreen` i `PinVerificationScreen` używasz `CustomPaint` z `CyberGridPainter`. Jeśli animacja "cyber grid" jest ciągła, owiń ten widget w `RepaintBoundary`, aby nie przerysowywać całego ekranu (optymalizacja GPU).
29. **Responsywność Dialogów:** `PinSetupDialog` ma sztywne wymiary. Na bardzo małych ekranach (np. iPhone SE) klawiatura może zasłonić przyciski. Użyj `LayoutBuilder` lub `SingleChildScrollView` wokół zawartości dialogu.
30. **Haptyka:** W `FeedbackService` używasz wibracji. Pamiętaj, że na niektórych Androidach wibracje wymagają osobnego uprawnienia w `AndroidManifest.xml` (zależnie od wersji SDK). Sprawdź, czy masz `<uses-permission android:name="android.permission.VIBRATE"/>`.