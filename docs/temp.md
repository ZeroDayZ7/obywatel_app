### A. Bezpieczeństwo E2EE i Signal

Punkty 1–12 · najwyższy priorytet

<!-- 1

Usunąć trwały zapis plaintextu z `SecureStorage`, jeśli nie jest rzeczywiście konieczny.

W `ChatsRepositoryImpl` istnieją metody `_persistPlaintextForMessage` i `_hydratePlaintextCacheForIds`, które przechowują odszyfrowane wiadomości w osobnym magazynie. Trzeba ustalić, czy zawartość powinna znajdować się w bazie Drift, w pamięci, czy w szyfrowanym magazynie lokalnym. Nie utrzymywać niepotrzebnych kopii plaintextu. -->

<!-- 2

Nie udostępniać klucza prywatnego przez model transportowy.

`ensureDeviceIdentityBundle()` zwraca `privateKey`, choć rejestracja na serwerze korzysta z kluczy publicznych. Rozdzielić model lokalnego materiału kryptograficznego od `DeviceKeyRegistrationRequest`, który nie powinien w ogóle posiadać pola klucza prywatnego. -->

3

Rozdzielić identyfikator urządzenia aplikacji od identyfikatora urządzenia Signal.

`senderDeviceId` w API i numeryczny identyfikator w `SignalProtocolAddress` to różne pojęcia. Wprowadzić jednoznaczne typy, np. `AppDeviceId` i `SignalDeviceId`, zamiast przekazywać oba jako `String` lub `int` bez wyraźnej granicy.

4

Nie utożsamiać pobrania PreKey Bundle z weryfikacją tożsamości.

`initializeSessionForPeer()` pobiera istniejącą tożsamość i fingerprint, ale należy zweryfikować politykę zmiany klucza. Zmiana klucza partnera powinna być jawnie obsłużona i nie może po cichu oznaczać automatycznego zaakceptowania nowej tożsamości.

5

Usunąć fallbacki, które ukrywają brak prawidłowego identyfikatora.

W `resolveInboundSignalDeviceCandidates()` istnieje ścieżka próbująca rozwiązać identyfikator UUID przez PreKey Bundle. Należy jawnie modelować mapowanie identyfikatora urządzenia aplikacji na identyfikator Signal. Nie próbować deszyfrowania na podstawie zgadywanego identyfikatora.

6

Naprawić i przetestować odtwarzanie tożsamości urządzenia.

`_hasPersistedDeviceIdentityMaterial()` sprawdza podpisany prekey i dziesięć kluczy jednorazowych. Nie jest to pełna walidacja spójności magazynu. Brakujące lub zużyte prekeys powinny prowadzić do kontrolowanego uzupełniania kluczy zgodnie z protokołem, a nie do przypadkowego odtwarzania tożsamości.

7

Zabezpieczyć rejestrację kluczy przed wyścigami.

`_deviceIdentityRegistrationTask` zapobiega części równoległych rejestracji w ramach jednej instancji. Zweryfikować równoległe wywołania z wielu ścieżek, odtworzenie procesu i przypadki błędów po stronie serwera.

8

Zastąpić marker rejestracji jednoznacznym stanem lokalnym.

`e2ee_device_registration_marker` porównuje `toString()` mapy z zapisanym ciągiem. Lepiej użyć jawnego, stabilnego formatu serializacji i wersjonowanego modelu stanu, bez przechowywania prywatnych danych w markerze.

9

Ograniczyć logowanie danych kryptograficznych.

W logach `E2EE_TRACE` pojawiają się fingerprinty, identyfikatory użytkowników, długości plaintextu i szczegóły błędów. Nie logować treści, kluczy, tokenów ani surowych payloadów. Ustalić politykę redakcji identyfikatorów i poziomów logowania dla produkcji.

10

Rozdzielić błędy szyfrowania, braku sesji i niepoprawnego ciphertextu.

`EncryptionFailureException` jest używany zarówno przy szyfrowaniu, jak i po nieudanych próbach deszyfrowania. Wprowadzić typowane błędy, aby UI mogło rozróżnić brak sesji, nieznany klucz, niepoprawny ciphertext i błąd magazynu.

11

Ograniczyć przechowywanie kluczy załączników i metadanych.

Zweryfikować użycie `attachment-key`, `attachment-meta` i `attachment-preview`. Klucz powinien być chroniony, metadane nie powinny być duplikowane bez potrzeby, a cache podglądów powinien mieć określone zasady usuwania i ograniczenia rozmiaru.

12

Dodać testy bezpieczeństwa dla całego cyklu Signal.

Testować pierwszą wiadomość, wiadomość po istniejącej sesji, restart aplikacji, zmianę tożsamości partnera, zużycie prekey, brak lokalnej sesji i błędny ciphertext. Testy muszą obejmować dwóch niezależnych użytkowników i osobne magazyny kluczy.

### B. Synchronizacja, outbox i WebSocket

Punkty 13–24 · krytyczne dla niezawodności komunikatora

13\. Podzielić `ChatSyncService` na mniejsze klasy. Obecna klasa odpowiada za stan synchronizacji, obsługę połączenia, wysyłanie outboxa, parsowanie payloadów i pobieranie danych.

14\. Wydzielić `OutboxProcessor`. Ma odpowiadać za pobranie zdarzeń, walidację, wysyłkę, retry i potwierdzenie dostarczenia do serwera.

15\. Wydzielić `DeltaSyncService`. Pobieranie zmian, parsowanie odpowiedzi, deszyfrowanie i aktualizowanie checkpointów nie powinno być rozproszone między jedną metodą synchronizacji a repozytorium.

16\. Wprowadzić typowany model zdarzenia outbox. Zamiast wielokrotnie dekodować `Map<String, dynamic>`, stworzyć np. `OutboxMessageEvent` z jawnie określonymi polami i walidacją.

<!-- 17\. Usunąć powielone parsowanie payloadu. `rawPayloadByMessageId` i alternatywne odczyty `type`, `signalType`, `eventId` oraz `outboxEventId` wskazują na kilka wariantów tego samego kontraktu. W pierwszej wersji należy wybrać jeden kanoniczny format. -->

<!-- 18\. Nie stosować automatycznego fallbacku Signal type na `1` dla niepoprawnych danych. W `ChatSyncService` brak `type` prowadzi do wartości domyślnej. Brak wymaganych danych powinien zostać wykryty podczas walidacji, a nie zamieniony w pozornie prawidłową wiadomość. -->

19\. Nie usuwać wiadomości z outboxa przed potwierdzeniem trwałego zapisu. Zweryfikować, czy `sendOutboxBatch()` zwraca potwierdzenie dla każdego zdarzenia, czy tylko dla całej paczki. W przypadku częściowego sukcesu nie wolno utracić niepotwierdzonych wiadomości.

20\. Ujednolicić idempotencję. `eventId`, `messageId` i `idempotencyKey` powinny mieć jasno określone znaczenie. Ponowienie tego samego zdarzenia nie może tworzyć nowej wiadomości ani powodować błędnego potwierdzenia.

21\. Wprowadzić ograniczone retry z backoffem. Zamiast prostego zwiększania `retryCount` potrzebne są limity, opóźnienie wykładnicze z jitterem, obsługa błędów trwałych i możliwość wznowienia po ponownym połączeniu.

22\. Nie blokować całej synchronizacji przez jeden niegotowy wpis. Wpis z nieznanym `conversationId` powinien pozostać w kolejce i mieć konkretny powód blokady. Musi istnieć sposób jego późniejszego rozwiązania lub zgłoszenia błędu.

23\. Zapewnić jeden koordynator synchronizacji. `_isSyncing` zabezpiecza przed równoległym wykonaniem w ramach jednej instancji, ale warto sprawdzić kolejkę kolejnych wywołań, wyścigi z WebSocketem i ponowne uruchomienie synchronizacji w trakcie działania.

24\. Zdefiniować cykl życia połączenia WebSocket. Połączenie, subskrypcje, reconnect, synchronizacja po reconnect i zamykanie zasobów muszą mieć jednoznacznego właściciela. `dispose()` powinno być asynchronicznie i deterministycznie obsłużone tam, gdzie wymagane jest oczekiwanie na zakończenie subskrypcji.

### C. Repozytoria, baza lokalna i model domenowy

Punkty 25–34

25\. Rozdzielić `ChatsRepositoryImpl` według odpowiedzialności. Wydzielić obsługę wiadomości, konwersacji, synchronizacji, cache plaintextu oraz załączników. Nie należy tworzyć pięciu repozytoriów, które wszystkie bezpośrednio modyfikują te same tabele.

26\. Ograniczyć dostęp aplikacji do wewnętrznych szczegółów Drift. Kod aplikacyjny nie powinien w wielu miejscach korzystać z `_repository.db.outboxDao`. Repozytorium powinno udostępniać operacje domenowe, np. `getRetryEligibleOutboxEvents()`.

27\. Zastąpić mapy dynamiczne modelami DTO. `syncDeltaFromRemote()` zwraca `Future<List<Map<String, dynamic>>>`. Wprowadzić typowany wynik synchronizacji, np. `SyncDeltaResult`, z osobnymi kolekcjami wiadomości, kontaktów i checkpointów.

28\. Uprościć cache plaintextu i aliasy ID. `LocalPlaintextMessageCache` tworzy relacje aliasów między identyfikatorami. To sygnał, że model tożsamości wiadomości może być niejednoznaczny. Wiadomość powinna mieć jeden stabilny identyfikator; relację z lokalnym zdarzeniem należy modelować osobno, jeśli faktycznie jest potrzebna.

29\. Zlikwidować potencjalne zapytania N+1. `watchConversations()` pobiera konwersacje, a potem osobno ostatnie wiadomości każdej z nich i dodatkowo odczytuje cache. Dla wielu konwersacji może to generować kosztowne serie zapytań i operacji I/O.

30\. Nie wykonywać zbędnych zapisów w Secure Storage. Sprawdzić, czy plaintext i metadane załączników są zapisywane wielokrotnie przy każdej synchronizacji. Zapisy powinny być idempotentne, ograniczone do rzeczywistych zmian i objęte jasną polityką retencji.

31\. Ujednolicić walidację UUID. Nie tworzyć osobnych, nieco różniących się walidatorów w outboxie, repozytorium i warstwie E2EE. Wprowadzić jawne typy identyfikatorów oraz wspólną walidację na granicach systemu.

32\. Oddzielić stan lokalny od stanu serwera. `pending`, `sent`, `delivered`, `read`, `failed` powinny mieć jednoznaczne znaczenie. Nie opierać ich na przypadkowych stringach w wielu warstwach.

<!-- 33\. Ujednolicić zapis czasu. Wymagać UTC w kontrakcie transportowym, a strefę lokalną stosować wyłącznie w prezentacji. Nie zastępować błędnej daty `DateTime.now()` bez jawnego oznaczenia, że czas jest nieznany. -->

34\. Zapewnić transakcyjność aktualizacji wiadomości. Zapis ciphertextu, aktualizacja stanu wiadomości, identyfikatora załącznika i checkpointu synchronizacji powinny być spójne. Nie wolno przesuwać checkpointu, jeśli dane, których dotyczy, nie zostały trwale zapisane.

### D. Riverpod, DI i stan aplikacji

Punkty 35–42

35\. Ujednolicić generowane i ręcznie deklarowane providery. W kodzie występują `@riverpod`, `NotifierProvider` i `AsyncNotifierProvider`. To nie jest automatycznie błąd, ale warto przyjąć konwencję: generowanie dla standardowych providerów i ręczne deklaracje tylko tam, gdzie faktycznie upraszczają kod.

36\. Używać `ref.watch` do zależności reaktywnych, `ref.read` do akcji. Provider nie powinien niepotrzebnie reagować na zmianę zależności, jeżeli potrzebuje jej tylko do jednorazowej operacji.

37\. Zadbać o cykl życia usług. `ChatSyncService` rozpoczyna subskrypcję przez `init()`, a następnie jest zwalniany w `ref.onDispose`. Należy określić, czy usługa ma być singletonem w zakresie sesji, czy tworzona na potrzeby konkretnego ekranu.

<!-- 38\. Nie tworzyć loggera bezpośrednio wewnątrz serwisu. `ContactsService` używa `AppLogger()`, mimo że aplikacja posiada `appLoggerProvider`. Wstrzykiwanie zależności poprawi testowalność i spójność konfiguracji. -->

39\. Uprościć stan aktywacji komunikatora. `MessagingActivationState` ma osobne statusy, warunki wyświetlania onboardingu i obsługę błędów. Rozdzielić status serwerowy, stan akceptacji regulaminu i stan gotowości E2EE, aby sukces jednej operacji nie maskował porażki innej.

40\. Unikać ręcznego utrzymywania providerów dla prostych wartości. Jeśli `ChatSyncStatusController` jedynie udostępnia `SyncStatus`, sprawdzić, czy może zostać scalony z kontrolerem synchronizacji. Nie należy jednak łączyć stanu UI z całą logiką transportową.

41\. Zastosować jawne stany ładowania i błędów. Dla kontaktów, rozmów i aktywacji używać spójnych stanów asynchronicznych. Nie zastępować błędu pustą listą, jeśli UI ma odróżniać brak danych od błędu sieci.

42\. Dodać testy providerów bez uruchamiania całej aplikacji. Testować przejścia stanu, anulowanie subskrypcji, błędy API, wznowienie połączenia i zachowanie po odtworzeniu stanu z magazynu.

### E. UI, podział widgetów i płynność renderowania

Punkty 43–52

43\. Rozbić `MessageBubble` na komponenty prezentacyjne. Widoczny kod obsługuje treść, metadane załącznika, pobieranie podglądu, deszyfrowanie pliku i stan ładowania. Docelowo `MessageBubble` powinien przede wszystkim komponować widok, a logikę załączników należy przenieść do kontrolera lub dedykowanej warstwy aplikacyjnej.

44\. Usunąć sieć i kryptografię z `build()`. `FutureBuilder` z `_resolvePreviewBytes()` może uruchamiać ponowne pobieranie i deszyfrowanie przy kolejnych przebudowach widgetu. Zadanie powinno mieć stabilny cykl życia i cache wyników, np. przez odpowiedni provider rodziny.

45\. Nie tworzyć nowego `Dio()` przy pobieraniu każdego podglądu. Wykorzystywać współdzielonego klienta pobierania z timeoutami, kontrolą przekierowań, limitami rozmiaru i anulowaniem żądań.

46\. Wydzielić `MessageTextContent`, `MessageAttachmentPreview`, `MessageTimestamp` i `MessageStatusIndicator`. Każdy element powinien otrzymywać tylko potrzebne dane. Zmiana statusu wiadomości nie powinna niepotrzebnie przebudowywać ciężkiego podglądu załącznika.

47\. Użyć `ListView.builder` lub `SliverList` dla wiadomości. Unikać budowania całej historii naraz. W większych rozmowach dodać paginację historii i stabilne klucze elementów.

48\. Zachować pozycję przewijania. Nowa wiadomość nie powinna wymuszać skoku na dół, jeśli użytkownik przegląda starsze wiadomości. Oddzielić dodanie wiadomości od decyzji UI o przewinięciu.

49\. Rozdzielić stan listy konwersacji od stanu otwartego czatu. Aktualizacja jednej wiadomości nie powinna odświeżać całej listy kontaktów, wszystkich konwersacji i całego ekranu.

50\. Używać `select` tam, gdzie ogranicza przebudowy. Widget, który potrzebuje wyłącznie licznika nieprzeczytanych wiadomości lub jednego statusu, nie powinien obserwować całego obiektu zawierającego wszystkie wiadomości.

51\. Wydzielić czyste widoki stanów ekranów. W kontaktach już występują osobne komponenty błędu i pustego stanu. Ujednolicić podejście dla list rozmów, ładowania historii, braku sesji E2EE, braku sieci i błędu załącznika.

52\. Mierzyć wydajność przed dodaniem optymalizacji. W trybie profile sprawdzić liczbę przebudów, czas budowania listy, czas deszyfrowania załączników, liczbę zapytań Drift i liczbę odczytów Secure Storage. Dopiero potem dodawać `const`, `select`, memoizację i cache tam, gdzie faktycznie pomagają.

### F. CamelCase, DTO i kontrakty API

Punkty 53–58

53\. Ustalić jeden kanoniczny format JSON. `conversationId`, `messageId`, `senderDeviceId`, `eventId`, `createdAt`, `signalType` — z dokładnym określeniem, które pola należą do danego endpointu.

54\. Usunąć rozproszone odczyty alternatywnych nazw. Przykłady to `sender_id` i `senderId` oraz `type` i `signalType`. Jeśli wybieramy camelCase, kod nie powinien bez końca akceptować wszystkich wariantów historycznych.

55\. Nie dodawać globalnego snake-case normalizatora. Każdy DTO ma mieć jawne `fromJson` i `toJson`, a format kontraktu ma być testowany. Niepotrzebne automatyczne konwersje utrudniają wykrycie błędów.

56\. Usunąć duplikaty pól w payloadach rejestracji. `identityPublicKey` i `publicKey` są wysyłane z tą samą wartością. Pozostawić jedno pole kanoniczne po potwierdzeniu zgodności backendu.

57\. Nie mieszać `content`, `ciphertext` i `encryptedPayload`. Wprowadzić jeden model wiadomości transportowej z polem `ciphertext`, a tekst odszyfrowany przechowywać oddzielnie w modelu prezentacyjnym lub lokalnym modelu wiadomości.

58\. Testować kontrakty po obu stronach. Testy Dart i Go powinny potwierdzać te same nazwy pól, typy, wymagane wartości i obsługę niepoprawnych payloadów. Testy powinny wykrywać powrót pól snake_case.

## 4. Dodatkowe problemy, które warto objąć audytem

Te punkty wymagają weryfikacji pełnego przepływu, zanim zostaną uznane za błędy produkcyjne.

59\. Obsługa wielu urządzeń na użytkownika. Zweryfikować, czy wiadomość jest szyfrowana dla wszystkich wymaganych urządzeń odbiorcy oraz innych własnych urządzeń nadawcy, zgodnie z przyjętym modelem Signal.

60\. Weryfikacja uprawnień do konwersacji. Backend musi sprawdzać członkostwo nadawcy, uprawnienia urządzenia i dostęp odbiorcy do konkretnej konwersacji. Sam poprawny UUID nie jest autoryzacją.

61\. Bezpieczne URL-e załączników. Zweryfikować pobieranie z URL-i podpisanych: domeny, przekierowania, limity czasu i rozmiaru, a także to, czy klient nie przesyła przypadkowo tokenu API do obcego hosta.

62\. Weryfikacja integralności załączników. Przed udostępnieniem odszyfrowanego pliku sprawdzać rozmiar i hash zgodnie z protokołem. Nie traktować samego udanego pobrania jako dowodu poprawności pliku.

63\. Limity rozmiaru wiadomości i batchy. Ograniczyć liczbę zdarzeń w paczce, rozmiar ciphertextu i liczbę operacji deszyfrowania wykonywanych jednocześnie.

64\. Paginacja i checkpointy. W backendzie widać `HasMore: false` w odpowiedzi delta sync. Zweryfikować, czy kontrakt rzeczywiście gwarantuje pełny wynik, czy może pomijać wiadomości przy większej historii.

65\. Powiadomienia i zdarzenia WebSocket. Zdarzenie push powinno być sygnałem do aktualizacji danych, a nie jedynym źródłem prawdy. Po reconnect aplikacja powinna móc odtworzyć stan z serwera.

66\. Testy izolacji użytkowników. W testach backendu sprawdzić, czy użytkownik nie może odczytać wiadomości, kontaktów, metadanych ani załączników innego użytkownika przez podstawienie identyfikatora.

67\. Polityka logów produkcyjnych. Ustalić retencję, poziomy logowania, redakcję identyfikatorów i możliwość wyłączenia szczegółowych śladów kryptograficznych bez utraty kluczowych informacji diagnostycznych.

68\. Konfiguracja środowisk. Oddzielić adresy API, WebSocket i storage dla środowisk lokalnego, testowego i produkcyjnego. Nie pozwolić, by podgląd załącznika omijał centralną konfigurację sieciową.

69\. Testy restartu i trybu offline. Sprawdzić zamknięcie aplikacji podczas wysyłania, brak sieci, ponowne połączenie, restart podczas retry oraz odtworzenie sesji Signal z lokalnej bazy.

70\. Testy obciążeniowe i profilowanie. Sprawdzić wiele konwersacji, długie historie, tysiące wiadomości i równoległe pobieranie załączników. Ustalić mierzalne cele wydajnościowe przed optymalizacją.

## 5. Docelowa struktura katalogów

Nie robiłbym refaktoryzacji przez przeniesienie każdego pliku do kolejnego katalogu. Celem jest oddzielenie odpowiedzialności, przy zachowaniu prostej nawigacji.

Proponuję następujący kierunek dla `features/communication`:

```

features/communication/
├── domain/
│   ├── models/
│   │   ├── message.dart
│   │   ├── conversation.dart
│   │   └── contact.dart
│   ├── repositories/
│   │   ├── chats_repository.dart
│   │   └── contacts_repository.dart
│   └── value_objects/
│       ├── app_device_id.dart
│       ├── signal_device_id.dart
│       └── conversation_id.dart
│
├── application/
│   ├── messaging/
│   │   ├── send_message_service.dart
│   │   └── receive_message_service.dart
│   ├── sync/
│   │   ├── chat_sync_service.dart
│   │   ├── delta_sync_service.dart
│   │   └── sync_status.dart
│   ├── outbox/
│   │   ├── outbox_processor.dart
│   │   ├── outbox_event.dart
│   │   └── outbox_event_builder.dart
│   ├── e2ee/
│   │   ├── e2ee_crypto_service.dart
│   │   ├── device_identity_service.dart
│   │   └── session_service.dart
│   └── contacts/
│       ├── contacts_service.dart
│       └── contact_invite_error_mapper.dart
│
├── data/
│   ├── datasources/
│   │   ├── chats_api_client.dart
│   │   ├── chats_ws_client.dart
│   │   └── messaging_activation_api_client.dart
│   ├── dto/
│   ├── mappers/
│   └── repositories/
│       ├── chats_repository_impl.dart
│       └── contacts_repository_impl.dart
│
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
        ├── messages/
        │   ├── message_list.dart
        │   ├── message_bubble.dart
        │   ├── message_text_content.dart
        │   ├── message_attachment_preview.dart
        │   └── message_status_indicator.dart
        ├── conversations/
        └── contacts/

```

To jest struktura docelowa, a nie polecenie przeniesienia wszystkiego naraz. Należy dostosować ją do istniejących importów, plików generowanych i testów. Nie duplikować modeli, jeśli istnieją już ich odpowiedniki.

## 6. Co robić najpierw — kolejność wdrażania

Etap 1 — zabezpieczenie fundamentów

P0

Sprawdzić przepływ kluczy prywatnych, trwałe przechowywanie plaintextu, identyfikatory urządzeń Signal, obsługę zmiany tożsamości oraz poprawność deszyfrowania. Dodać testy regresyjne.

Etap 2 — niezawodna wysyłka i synchronizacja

P0

Ustalić kanoniczny kontrakt outbox, idempotencję, potwierdzenia, retry i checkpointy. Nie refaktoryzować jednocześnie logiki konwersacji i UI.

Etap 3 — porządek architektoniczny

P1

Podzielić repozytorium i synchronizację na mniejsze klasy, wprowadzić typowane DTO oraz ujednolicić Riverpod.

Etap 4 — płynne UI i załączniki

P1

Rozbić widgety wiadomości, usunąć kosztowne operacje z renderowania, zoptymalizować zapytania Drift i ograniczyć zbędne przebudowy.

Etap 5 — finalna walidacja

P2

Testy kontraktów Dart/Go, testy dwóch użytkowników, restart aplikacji, offline, załączniki, `flutter analyze`, testy Flutter i profilowanie.

## 7. Gotowy prompt dla agenta kodującego

Ten prompt możesz przekazać agentowi pracującemu na repozytorium. Ma realizować refaktoryzację etapami, a nie tylko wygenerować listę zmian.

# Zadanie: profesjonalna refaktoryzacja komunikatora E2EE w Obywatel Plus

## Cel

Przeprowadź dokładny audyt i etapową refaktoryzację istniejącego komunikatora Flutter + Riverpod + Drift + Signal E2EE oraz powiązanego backendu Go.

Celem jest uzyskanie czytelnej, testowalnej, bezpiecznej i wydajnej architektury produkcyjnej. Nie dodawaj nowych funkcji produktowych. Skup się na poprawności, separacji odpowiedzialności, bezpieczeństwie, niezawodności i jakości kodu.

## Bezwzględne wymagania

1. Nie wprowadzaj migracji bazy danych. To pierwsza wersja, więc schemat, modele i lokalne kontrakty można zmieniać, jeżeli nie ma to negatywnego wpływu na istniejący backend i uruchamialność aplikacji.
2. Używaj camelCase w kodzie Dart, JSON i kontraktach komunikatora.
3. Nie twórz globalnych snake_case normalizatorów, automatycznych konwerterów nazw ani rozbudowanej warstwy zgodności z niepotrzebnymi wariantami pól.
4. W przypadku istniejącego kontraktu snake_case sprawdź wszystkie zależności backendu. Zmień kontrakt jawnie, jeżeli można to zrobić bezpiecznie. Nie łam działających endpointów przez jednostronną zmianę Fluttera.
5. Nie pozostawiaj wielu alternatywnych nazw tego samego pola, jeżeli nie ma uzasadnionej potrzeby obsługi istniejących danych.
6. Stosuj Riverpod konsekwentnie. Wykorzystuj generowanie providerów tam, gdzie upraszcza kod, ale nie wykonuj mechanicznej zamiany wszystkich providerów.
7. Rozbijaj duże klasy i widgety według odpowiedzialności. Nie twórz abstrakcji wyłącznie po to, żeby zwiększyć liczbę plików.
8. Nie implementuj własnego protokołu kryptograficznego. Zachowaj sprawdzoną bibliotekę Signal.
9. Nie usuwaj testów, nie wyłączaj asercji i nie maskuj błędów pustymi wartościami.
10. Nie wykonuj niepowiązanych refaktoryzacji backendu ani innych modułów platformy.

## Zakres audytu

A. E2EE:

- Tożsamość urządzenia i rozdzielenie identyfikatora urządzenia aplikacji od numerycznego identyfikatora Signal.
- Rejestracja kluczy publicznych i ochrona kluczy prywatnych.
- Trwałość magazynu Signal, inicjalizacja sesji, zmiany tożsamości, PreKey Bundle i deszyfrowanie.
- Ograniczenie przechowywania plaintextu i metadanych załączników.
- Typowane błędy kryptograficzne i bezpieczne logowanie.

B. Wiadomości i synchronizacja:

- ChatSyncService, DeltaSyncService, OutboxProcessor i obsługa WebSocket.
- Idempotencja, potwierdzenia, retry, checkpointy, kolejność wiadomości i duplikaty.
- Walidacja payloadów oraz jednoznaczny kontrakt camelCase.
- Transakcyjność lokalnego zapisu i odporność na restart/offline.

C. Dane:

- ChatsRepositoryImpl i ContactsRepositoryImpl.
- Rozdzielenie logiki bazy, sieci, kryptografii i prezentacji.
- Typowane DTO, jawne mapowanie i walidacja identyfikatorów.
- Usunięcie niepotrzebnego cache, aliasów identyfikatorów i wielokrotnych zapisów.

D. Riverpod:

- Cykl życia usług, subskrypcje i anulowanie.
- Spójne stany ładowania, błędów, offline i synchronizacji.
- Ograniczenie zbędnych zależności reaktywnych.
- Testowalność providerów.

E. UI i wydajność:

- Rozbijanie MessageBubble i podobnych dużych widgetów.
- Brak pobierania sieciowego, odczytów Secure Storage i ciężkiej kryptografii bezpośrednio w build().
- ListView\.builder/SliverList, stabilne klucze, paginacja, zachowanie pozycji przewijania.
- Riverpod select i ograniczanie niepotrzebnych przebudów.
- Eliminacja zapytań N+1 i zbędnego I/O.
- Współdzielony klient HTTP dla pobierania załączników.

F. Backend:

- Zgodność kontraktów JSON z Flutterem.
- Idempotencja zapisu wiadomości i outbox.
- Autoryzacja członkostwa w konwersacji oraz dostępu do załączników.
- Prawidłowa paginacja delta sync i dostarczanie zdarzeń WebSocket.
