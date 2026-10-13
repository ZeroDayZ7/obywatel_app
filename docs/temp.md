prompt na poźniej

Przejrzałem diff oraz zapis pracy agenta. Walidacja zaproszeń to dobry pierwszy krok, ale nie uznałbym jeszcze całego mechanizmu kontaktów za produkcyjnie gotowy. Teraz warto zrobić etap 2: spójność zaproszeń, obsługę załączników i refaktor widoków — bez przepisywania całego komunikatora naraz.

## Co jeszcze sprawdzić w obecnych zmianach

1. Czy odbiorca naprawdę istnieje. Nowa walidacja sprawdza aktywację i tożsamość urządzenia. To dobry filtr, ale musimy potwierdzić, że `GetActivationStatus` zwraca brak rekordu dla nieistniejącego użytkownika i że źródło tych danych jest autorytatywne. Sam UUID ani wpis w tabeli aktywacji nie zawsze dowodzą istnienia prawidłowego konta.

2. Czy tożsamość urządzenia jest aktywna. Sprawdzenie `PublicKey` i `GetLatestDeviceIdentityForUser` nie musi oznaczać, że klucz jest aktualny, poprawny kryptograficznie ani przypisany do aktywnego urządzenia. Trzeba sprawdzić istniejący kontrakt i walidację kluczy.

3. Akceptacja zaproszenia. Zmiana statusu zaproszenia i utworzenie relacji symetrycznej powinny być atomowe. W przeciwnym razie błąd w połowie operacji może zostawić niespójny stan.

4. Równoczesne zaproszenia. Dwa żądania wysłane niemal jednocześnie mogą przejść sprawdzenie duplikatu. Potrzebne są odpowiednie ograniczenia w bazie i obsługa konfliktów.

5. Obsługa błędów i testy. Zapis pracy agenta potwierdza testy pakietu `service`, ale pełny pakiet `messaging-service` nadal ma błędy w innych modułach. Nie traktujmy więc całego serwisu jako zweryfikowanego.

## Co z menu „…” i załącznikiem?

- Menu „…” — mały, osobny przycisk przy wiadomości lub w nagłówku rozmowy, zależnie od kontekstu. Powinien otwierać menu kontekstowe, a nie uruchamiać niejawne przesyłanie danych.

- Opcjonalne pakiety diagnostyczne — można dodać osobną funkcję w ustawieniach, domyślnie wyłączoną. Po włączeniu wysyłałaby wyłącznie określone dane diagnostyczne, bez treści wiadomości, kluczy prywatnych, tokenów i sekretów. Użytkownik powinien wiedzieć, co jest wysyłane.

- Załącznik — najpierw trzeba prześledzić istniejącą ikonę od widoku po backend. Jeśli jest tylko wizualna albo kończy się na pustym callbacku, należy podłączyć rzeczywisty przepływ: wybór pliku, walidację typu i rozmiaru, przesłanie, stan postępu, obsługę błędów oraz pobieranie.

- Refaktor widoków — dzielimy duże pliki na mniejsze widżety, komponenty i serwisy. Zmiana stanu ma odświeżać tylko potrzebny fragment drzewa widoków, ale sam podział plików nie gwarantuje mniejszego rebuilda. Trzeba dopasować go do używanego w projekcie zarządzania stanem.

## Drugi prompt dla agenta

Ten prompt kieruje agenta do dalszej pracy na istniejącym kodzie. Ma sprawdzać, naprawiać i implementować, a nie kończyć na audycie ani czekać na ręczne testy.

ETAP 2 — Production hardening komunikatora: kontakty, załączniki i refaktor UI

# ETAP 2 — Production hardening komunikatora: kontakty, załączniki i refaktor UI

Pracujesz w istniejącym repozytorium komunikatora. Etap 1 dodał walidację odbiorcy w `platform/services/messaging-service/internal/service/contacts_service.go`, interfejs `ContactTargetValidator`, integrację przez `internal/di/container.go` i testy walidacji.

**Twoje zadanie: przeanalizować istniejący kod, znaleźć kolejne realne błędy i od razu wdrożyć poprawki. Nie twórz wyłącznie raportu. Nie rozpoczynaj ręcznych testów UI — na tym etapie automatyzujemy testy i naprawiamy implementację.**

## Zasady pracy

1. Najpierw sprawdź aktualny stan repozytorium, diff, testy i implementację po etapie 1. Nie zakładaj, że poprzednia zmiana jest poprawna tylko dlatego, że pojedynczy pakiet przeszedł testy.

2. Zachowaj istniejącą architekturę, konwencje, kontrakty API i sposób zarządzania stanem we Flutterze.

3. Nie twórz fikcyjnych tabel, usług, endpointów ani abstrakcji bez uzasadnienia w kodzie.

4. Pracuj małymi, logicznymi zmianami. Po każdej części uruchom odpowiednie testy, napraw błędy wynikające z Twoich zmian i przejdź dalej.

5. Nie usuwaj działających funkcji i nie zmieniaj niezwiązanych modułów.

6. Jeśli pełny pakiet testów już wcześniej nie przechodził, ustal, które błędy są bazowe, a które wprowadza Twoja zmiana. Nie ukrywaj awarii.

7. Nie wykonuj destrukcyjnych operacji na danych ani środowisku produkcyjnym.

## CZĘŚĆ A — Spójność i bezpieczeństwo zaproszeń

Prześledź pełny przepływ:

Flutter → API → handler → ContactsService → repository → baza danych → Redis → WebSocket.

Sprawdź i napraw następujące przypadki:

- Zaproszenie do nieistniejącego użytkownika nie może utworzyć rekordu kontaktu.

- Sprawdź, czy aktywacja i tożsamość urządzenia są pobierane z wiarygodnego źródła. Nie uznawaj samego UUID, wpisu aktywacji ani niepustego `PublicKey` za wystarczający dowód istnienia i poprawności konta.

- Sprawdź status urządzenia, ważność tożsamości i istniejące zasady weryfikacji kluczy. Nie wymyślaj własnego protokołu kryptograficznego.

- Upewnij się, że użytkownik nie może wysłać zaproszenia samemu sobie.

- Zablokuj duplikaty w obu kierunkach, również przy równoczesnych żądaniach. Jeśli model danych na to pozwala, dodaj właściwe ograniczenia bazodanowe i obsłuż konflikty.

- Zweryfikuj, czy zaakceptować można tylko zaproszenie w prawidłowym stanie i przez uprawnionego odbiorcę.

- Sprawdź atomowość akceptacji: zmiana statusu i utworzenie wymaganej relacji symetrycznej nie mogą pozostawić częściowo zapisanych danych. Zastosuj transakcję odpowiednią dla istniejącego repozytorium.

- Zweryfikuj odrzucenie zaproszenia, ponowne żądania i wszystkie przejścia statusów.

- Upewnij się, że nieudana walidacja nie zapisuje kontaktu ani nie publikuje zdarzenia `contact_updated`.

- Sprawdź, czy awaria Redis po zapisie nie powoduje niejawnej utraty aktualizacji UI. Jeśli istniejący mechanizm na to pozwala, zastosuj odpowiedni wzorzec niezawodnego dostarczania zdarzeń; nie przebudowuj całego systemu zdarzeń bez potrzeby.

Nie ufaj `ownerID` przekazanemu przez klienta. Ustal, czy tożsamość nadawcy pochodzi z uwierzytelnionego kontekstu JWT i poprawnie zweryfikowanej sesji.

### Testy obowiązkowe

Dodaj lub popraw testy dla:

- nieistniejącego i nieaktywnego odbiorcy;

- brakującej lub nieprawidłowej tożsamości urządzenia;

- zaproszenia do samego siebie;

- duplikatów w obu kierunkach;

- dwóch równoczesnych prób zaproszenia;

- akceptacji przez nieuprawnionego użytkownika;

- nieprawidłowego przejścia statusu;

- błędu zapisu podczas akceptacji;

- braku publikacji zdarzenia przy odrzuconym żądaniu;

- zachowania spójności danych przy błędzie części operacji.

## CZĘŚĆ B — Napraw działanie ikony załącznika

Przeszukaj cały moduł komunikatora we Flutterze, szczególnie istniejący obszar:

`lib/features/communication`

Znajdź ikonę załącznika i prześledź ją od widgetu do końcowej operacji. Ustal, czy istnieje już picker, serwis przesyłania, endpoint, obsługa plików i model wiadomości z załącznikiem.

Następnie:

1. Jeśli funkcja już istnieje, ale nie jest podłączona, podłącz ją do istniejącej implementacji.

2. Jeśli przepływ jest częściowy, uzupełnij brakujące elementy w ramach istniejącej architektury.

3. Jeśli backend nie obsługuje danego rodzaju załączników, sprawdź dostępne możliwości przed zmianą kontraktu API. Nie implementuj fikcyjnego uploadu, który tylko wygląda na działający.

4. Obsłuż wybór pliku, anulowanie, niedozwolone typy, limity rozmiaru, błędy sieci, stan wysyłania i sukces.

5. Nie blokuj interfejsu podczas wysyłania. Nie pokazuj wiadomości jako wysłanej, dopóki backend nie potwierdzi odpowiedniego stanu.

6. Sprawdź autoryzację pobierania plików i to, czy nie można pobrać cudzego załącznika przez podmianę identyfikatora.

7. Jeżeli komunikator używa E2EE, nie wysyłaj treści załączników w postaci jawnej do niezaufanego serwera. Sprawdź istniejący model szyfrowania i dopasuj przepływ do niego.

8. Nie loguj treści plików, tokenów ani sekretów.

Dodaj testy dla walidacji pliku, anulowania wyboru, błędu uploadu i poprawnego zakończenia. Jeśli brakuje wymaganej infrastruktury, wdroż bezpieczne części, a dokładny brak opisz jako blokadę zamiast udawać, że funkcja działa.

## CZĘŚĆ C — Menu „…” i diagnostyka

Sprawdź istniejący układ widoku rozmowy oraz dostępne komponenty menu kontekstowego.

Zaprojektuj i wdroż małe, natywne dla obecnego UI menu „…”:

- Umieść je w miejscu wynikającym z istniejącego projektu, bez przypadkowego zaśmiecania interfejsu.

- Podłącz wyłącznie funkcje, które naprawdę istnieją.

- Nie dodawaj martwych przycisków ani pustych callbacków.

- Jeżeli menu dotyczy pojedynczej wiadomości, akcje muszą operować na właściwej wiadomości i respektować uprawnienia.

Rozpoznaj również, czy warto dodać opcjonalną diagnostykę komunikatora. Jeśli jest uzasadniona, przygotuj ją jako oddzielną funkcję w ustawieniach:

- domyślnie wyłączoną;

- z jasnym opisem zakresu przesyłanych danych;

- z możliwością wyłączenia;

- bez treści wiadomości, kluczy prywatnych, tokenów, haseł i sekretów;

- z minimalizacją danych i odpowiednim mechanizmem zgody.

Nie wysyłaj żadnych pakietów w tle tylko dlatego, że użytkownik otworzył menu „…”. Nie dodawaj funkcji „wyślij pakiet” bez określonego celu, formatu, odbiorcy i zabezpieczeń. Jeżeli nie istnieje rzeczywista potrzeba diagnostyczna, nie implementuj wysyłania — opisz proponowany kontrakt i pozostaw funkcję poza zakresem.

## CZĘŚĆ D — Refaktor dużych widoków Fluttera

Przeanalizuj moduł komunikatora i wskaż największe pliki widoków oraz komponenty, w których jedna klasa odpowiada za zbyt wiele rzeczy.

Wybierz pierwszy, bezpieczny fragment i wykonaj refaktor:

- rozdziel duży ekran na mniejsze, odpowiedzialne za pojedyncze zadania widgety;

- oddziel UI od logiki wysyłania wiadomości, obsługi załączników i połączeń sieciowych tam, gdzie obecna architektura tego wymaga;

- współdziel komponenty, jeśli faktycznie występują w kilku miejscach;

- zachowaj dotychczasowe zachowanie, routing, style, obsługę błędów i kontrakty;

- nie przenoś logiki do nowych plików tylko po to, by zmniejszyć liczbę linii;

- nie twórz nadmiernej liczby małych klas bez samodzielnej odpowiedzialności.

Sprawdź używany w projekcie mechanizm stanu i zależności widgetów. Ogranicz niepotrzebne przebudowywanie widoków przez odpowiednie granice stanu, selektory lub lokalizację `setState` — zgodnie z istniejącą technologią. Sam podział plików nie jest dowodem poprawy wydajności.

Nie przepisuj całego modułu. Po pierwszym refaktorze uruchom testy i analizę statyczną. Jeśli zakres jest większy, rozpisz kolejne fragmenty do następnego etapu.

## Kolejność wykonania

1. Sprawdź stan repozytorium i wyniki testów przed zmianami.

2. Dokończ spójność zaproszeń i testy.

3. Napraw rzeczywisty przepływ załącznika.

4. Zintegruj menu „…” tylko z istniejącymi i działającymi akcjami; diagnostykę realizuj wyłącznie, jeśli ma określony cel i bezpieczny kontrakt.

5. Zrób pierwszy niewielki refaktor dużego widoku.

6. Uruchom `gofmt`, testy Go, formatowanie Fluttera (`dart format`) oraz `flutter analyze` i odpowiednie testy Fluttera, zależnie od zmienionych modułów.

7. Nie deklaruj sukcesu dla polecenia, którego wynik nie potwierdza poprawnego zakończenia.

## Raport końcowy

Po wdrożeniu podaj:

- rzeczywiste znalezione problemy i ich przyczyny;

- zmienione pliki i uzasadnienie każdej grupy zmian;

- które funkcje rzeczywiście działają po poprawce;

- uruchomione polecenia i ich wyniki;

- pozostałe błędy bazowe, ryzyka i blokady;

- kolejne konkretne zadania w kolejności priorytetu.

**Kryterium sukcesu:** żadnych pozornie działających przycisków, żadnych fikcyjnych walidacji, żadnego niejawnego przesyłania danych, żadnych częściowo zapisanych relacji po błędzie. Zmiany mają być zgodne z istniejącą architekturą komunikatora, testowalne i gotowe do późniejszych testów manualnych.

Moja rekomendacja: uruchom ten prompt w agencie w katalogu głównym repozytorium, nie w samym katalogu Fluttera — zadania obejmują backend Go i frontend Flutter. Jeśli agent zacznie zmieniać wiele niezależnych obszarów bez testowania pomiędzy nimi, przerwij i każ mu dokończyć najpierw część A.
