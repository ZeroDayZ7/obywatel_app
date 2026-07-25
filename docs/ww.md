**1. Argon2id do hashowania PIN-u jest drastycznie osłabiony.** W `HashService`:

```dart
static final _argon = Argon2id(
  memory: 1 * 1024, // 64 MB  <- komentarz kłamie, to 1 MB
  iterations: 1, //  3         <- komentarz mówi 3, kod ma 1
  parallelism: 1,
  hashLength: 32,
);
```

**4. Reset hasła nie działa wcale, mimo że UI pokazuje sukces.** W `ResetPasswordNotifier.confirmReset` cała logika wywołania `resetPasswordFinal(...)` jest zakomentowana, a mimo to stan i tak przechodzi na `ResetPasswordState.completed()`. Użytkownik dostaje ekran sukcesu, a hasło na serwerze się nie zmienia.

**5. Auto-wylogowanie po unieważnionej sesji (401) jest martwym kodem.** `SessionStatus.expired` → `logout()` jest podłączone w `SessionObserver`, ale jedyne miejsce, które miało to zgłaszać (`SecuritySyncInterceptor.onError`), ma tę linię zakomentowaną:

```dart
// ref.read(sessionStatusProvider.notifier).reportInvalidSession();
```

`reportInvalidSession()` nie jest wywoływane z żadnego innego miejsca w całym projekcie — cały mechanizm jest niepodłączony.

**7. Generator „silnego hasła” automatycznie kopiuje je do schowka.** `PasswordInputWidget._generateStrongPassword()` robi `Clipboard.setData(...)` bez pytania i bez późniejszego czyszczenia schowka — inne aplikacje mogą je odczytać.

**8. Domyślne dane logowania są zawsze wstrzykiwane w pola formularza.** `LoginForm` wypełnia email/hasło z `apiConstants.defaultEmail/defaultPassword` niezależnie od środowiska; czyszczone dopiero _po_ próbie logowania i tylko gdy `isProduction == true`. To ryzykowne w buildach niepublicznych/staging pokazywanych klientowi.

## 🟠 Duplikacja i martwy kod

**11. Dwie różne definicje `ResetPasswordState`** — jedna jako `part` w `reset_password_notifier.dart` (z `token`/`challenge`), druga w osobnym `domain/reset_password_state.dart` (inne pola, inne warianty: `sendingCode`, `verifyingCode`, `resettingPassword`, `error`). Ta druga wygląda na pozostałość po wcześniejszym refaktorze i nigdzie nie jest realnie używana w UI — myląca nazwa-duplikat w tym samym projekcie.

## 🟡 Niespójności logiczne / UX

**15. Komunikat „pozostałe próby” zakłada limit 5, a realny próg blokady w `PinAttemptLimiter` to 3 próby** (`if (attempts < 3) return Duration.zero`). Użytkownik dostanie błędną liczbę pozostałych prób.

**16. Przełącznik „Zaufaj temu urządzeniu” w setupie jest de facto kosmetyczny.** `canFinish = pinSet && trustDevice` blokuje przycisk „Zakończ”, ale `completeSetup()` i tak zawsze wywołuje `registerTrustedDevice()`, niezależnie od wartości przełącznika — czyli wymuszona, pozorna zgoda.

## ⚙️ Architektura silnika

**21. `AuthService.login` wysyła hasło jako `List<int>` bezpośrednio w JSON body** (`'password': passwordBytes`), czyli tablicę liczb, nie string. Warto zweryfikować kontrakt z backendem — to nietypowe i podatne na błędy serializacji (czy backend na pewno oczekuje tablicy kodów, a nie base64/UTF-8 stringa?).

**22. Trzy niemal identyczne kliencich HTTP** (`ApiClient`, `NoAuthApiClient`, `PublicApiClient`) — cienkie wrappery `get/post/put/delete` powielone trzykrotnie. Dobry kandydat na wspólny generyczny interfejs/mixin zamiast kopiowania.

**25. Bardzo „gadatliwy” `rootGuard` w routerze** — wieloliniowe interpolacje stringów budowane przy _każdej_ zmianie trasy, nawet gdy poziom logowania jest wyższy niż debug (interpolacja i tak się wykonuje). Drobny, ale niepotrzebny narzut przy każdej nawigacji.

**26. `AuthController._handleAuthResponse` robi zbyt wiele naraz:** zarządzanie stanem, zapis sesji, aktualizacja tokenów w Fresh, tworzenie `PendingSession`, logi diagnostyczne. Część tej orkiestracji dobrze by pasowała do `SessionService`/`AuthService`, żeby kontroler był cieńszy i łatwiejszy w testach.

**27. Polityka walidacji hasła jest rozproszona** — `Validators.validatePassword(val, minLength: 8)` w resecie hasła vs prawdopodobnie inny domyślny limit w loginie/rejestracji. Upewnij się, że reguły hasła (długość, wymagane znaki) są zdefiniowane raz i identyczne we wszystkich miejscach.

## ❓ Rzeczy, które wyglądają na jawnie nierozwiązane

**28. Brak obsługi błędu w połowie rejestracji zaufanego urządzenia.** Jeśli `registerTrustedDevice()` padnie po wygenerowaniu pary kluczy (`generateAndHoldKeyPair()`), ale przed wysłaniem podpisu do API, stan lokalny (klucz w pamięci `cryptoServiceProvider`) i stan serwera się rozjeżdżają — nie ma ścieżki „spróbuj ponownie” bez cofania się do ekranu logowania.

**29. Brak jasnego rozróżnienia w UI między „PIN niepoprawny” a „sesja wygasła po stronie serwera”** po udanej weryfikacji PIN-u — `unlockWithPinAndValidateSession()` w obu przypadkach kończy tym samym `logout()` i tym samym komunikatem błędu.

**30. `SecureTokenStorage.read()` przy zimnym starcie tworzy „pusty” `OAuth2Token(accessToken: '', refreshToken: ...)`, żeby wymusić refresh przez Fresh.** Nie widać żadnego zabezpieczenia/testu na wyścig, gdy dwa requesty równolegle uderzą w ten sam „pusty” token na starcie appki (typowy problem z `fresh_dio` przy wielu jednoczesnych żądaniach 401) — `fresh_dio` teoretycznie to ogarnia, ale warto to potwierdzić testem integracyjnym, bo konsekwencją błędu byłoby podwójne odświeżanie tokena.

---

**Jeśli miałbyś naprawić tylko 3 rzeczy w tym tygodniu**, to w tej kolejności: **#1** (Argon2id dla PIN-u — realna dziura bezpieczeństwa), **#4** (reset hasła udający sukces bez wysyłki do API) i **#5+#6** (martwy auto-logout na 401/root-detection — to jest rdzeń modelu bezpieczeństwa i obecnie nie działa tak, jak sugeruje reszta kodu).
