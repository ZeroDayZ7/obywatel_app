### I. Rozwiązanie Twojego głównego problemu (Bug po restarcie)

Problem polega na tym, że po wpisaniu poprawnego PIN-u po restarcie, proces weryfikacji nie informuje głównego zarządcy stanu (SecurityService), że aplikacja jest odblokowana.

1. Brakująca aktualizacja stanu w weryfikacji: W `PinVerificationNotifier.verifyPin`, jeśli `verifyPin` zwróci `true`, ustawiasz stan na `success()`. **Brakuje tu jednak wywołania** `ref.read(securityServiceProvider.notifier).unlockManually()`. Przez to `SecurityService` wciąż uważa, że `hasLocalLock = true`.
2. Błędna nawigacja w PinScreen: W `PinVerificationScreen` na sukcesie wywołujesz `Navigator.pop(context)`. W GoRouterze (który jest oparty na stanie) nie powinieneś robić ręcznego popa z ekranu blokady. Ekran powinien zniknąć sam, gdy Guard (`redirect_guards.dart`) zauważy, że `securityState.shouldShowLock`  uległo zmianie na `false`.
3. Niespójność StartupRunnera: Twój `AppInitNotifier` po wykonaniu zadań zawsze zwraca `AppInitStatus.authorized()`, ignorując fakt, czy `SecurityService` nałożył lokalną blokadę (PIN). Powinien sprawdzać stan `SecurityService` i zwracać np. `AppInitStatus.lockedPin()`.

---

### II. Architektura Stanu Bezpieczeństwa (SSOT - Single Source of Truth)

4. Jeden "Władca Blokady": Obecnie logikę blokowania aplikacji dzieli `SessionObserver` (bezczynność) oraz `SecurityService` (cykl życia). Wszystkie te akcje powinny być delegowane do jednego punktu w `SecurityService` (metoda `lockApp()`).
5. Usunięcie WidgetsBindingObserver z Notifiera: `SecurityService` implementuje `WidgetsBindingObserver`. W Riverpod nie zaleca się mieszania logiki cyklu życia Fluttera wewnątrz Notifierów, gdyż może to prowadzić do wycieków pamięci. Utwórz oddzielny, niemutowalny serwis `AppLifecycleObserver`, który nasłuchuje zdarzeń i wywołuje metody na `SecurityService`.
6. Rozdzielenie AuthState i SecurityState: Twoja logika przekierowań (`rootGuard` ) miesza stany uwierzytelnienia (czy token jest ważny) z lokalną blokadą (czy trzeba wpisać PIN). Rozdziel to wyraźnie: `AuthState` odpowiada za to, Kto to jest i czy serwer go wpuszcza. `SecurityState` odpowiada za to, czy urządzenie fizycznie ufa użytkownikowi (PIN/Biometria).
7. Optymalizacja Redirect Logic: Funkcja `appRedirectLogic`  jest wywoływana przy *każdej* zmianie stanu na nasłuchiwanych providerach. Upewnij się, że nie wywołuje ona żadnych asynchronicznych operacji (obecnie jest synchroniczna, co jest super), ale zminimalizuj też ilość obliczeń wewnątrz `rootGuard`.
8. Spójność nazewnictwa w SecurityState: Zmienna `hasLocalLock`  jest nieintuicyjna. Zmień na `isLocked` oraz dodaj `isAppReady` (zamiast `initialized`), co poprawi czytelność warunków logicznych.

---

### III. Kryptografia, PIN i Pamięć (Secure Enclave)

Masz tutaj kod klasy Enterprise, ale wymaga on uproszczeń, by nie sypał się na krawędziach.

9. Zabezpieczenie Master Key: Obecnie KEK (Key Encryption Key) wyliczany z PIN-u szyfruje bezpośrednio klucz asymetryczny urządzenia `devicePrivateKey`. Jeśli użytkownik zmieni PIN, musisz odszyfrować ten klucz starym KEK i zaszyfrować nowym. Bezpieczniej jest wygenerować symetryczny "Master Key" (AES256). KEK z PIN-u szyfruje *tylko* ten Master Key. Master Key szyfruje klucze asymetryczne i bazę danych. Zmiana PIN-u wymaga przepakowania (re-wrap) tylko jednego, małego klucza Master Key.
10. Ulotność _sessionKey w PinService: W `PinService` przechowujesz `_sessionKey` w pamięci RAM. Jeśli system ubije ten provider (lub zrobisz `ref.invalidate`), klucz przepadnie, a aplikacja wpadnie w niezdefiniowany stan. Jeśli klucz jest w RAM, upewnij się, że jego brak rzuca krytyczny błąd wymagający od ponownego wpisania PIN-u.
11. Redundancja KDF (Argon2id): Używasz Argon2id w `HashService` (do hashowania PIN-u) i w `KdfService` (do wyliczania klucza z PIN-u). To ciężkie operacje dla CPU. Możesz użyć tego samego wyniku KDF (Key Derivation Function) do obu rzeczy. Po wyliczeniu klucza głównym Argon2id, jego pierwsza połowa to klucz szyfrujący (KEK), a druga połowa to hash weryfikacyjny zapisywany w pamięci. Zmniejszysz obciążenie CPU o 50% podczas logowania.
12. Zarządzanie IsolateManagerem: `CryptoService` używa `IsolateManager`. To bardzo dobry ruch, by nie blokować UI podczas obliczeń krypto. Jednak klasa `SignRequest`  przekazuje surowy `String pin`. Przekazuj wyłącznie `List<int>` (bajty), by móc użyć `SecureBuffer` i wymusić wymazanie pamięci (memset 0) od razu po operacji wewnątrz izolatu.
13. FFI i SecureBuffer: Twój `SecureBuffer`  to genialne rozwiązanie. Upewnij się jednak, że we wszystkich blokach w `PinService`, użycie buffera opakowane jest w solidny blok `try { ... } finally { buffer.dispose(); [cite_start]}`, aby zminimalizować ryzyko wycieków pamięci (memory leaks w C/C++ nie są zbierane przez Garbage Collector Darta).
14. Synchronizacja stanu Biometrii: `SecurityService` ustawia w pamięci chęć użycia biometrii (`isBiometricConfigured` ). Ale sam proces lokalnego odblokowania (LocalAuthentication ) nie jest podpięty pod ekran żądania PIN-u. `PinVerificationScreen`  powinien na etapie `initState` odpalać biometrię, jeśli jest włączona.

---

### IV. Warstwa Sieciowa i Cykl Życia Sesji (Tokeny & DIO)

15. Refresh Token Race Conditions: Używasz paczki `fresh_dio`. Uważaj – funkcja odświeżania odczytuje `deviceService.getFingerprint()` oraz `authControllerProvider` asynchronicznie. Jeśli wystąpi 5 jednoczesnych requestów 401, mechanizmy odświeżania mogą na siebie wpaść, jeśli nie jest to precyzyjnie skonfigurowane. `Fresh` sobie z tym radzi, ale unikaj asynchronicznego czytania stanu z Riverpoda wewnątrz interceptora, jeśli to możliwe (wstrzykuj bezpośrednie zależności).
16. "Zaufane urządzenie" a weryfikacja: Logika w `verifyDeviceSignature` w `AuthController`  próbuje popisać challenge kluczem z RAM (`crypto.signWithActiveKey()`). Zastanów się, czy cykl życia pozwala na to, że klucz zawsze tam jest. Jeśli użytkownik ubije aplikację podczas 2FA, aktywny klucz z RAM zniknie, a logowanie się zawiesi bez mechanizmu powrotu (fallback).
17. Ograniczanie żądań (Rate Limiter): Twój `BackendStateNotifier` zapisuje z nagłówków stan `rateLimitRemaining`. Brakuje jednak Interceptora na wyjściu (OnRequest), który by zablokował strzał do API (rzucając lokalnie błąd HTTP 429), zanim zapytanie wyjdzie z urządzenia, jeśli limit zjechał do zera.
18. Wycieki danych wrażliwych w logach: Twój `LoggingInterceptor` ma tablicę maskowania `_sensitiveKeys`. Rozszerz ją o `['setup_token', 'two_fa_token', 'challenge', 'X-Device-Fingerprint']`. Kody wyzwań i tokeny setupowe bywają użyteczne przy ataku typu replay.
19. Timeout dla weryfikacji sprzętowej: W `SecuritySyncInterceptor`  wywołujesz w locie `FlutterRootJailbreakChecker`. To natywny plugin, który pod spodem skanuje setki pakietów. Wywoływanie tego co minutę  może wpływać na zużycie baterii. Skonfiguruj to na sprawdzanie wyłącznie przy zmianie cyklu życia aplikacji (AppLifecycleState.resumed) lub maksymalnie co 15 minut.

---

### V. Baza Danych i Persystencja

20. Szyfrowanie Drift DB: Klucz do bazy danych to wygenerowany losowo string z SecureStorage (`StorageKeys.databaseKey`). To standard, ale oznacza, że jeśli ktoś sklonuje system plików telefonu (mając roota), otworzy tę bazę. Znacznie bezpieczniej jest użyć wspomnianego Master Key (zabezpieczonego PIN-em użytkownika) jako hasła pragma do SQLCipher. Dopóki appka nie jest odblokowana PIN-em, nikt nie odczyta lokalnych powiadomień ani czatów.
21. MigrationService vs StartupRunner: Migracje bazy/SecureStorage `MigrationService.performMigrations()` muszą być absolutnie pierwszym zadaniem w `StartupRunner` `sequentialTasks`, na długo przed inicjalizacją Bazy Danych czy Serwisu Bezpieczeństwa, aby nie operowały one na starym schemacie kluczy.
22. Przestarzałe dane w SharedPreferences: Masz osobnego providera do `SharedPreferences`, ale rzadko z niego korzystasz, bo większość leci w `SecureStorage`. Jasno zdefiniuj podział: `SharedPreferences` tylko dla ustawień UI (Theme, preferowany język), a `SecureStorage` tylko dla tokenów, identyfikatorów i flag bezpieczeństwa (`isPinSet`).

---

### VI. Ochrona Brute-Force (Lockout Timer)

23. Odporność Timera na manipulację czasem: Twój `PinAttemptLimiter` używa `backendNotifier.getSafeNow()`. To znakomite rozwiązanie (chroni przed zmianą czasu w ustawieniach systemu operacyjnego). Upewnij się jednak, że jeśli `getSafeNow()` nie było nigdy zsynchronizowane z serwerem (np. przy pierwszym odpaleniu offline), masz bezpieczny fallback (wymuszenie weryfikacji serwerowej przy kolejnym odblokowaniu).
24. Stan asynchroniczny w PinAttemptLimiter: Przyczyną pomniejszych glitchów UI przy błędnym PIN-ie może być to, że po błędzie uaktualniasz limiter `state = AsyncData(newState);`, a potem wywołujesz `_saveToStorage()`. Powinno to być odwrotnie lub objęte w blok transakcyjny (najpierw dysk, potem stan UI), by awaria zapisu nie spowodowała rozjazdu UI z rzeczywistością.
25. Reset licznika błędu: Po udanym zalogowaniu / odblokowaniu PIN-em, mechanizm zliczający niepowodzenia (`attempts: 0`) z `PinAttemptLimiter`  musi być stanowczo resetowany (czyszczony z dysku). Obecnie brakuje twardego wymuszenia czyszczenia na sukcesie wewnątrz `PinVerificationNotifier.verifyPin`.

---

### VII. Kod i Modelowanie Danych (Utrzymanie Czystości)

26. Nadmiarowość Exceptional Data: Twoje błędy API są poprawnie mapowane na `AppFailure`. Zauważ, że `AuthService`  rzuca natywne `Exception('errors.INVALID_2FA')`, co zmusza globalnego catcha do parsowania stringów. Używaj wyłącznie `AppFailure` jako throw/return w repozytoriach.
27. Mapowanie AuthResponse: Używasz Freezed dla `AuthResponse` , a potem ręcznie budujesz `factory AuthResponse.fromMap`. Freezed posiada mechanizm własnych konwerterów JSON (`@JsonKey`), co usunie z Twojego kodu konieczność ręcznego if-owania odpowiedzi z serwera na poziomie parsera.
**28. Ścisła kontrola zasobów (Disposables):** W aplikacjach o wysokim rygorze bezpieczeństwa musisz jawnie czyścić pamięć. Twój `AuthController.logout()` czyści sesje i inwaliduje providery, ale musisz mieć pewność, że zwalniasz też uchwyty w `CryptoService` (zerowanie `_activeDeviceKeyPair` ) i usuwasz cache wiadomości czatu (`MessageService`).
29. Optymalizacja inicjalizacji loggera: `AppLogger`  jest instancjonowany przy starcie. W systemach zabezpieczonych warto unikać logowania całych response.data (zbyt ryzykowne pomimo maskowania). Włącz tryb debugowania pakietów sieciowych wyłącznie przy ukrytym fladze np. "Developer Mode" (7 kliknięć w wersję aplikacji).
30. GoRouter Keys: Posiadasz `_rootNavigatorKey`. Gdy będziesz chciał zaimplementować wymuszony popup ("Sesja wygasła"), mając globalny klucz nawigatora, będziesz w stanie nałożyć go nad wszystko, omijając restrykcje stanu. Zostaw ten klucz w spokoju – jest przygotowany pod krytyczne alerty z `SessionObservera`.
