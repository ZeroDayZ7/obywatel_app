### 1️⃣ `NotifierProvider<Notifier, State>` (TwoFa / Login nowo)

- **Stan**: przechowujesz w nim własny obiekt stanu (`LoginState`, `TwoFaState`) z polami jak `isLoading`, `errorMessage`, `data`.
- **UI**: obserwuje `ref.watch(provider)` i od razu może użyć np. `isLoading` do przycisku, `errorMessage` do pokazywania błędu.
- **Zalety**:

  - Masz pełną kontrolę nad tym, co jest w stanie.
  - Możesz ustawiać różne pola niezależnie (`state = state.copyWith(...)`).
  - Łatwo pokazać loading przy jednym przycisku i error w komponencie.

- **Kiedy używać**:

  - Gdy chcesz mieć **kontrolę nad polami UI**, np. loading przycisku, błędy walidacyjne, dane do formularza.
  - Gdy akcje są zależne od wielu pól, nie tylko od samej odpowiedzi async.

---

### 2️⃣ `AsyncNotifierProvider` / `AsyncValue<State>` (AsyncValue<LoginState>)

- **Stan**: automatycznie zarządza `loading`, `data` i `error`.
- **UI**: używasz `.when(loading: ..., data: ..., error: ...)`.
- **Zalety**:

  - Proste dla **czystych akcji async**, które zwracają dane.
  - Nie musisz sam ustawiać `isLoading`.

- **Wady**:

  - Trudniej **pokazać loading tylko przy jednym przycisku** i zachować resztę formularza aktywną.
  - Trudniej **mieszkać dane async i inne pola stanu** w jednym miejscu.

- **Kiedy używać**:

  - Gdy masz **proste fetchowanie danych**: np. pobranie listy, jeden endpoint, cały ekran czeka na wynik.
  - Gdy UI **nie potrzebuje kontroli poszczególnych pól**.

---

💡 **Podsumowanie dla Twojego przypadku**:

- Dla logowania i 2FA **lepiej używać zwykłego `NotifierProvider` z własnym stanem**, bo chcesz:

  - pokazać loading tylko na przycisku,
  - wyświetlić backendowy błąd w komponencie `ErrorMessage`,
  - zachować wartości pól formularza niezależnie od async.

- `AsyncValue` jest fajny do:

  - pełnoekranowego fetchowania list / danych (np. lista powiadomień, lista użytkowników),
  - gdzie cały ekran czeka na wynik i nie musisz kontrolować każdego pola UI.

---

### **Tabela Riverpod 3.0 – kiedy czego używać**

| Typ Provider / Notifier                        | Co przechowuje / robi                                                       | Kiedy używać                                                                                               | Jak używać / przykłady                                                                           |
| ---------------------------------------------- | --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| **Provider<T>**                                | Stała wartość lub serwis (np. logger, storage)                              | Kiedy masz **statyczny obiekt lub serwis**, którego stan się nie zmienia, albo jest zarządzany wewnętrznie | `final logger = ref.read(loggerProvider);`                                                       |
| **StateProvider<T>**                           | Prosty stan mutowalny (np. bool, int, string)                               | Kiedy chcesz **prosty stan lokalny**, który może się zmieniać w UI                                         | `ref.read(counterProvider.notifier).state++`                                                     |
| **FutureProvider<T>**                          | Asynchroniczna wartość z przyszłości (Future)                               | Kiedy chcesz **pobierać dane async i obserwować stan** (loading / data / error)                            | `final user = ref.watch(userFutureProvider);`                                                    |
| **StreamProvider<T>**                          | Strumień danych (np. WebSocket, Firebase)                                   | Kiedy masz **ciągły strumień danych**, np. powiadomienia                                                   | `final messages = ref.watch(messagesStreamProvider);`                                            |
| **Notifier<T>**                                | Zaawansowany **synchronizowany stan**, pełna kontrola nad metodami i logiką | Kiedy masz **własny stan i metody, które zmieniają stan**, ale nie potrzebujesz async auto-loading         | `class SecurityNotifier extends Notifier<void>`                                                  |
| **AsyncNotifier<T>**                           | Asynchroniczny stan z automatycznym zarządzaniem loading/error              | Kiedy chcesz, żeby Twój Notifier **sam obsługiwał Future/async** i miał wbudowane loading/error            | `class SecurityAsyncNotifier extends AsyncNotifier<SecurityState>`                               |
| **NotifierProvider<Notifier<T>, T>**           | Provider dla Notifier, daje dostęp do stanu                                 | Zawsze używasz, gdy chcesz **połączyć Notifier z UI**                                                      | `ref.watch(securityProvider)` zwraca stan, `ref.read(securityProvider.notifier)` wywołuje metody |
| **AsyncNotifierProvider<AsyncNotifier<T>, T>** | Provider dla AsyncNotifier                                                  | Tak samo jak powyżej, ale dla async                                                                        | `ref.watch(userProvider)` zwraca AsyncValue<User>`                                               |
| **Family**                                     | Tworzenie parametrów dla providerów (np. id użytkownika)                    | Kiedy Twój provider potrzebuje **parametru wejściowego**                                                   | `final userProvider = FutureProvider.family<User, String>((ref, userId) => fetchUser(userId));`  |
| **Scoped / Override**                          | Nadpisanie providerów w danym scope                                         | Kiedy chcesz **przetestować lub tymczasowo zmienić wartość**                                               | `ProviderScope(overrides: [loggerProvider.overrideWithValue(mockLogger)], child: MyApp())`       |

---

### **Kiedy używać Notifier vs AsyncNotifier**

| Cecha / Kryterium                     | Notifier                                                                     | AsyncNotifier                                                                                   |
| ------------------------------------- | ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Stan synchroniczny czy asynchroniczny | Synchroniczny                                                                | Asynchroniczny (Future)                                                                         |
| Metody zmieniające stan               | Tak, dowolne                                                                 | Tak, ale metody async mogą ustawiać `state = AsyncValue.loading()` / `data()` / `error()`       |
| Idealne zastosowania                  | Logika biznesowa, metody typu `lockApp()`, `skipPinSetup()`                  | Fetch danych z API, inicjalizacja serwisów async, np. `initSecurityService()`                   |
| UI                                    | `ref.watch(myNotifierProvider)` zwraca **stan**, możesz reagować w builderze | `ref.watch(myAsyncNotifierProvider)` zwraca **AsyncValue**, łatwo obsłużyć `loading/error/data` |

---

### **Praktyczne wskazówki i dobre praktyki Riverpod 3.0**

1. **Serwisy i singletony → Provider**
   Każdy logger, storage, API client trzymamy w prostym `Provider`.
2. **Proste zmienne UI → StateProvider**
   np. `isDarkMode`, `selectedIndex`, lokalne przełączniki.
3. **Kompleksowe logiki → Notifier**
   Jeżeli masz klasę z metodami, które manipulują stanem – używaj Notifier.
4. **Async operacje → AsyncNotifier / FutureProvider**
   Kiedy chcesz, żeby UI reagowało na stan loading / error / success automatycznie.
5. **Nie używaj `read` do śledzenia stanu w build()**
   W build() zawsze `watch` – żeby widgety reagowały na zmiany.
6. **`.notifier` tylko do wywoływania metod**
   Stan zawsze obserwuj przez `ref.watch(provider)`.
7. **Family → parametry**
   Zamiast tworzyć wiele providerów dla różnych danych, użyj `.family`.
8. **Override / testowanie**
   ProviderScope pozwala nadpisywać serwisy dla testów lub mocków.
