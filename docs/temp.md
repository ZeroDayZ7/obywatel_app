Podejście **Secure Memory** (zastępowanie `String` przez `List<int>` i zerowanie RAM-u) stosuje się wszędzie tam, gdzie dane są **"sekretami"**, których wyciek kompromituje bezpieczeństwo użytkownika.

Oto konkretne miejsca, w których powinieneś użyć tej architektury:

### 1. Kody 2FA (TOTP / SMS)

Gdy użytkownik przepisuje 6-cyfrowy kod z SMS-a lub aplikacji Authenticator:

* **Zastosowanie:** Zamiast ładować kod do `String code`, ładujesz go do `List<int>`.
* **Dlaczego:** Kody 2FA są krótkotrwałe, ale ich przechwycenie w czasie rzeczywistym pozwala na przejęcie sesji. Po wysłaniu kodu do serwera/walidatora, natychmiast zerujesz listę.

### 2. Hasło główne (Master Password)

Jeśli Twoja aplikacja pozwala na ustawienie własnego, skomplikowanego hasła zamiast PIN-u:

* **Zastosowanie:** Od pola tekstowego (TextField) aż po `HashService.hash()`.
* **Dlaczego:** Hasło jest zazwyczaj kluczem do szyfrowania bazy danych (np. SQLCipher). Jeśli `String` z hasłem zostanie w RAM, ktoś może odczytać go i odszyfrować całą bazę danych aplikacji offline.

### 3. Klucze prywatne i Seed Phrasy (BIP39)

Jeśli Twoja aplikacja obsługuje tożsamość cyfrową lub portfel:

* **Zastosowanie:** Frazy odzyskiwania (12 słów) nigdy nie powinny być łączone w jeden długi `String`. Każde słowo powinno być trzymane jako `List<int>` lub `Uint8List`.
* **Dlaczego:** To są dane o najwyższym priorytecie. Raz wyciekną – dostęp jest tracony bezpowrotnie.

### 4. Tokeny sesji (Bearer Tokens) – Poziom "Paranoja"

Większość aplikacji trzyma `JWT Token` jako zwykły `String`. W aplikacjach klasy Enterprise:

* **Zastosowanie:** Tokeny są trzymane w `SecureBuffer` (FFI) i wstrzykiwane do nagłówków HTTP bezpośrednio przed wysyłką, a potem zerowane.
* **Dlaczego:** Zapobiega to kradzieży aktywnej sesji przez złośliwe oprogramowanie skanujące RAM w poszukiwaniu wzorców JWT (np. nagłówka `eyJ...`).

---

### Jak to wygląda w kodzie? (Zasada "Gorącego Ziemniaka")

Wyobraź sobie, że sekret to "gorący ziemniak". Nikt nie chce go trzymać długo i każdy chce go jak najszybciej podać dalej lub wyrzucić.

| Etap | Typ danych | Akcja |
| --- | --- | --- |
| **Wprowadzanie** | `List<int>` | Zbierasz pojedyncze znaki. |
| **Przesyłanie** | `List<int>` | Podajesz przez argumenty funkcji. |
| **Przetwarzanie** | `SecureBuffer` | FFI / Pamięć natywna (Argon2 / AES). |
| **Po użyciu** | `buffer.dispose()` | **Zerowanie** (memset) w C. |
| **Powrót** | `list.fillRange(0)` | **Zerowanie** w Dart. |

### Czy to nie jest przesada?

Dla zwykłej aplikacji z przepisami kulinarnymi – **tak**.
Dla aplikacji **Obywatel App**, która przechowuje:

* Dane dowodu osobistego,
* Certyfikaty logowania do węzła krajowego,
* Dane medyczne lub finansowe,

...to podejście nie jest przesadą, a **wymogiem**. Systemy operacyjne (Android/iOS) nie gwarantują, że pamięć Twojej aplikacji zostanie natychmiast wyczyszczona po jej zamknięciu. Ręczne zerowanie to jedyny sposób, by mieć nad tym kontrolę.

**Czy chcesz, abym pomógł Ci teraz przygotować uniwersalną klasę pomocniczą (np. `SecureInputHandler`), która ułatwi obsługę takich list bajtów w całej aplikacji?**











Oto szczegółowa analiza kodu i 30-punktowy plan działań "Enterprise", skupiający się na architekturze, bezpieczeństwie, wydajności i UX, z pominięciem testów.

Twoja aplikacja ma już solidne fundamenty (Riverpod, GoRouter, Dio Interceptors, Drift, dobra obsługa błędów), ale wejście na poziom **Enterprise** wymaga uszczelnienia architektury, optymalizacji i wdrożenia zaawansowanych mechanizmów systemowych.

### I. Architektura i Skalowalność (Clean Architecture & Modularity)

1. **Wprowadzenie warstwy UseCases (Interactors):**
Obecnie logika biznesowa jest często w Notifierach (np. `AuthController`). W kodzie Enterprise Notifier powinien zarządzać tylko stanem UI. Należy wydzielić klasy `LoginUseCase`, `SyncMessagesUseCase`, które są niezależne od Riverpoda i łatwiejsze w utrzymaniu.
2. **Pełna generacja kodu (Riverpod Generator):**
Część providerów jest pisana ręcznie (`final authControllerProvider = ...`), a część generowana (`@riverpod`). Należy zmigrować wszystko na `riverpod_annotation`, aby uniknąć błędów z `autoDispose` i `keepAlive` oraz uprościć składnię.
3. **Feature-First Modularization:**
Obecnie struktura folderów to `features/auth`, `features/chat`. Przy dużej skali warto wydzielić te foldery do osobnych lokalnych pakietów (packages), np. `packages/auth_feature`, aby wymusić separację zależności i przyspieszyć kompilację.
4. **Standaryzacja Mapperów (DTO <-> Domain):**
W `ChatApi`  mapowanie odbywa się wewnątrz metody. Należy stworzyć oddzielne klasy `Mapper` (np. `MessageMapper`), aby oddzielić warstwę danych od domeny i łatwiej obsługiwać wersjonowanie API.


5. **Centralizacja Feature Flags (Remote Config):**
W `SecurityIntegrityConfig`  masz hardcodowane flagi. W Enterprise te flagi (np. `blockRooted`) powinny być pobierane z serwera (np. Firebase Remote Config) przy starcie, abyś mógł zdalnie włączyć/wyłączyć blokadę bez update'u apki.



### II. Bezpieczeństwo (Hardening & Cryptography)

6. **Biometria z użyciem Secure Enclave:**
Obecnie `LocalAuth`  służy tylko jako "bramka logiczna" (zwraca true/false). W Enterprise biometria powinna odblokowywać klucz kryptograficzny z Keychain/Keystore, którym dopiero odszyfrujesz token sesji. Jeśli ktoś sfałszuje `true` w `LocalAuth`, nadal nie będzie miał klucza.


7. **Zabezpieczenie przed zrzutami ekranu (Secure Screen):**
Dodać mechanizm (np. `flutter_windowmanager` na Android), który zamazuje ekran w widoku Recent Apps oraz blokuje screenshoty na ekranach z danymi wrażliwymi (`IDCardScreen`, `ChatScreen`).
8. **App Attestation (SafetyNet / Play Integrity / App Attest):**
Twoja klasa `DeviceIntegrityService`  robi detekcję lokalnie. Hacker może to ominąć (hookując metodę). Należy wdrożyć `App Attest`, gdzie to serwer Google/Apple potwierdza integralność urządzenia, a nie sama aplikacja.


9. **Obfuscation & RASP:**
Wdrożenie ProGuard/R8 z agresywnymi regułami. Rozważenie komercyjnego RASP (Runtime Application Self-Protection), który wykrywa podpięcie debuggera lub Fridę w czasie rzeczywistym i "zabija" aplikację agresywniej niż `exit(0)`.
10. **Czyszczenie pamięci (Secure Memory):**
W `String` hasła i tokeny zostają w pamięci RAM. Warto rozważyć użycie `ffi` i natywnych buforów, które są zerowane (`memset`) natychmiast po użyciu (dotyczy `PinService` i `HashService`).

### III. Networking i Data Sync (Offline-First)

11. **Kolejkowanie żądań offline (Request Retrier):**
Masz `getUnsyncedMessages`, ale brakuje globalnego mechanizmu (WorkManager), który po odzyskaniu zasięgu automatycznie wyśle wszystkie zaległe żądania (nie tylko chat, ale np. update profilu, logi).


12. **Optymalizacja parsowania JSON (Isolates):**
W `MessageCryptoService`  używasz `compute`. Należy przenieść również parsowanie dużych JSON-ów z API (np. lista wiadomości) do osobnego izolatu, używając `compute` lub `Isolate.run`, aby nie klatkować UI przy starcie.


13. **Cache HTTP (ETag / Last-Modified):**
`Dio` obsługuje cache. Warto wdrożyć `dio_cache_interceptor`, aby nie pobierać np. konfiguracji lub profilu usera (`ApiEndpoints.userProfile` ), jeśli się nie zmieniły na serwerze (oszczędność danych).


14. **Socket.IO / SignalR zamiast surowego WebSocket:**
W `ChatRepositoryImpl`  używasz surowego `WebSocketChannel`. Rozważ migrację na protokół z obsługą auto-reconnect, ping-pong i gwarancją dostarczenia (ack), co jest kluczowe w komunikatorach.


15. **Migracje bazy danych Drift:**
Masz `schemaVersion => 1`. Należy przygotować strategię testowania migracji SQL (np. dodanie kolumny bez utraty kluczy krypto), bo update produkcyjny uszkadzający bazę to katastrofa.



### IV. UI/UX i Design System

16. **Design System Package (Atomic Design):**
Masz pliki `app_colors.dart`, `typography.dart`. Należy je wydzielić do osobnego pakietu UI, który eksportuje gotowe widgety (`ObywatelButton`, `ObywatelTextField`). To zapewni spójność, gdy zaczniesz tworzyć widgety pulpitowe lub na zegarek.
17. **Szkieletowe ładowanie (Shimmer):**
Zamiast `CircularProgressIndicator`  na środku ekranu, wdrożyć efekt "Shimmer" (migoczące szkielety) odwzorowujące układ listy czatu lub kafelków. To standard w aplikacjach premium.


18. **Obsługa błędów UI (Error Boundaries):**
Twój `ErrorWidget.builder`  jest globalny. Warto wdrożyć lokalne `ErrorBoundary` (np. na poziomie pojedynczego kafelka na Dashboardzie). Jeśli jeden widget się wywali, reszta ekranu powinna działać.


19. **Dostępność (Accessibility/Semantics):**
Dodać widgety `Semantics` i przetestować `Screen Reader`. Twoje `InkWell` i `GestureDetector` w `home_grid_item.dart`  mogą nie być poprawnie czytane przez VoiceOver/TalkBack bez etykiet.


20. **Responsywność (Adaptive Layouts):**
Używasz `maxWidth`. W Enterprise należy użyć `LayoutBuilder` lub pakietu `flutter_adaptive_scaffold` do zmiany układu nawigacji (BottomBar na telefonie -> NavigationRail na tablecie), a nie tylko zwężania kontentu.



### V. DevOps i Monitorowanie (Observability)

21. **Structured Logging (Crashlytics/Sentry):**
Twój `AppLogger`  wypisuje do konsoli. Należy podpiąć tam `FirebaseCrashlytics` lub `Sentry`. Ważne: loguj nie tylko błędy, ale "breadcrumbs" (ścieżkę użytkownika), np. "User tapped login -> API 401 -> Logout".


22. **Network Inspector (Alice/Chucker):**
W trybie DEV i QA dodać narzędzie UI (jak Alice), które pozwala testerom podejrzeć requesty HTTP bezpośrednio w aplikacji, bez podpinania pod komputer.
23. **Analityka zdarzeń (Events):**
Stworzyć abstrakcję `AnalyticsService`. Każda akcja (kliknięcie, błąd walidacji, sukces flow) powinna wysyłać zdarzenie. To kluczowe do zrozumienia, gdzie użytkownicy odpadają (np. w procesie resetu hasła).

### VI. Funkcjonalności (Feature Completeness)

24. **Push Notifications (FCM):**
Brak obsługi powiadomień push. Chat bez pushy nie ma sensu. Należy wdrożyć `firebase_messaging` i obsługę payloadów "data-only" do wybudzania aplikacji i synchronizacji w tle.
25. **Background Sync (WorkManager):**
Wdrożyć `workmanager` do okresowego odświeżania tokena i pobierania nowych wiadomości/powiadomień, gdy aplikacja jest zabita.
26. **Zaawansowany Chat (Media & Pagination):**
Obecnie chat ładuje wszystko naraz. Należy dodać paginację (lazy loading przy scrollowaniu w górę). Dodać obsługę wysyłania zdjęć/plików (multipart requesty) z kompresją po stronie klienta.


27. **Głębokie linkowanie (Deep Linking):**
Konfiguracja `FlutterDeepLinking` (Android App Links / iOS Universal Links). Np. link w mailu resetującym hasło powinien otwierać od razu `ResetPasswordScreen` w aplikacji.
28. **Zarządzanie sesjami (Remote Logout):**
W `ActiveSessionsScreen`  masz UI. Należy dorobić logikę backendową, która unieważnia konkretny `refreshToken` (po device ID), pozwalając na zdalne wylogowanie skradzionego telefonu.


29. **Tryb "Panic Button" (Emergency):**
W `EmergencyButton`  masz logikę tapowania. Warto dodać opcję wysyłania ukrytego sygnału SOS lub czyszczenia danych (`SecureStorage.deleteAll`) przy wpisaniu specjalnego "Panic PIN" na ekranie blokady.


30. **Force Update Logic:**
Masz `VersionCheckTask`, ale warto rozbudować to o "Soft Update" (można pominąć) i "Maintenance Mode" (serwer zwraca flagę, że trwa przerwa techniczna - blokada całej apki z komunikatem).



**Od czego zacząć?**
Sugeruję **Punkty 1 i 2** (uporządkowanie architektury i generatorów), a następnie **Punkty 24 i 26** (Chat i Pushe), bo to najbardziej widoczne braki funkcjonalne w "Super App".




































Oto kompleksowy plan refaktoryzacji Twojej aplikacji Flutter, przygotowany zgodnie z najlepszymi praktykami enterprise. Skupiamy się na architekturze, bezpieczeństwie sieciowym oraz stabilności systemu, bez uwzględniania testów.

### Refaktoryzacja i Standardy Enterprise (30 punktów)

#### Architektura i Struktura (Clean Architecture)

1. 
**Enkapsulacja logiki bootstrapu:** Obecny `StartupRunner` jest dobrym punktem wyjścia, ale zadania takie jak `StorageInitTask` powinny operować na interfejsach, a nie bezpośrednio na implementacjach.


2. **Warstwa Repository:** Wprowadź warstwę repozytoriów między kontrolerami (np. `AuthController`) a źródłami danych (`AuthService`, `SessionService`). Kontrolery nie powinny wiedzieć o detalach protokołów komunikacyjnych.


3. 
**Dekompozycja `ObywatelPlusApp`:** Przenieś logikę wyboru ekranu startowego (SplashScreen vs ErrorApp) do dedykowanego handlera stanu, aby widget `App` pozostał czysty i deklaratywny.


4. 
**Zarządzanie stanem (Sealed Classes):** Wykorzystaj pełniej potencjał klas `sealed` z `Freezed` (jak w `AppInitStatus`) do obsługi stanów UI, unikając ręcznego sprawdzania flag logicznych w widokach.


5. 
**Ujednolicenie DI (Dependency Injection):** Zastąp bezpośrednie wywołania `ref.read` wewnątrz zadań startowych automatycznym wstrzykiwaniem zależności przez konstruktory klas, co ułatwi zarządzanie cyklem życia obiektów.



#### Bezpieczeństwo Sieciowe i API (Network Security)

6. **SSL Pinning:** W `DioFactory` zaimplementuj sprawdzanie certyfikatów SSL (Public Key Pinning), aby zapobiec atakom Man-in-the-Middle (MitM) w sieciach publicznych.
7. 
**Zarządzanie Tokenami (JWT):** Implementacja `refreshDioProvider` musi posiadać blokadę (mutex), aby zapobiec jednoczesnemu odświeżaniu tokena przez wiele równoległych żądań.


8. 
**Wygaszanie Sesji:** Dodaj mechanizm `GlobalErrorInterceptor`, który przy błędzie 401 (Unauthorized) automatycznie czyści dane sesyjne w `SecureStorage` i przekierowuje użytkownika do ekranu logowania.


9. 
**Ochrona przed wyciekiem danych w logach:** Zmodyfikuj `_createLoggingInterceptor`, aby automatycznie maskował wrażliwe pola (hasła, tokeny, dane osobowe) przed zapisaniem ich w konsoli lub systemie logowania.


10. **Nagłówki User-Agent i Fingerprinting:** Dodaj standardowe nagłówki enterprise do każdego żądania (wersja aplikacji, model urządzenia, wersja systemu), co ułatwia debugowanie po stronie serwera i wykrywanie anomalii.
11. 
**Timeouts i Retry Policy:** Skonfiguruj `Dio` z rygorystycznymi czasami połączenia (`connectTimeout`) i zaimplementuj strategię ponawiania żądań (Exponential Backoff) tylko dla błędów bezpiecznych (np. błędy 5xx).



#### Bezpieczeństwo Urządzenia i Danych

12. 
**Szyfrowanie bazy danych:** Jeśli używasz `Drift`, upewnij się, że plik bazy danych jest szyfrowany (SQLCipher) kluczem generowanym i przechowywanym w `SecureStorage`.


13. 
**Wzmocnienie `DeviceIntegrityTask`:** Rozszerz sprawdzanie nie tylko o Root/Jailbreak, ale także o wykrywanie emulatorów, debugerów oraz obecność popularnych narzędzi do modyfikacji pamięci (np. Frida).


14. **Dynamiczna weryfikacja sum kontrolnych:** (Opcjonalnie) Mechanizm sprawdzający integralność kodu binarnego aplikacji przy starcie, aby wykryć próby modyfikacji pliku APK/IPA.
15. **Polityka czyszczenia pamięci:** Zaimplementuj `LifeCycleObserver`, który czyści wrażliwe dane z pamięci RAM (np. otwarte klucze kryptograficzne), gdy aplikacja przechodzi do tła na dłuższy czas.
16. **Obfuskacja kodu:** Skonfiguruj proces budowania (ProGuard/R8 dla Androida), aby utrudnić inżynierię wsteczną logiki biznesowej i kluczy API.

#### Stabilność i Error Handling

17. 
**Globalny Error Listener:** Wykorzystaj `GlobalErrorListener` do przechwytywania wyjątków biznesowych i mapowania ich na przyjazne dla użytkownika komunikaty `AppException` zamiast surowych błędów technicznych.


18. 
**Zasada "Fail-Fast" w `StartupRunner`:** Każdy błąd w zadaniu krytycznym (np. `SecurityInitTask`) musi natychmiast blokować start aplikacji z jasnym komunikatem dla użytkownika.


19. 
**Wersjonowane Migracje Danych:** Rozbuduj `MigrationService`, aby automatycznie obsługiwał zmiany schematu danych w `SecureStorage` przy aktualizacjach aplikacji, unikając crashy po zmianie kluczy.


20. **Obsługa Braku Sieci:** Dodaj globalny interceptor wykrywający brak połączenia z internetem przed wysłaniem żądania, co oszczędza zasoby i poprawia UX (Connectivity Plus).
21. 
**Standard Logowania Enterprise:** Wykorzystaj `AppLogger` do kategoryzacji logów (Verbose, Debug, Info, Warning, Error, Fatal) i przesyłania tylko tych krytycznych do systemów typu Sentry w trybie produkcyjnym.



#### UI/UX i Standardy Kodu

22. 
**Theme Extension:** Zamiast rozbudowanych plików styli, użyj `ThemeExtension` do definiowania specyficznych kolorów (np. `infoColor`, `warningColor`), co ułatwia zarządzanie motywem Dark/Light.


23. 
**Separacja Widgetów:** Rozbij duże ekrany (np. `SecuritySettingsScreen`) na mniejsze, atomowe komponenty (pliki typu `_PinSection.dart`), co poprawia czytelność i ułatwia refaktoryzację.


24. **Zarządzanie Zasobami:** Wygeneruj klasy stałych dla obrazów i assetów, aby uniknąć błędów typu "literówka w ścieżce" (np. `Assets.icons.lock.path`).
25. **Wykorzystanie `const`:** Rygorystycznie stosuj konstruktory `const` dla widgetów i dekoracji, aby zoptymalizować proces przebudowywania drzewa widgetów Fluttera.
26. 
**Uproszczenie Lokalizacji:** Zautomatyzuj generowanie kluczy tłumaczeń (już widoczne użycie `LocaleKeys`), ale upewnij się, że parametry (np. `appName`) są zawsze przekazywane jako nazwane argumenty.


27. 
**Rygorystyczne Typowanie:** Wyeliminuj użycie typu `dynamic` w modelach danych i odpowiedziach API na rzecz silnie typowanych klas `Freezed`.


28. **Obsługa "Large Fonts":** Upewnij się, że UI skaluje się poprawnie przy zmianie rozmiaru tekstu w systemie (Accessibility), unikając sztywnych wysokości kontenerów.
29. 
**Optymalizacja `ListView`:** W miejscach takich jak menu usług używaj `SliverGrid` lub `ListView.builder` zamiast mapowania list do Column, aby zapewnić płynne przewijanie (60/120 FPS).


30. **Dokumentacja Techniczna (DartDoc):** Każdy publiczny interfejs i metoda w warstwie `core` powinna posiadać dokumentację `///`, opisującą przeznaczenie i możliwe wyjątki.