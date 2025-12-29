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