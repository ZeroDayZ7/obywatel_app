import 'package:obywatel_plus/features/evoting/domain/models/voting_models.dart';
import 'package:obywatel_plus/features/evoting/domain/repositories/evoting_repository.dart';

class MockEVotingRepository implements EVotingRepository {
  MockEVotingRepository._();

  static final MockEVotingRepository instance = MockEVotingRepository._();

  final List<CitizenProfile> _citizens = [
    CitizenProfile(
      id: 'me',
      fullName: 'Ty',
      location: 'Warszawa, Śródmieście',
      avatarUrl: '',
      votesCount: 12,
      participationRate: 87,
      delegatingCount: 2,
      votingPower: 3.0,
      interests: ['Transport', 'Cyfryzacja', 'Samorząd', 'Edukacja'],
      votingHistory: [
        CitizenVoteHistory(
          votingId: 'budget-education',
          title: 'Budżet Obywatelski – szkoły i edukacja',
          choice: VoteChoice.yes,
          category: 'Budżet',
          date: DateTime(2026, 2, 11),
        ),
        CitizenVoteHistory(
          votingId: 'urban-green',
          title: 'Park kieszonkowy przy ul. Lipowej',
          choice: VoteChoice.abstain,
          category: 'Lokalne',
          date: DateTime(2026, 2, 1),
        ),
      ],
      isCurrentUser: true,
    ),
    CitizenProfile(
      id: 'jan-kowalski',
      fullName: 'Jan Kowalski',
      location: 'Warszawa, Wola',
      avatarUrl: '',
      votesCount: 48,
      participationRate: 91,
      delegatingCount: 142,
      votingPower: 2.8,
      interests: ['Transport', 'Samorząd', 'Zielona infrastruktura'],
      votingHistory: [
        CitizenVoteHistory(
          votingId: 'mobility-law',
          title: 'Ustawa o elektronicznej rejestracji transportu miejskiego',
          choice: VoteChoice.yes,
          category: 'Ustawa',
          date: DateTime(2026, 1, 28),
        ),
        CitizenVoteHistory(
          votingId: 'digital-admin',
          title: 'Cyfryzacja usług administracji lokalnej',
          choice: VoteChoice.no,
          category: 'Ustawa',
          date: DateTime(2026, 1, 15),
        ),
      ],
      isCurrentUser: false,
    ),
    CitizenProfile(
      id: 'anna-nowak',
      fullName: 'Anna Nowak',
      location: 'Kraków, Dzielnica I',
      avatarUrl: '',
      votesCount: 39,
      participationRate: 88,
      delegatingCount: 54,
      votingPower: 2.3,
      interests: ['Edukacja', 'Cyfryzacja', 'Zdrowie'],
      votingHistory: [
        CitizenVoteHistory(
          votingId: 'digital-admin',
          title: 'Cyfryzacja usług administracji lokalnej',
          choice: VoteChoice.yes,
          category: 'Ustawa',
          date: DateTime(2026, 1, 9),
        ),
      ],
      isCurrentUser: false,
    ),
    CitizenProfile(
      id: 'piotr-wisniewski',
      fullName: 'Piotr Wiśniewski',
      location: 'Gdańsk, Śródmieście',
      avatarUrl: '',
      votesCount: 34,
      participationRate: 86,
      delegatingCount: 41,
      votingPower: 2.1,
      interests: ['Transport', 'Zrównoważony rozwój', 'Budżet'],
      votingHistory: [
        CitizenVoteHistory(
          votingId: 'regional-public-transport',
          title: 'Budżet regionalny na transport publiczny',
          choice: VoteChoice.yes,
          category: 'Budżet',
          date: DateTime(2026, 2, 3),
        ),
      ],
      isCurrentUser: false,
    ),
    CitizenProfile(
      id: 'katarzyna-wojcik',
      fullName: 'Katarzyna Wójcik',
      location: 'Łódź, Bałuty',
      avatarUrl: '',
      votesCount: 31,
      participationRate: 82,
      delegatingCount: 28,
      votingPower: 1.8,
      interests: ['Samorząd', 'Bezpieczeństwo', 'EDU'],
      votingHistory: [
        CitizenVoteHistory(
          votingId: 'neighbourhood-safety',
          title: 'Prywatna infrastruktura bezpieczeństwa sąsiedzkiego',
          choice: VoteChoice.no,
          category: 'Uchwała',
          date: DateTime(2026, 1, 22),
        ),
      ],
      isCurrentUser: false,
    ),
    CitizenProfile(
      id: 'marcin-kaczmarek',
      fullName: 'Marcin Kaczmarek',
      location: 'Poznań, Stare Miasto',
      avatarUrl: '',
      votesCount: 42,
      participationRate: 89,
      delegatingCount: 67,
      votingPower: 2.5,
      interests: ['Cyfryzacja', 'Transport', 'Miejskie usługi'],
      votingHistory: [
        CitizenVoteHistory(
          votingId: 'digital-admin',
          title: 'Cyfryzacja usług administracji lokalnej',
          choice: VoteChoice.abstain,
          category: 'Ustawa',
          date: DateTime(2026, 1, 14),
        ),
      ],
      isCurrentUser: false,
    ),
    CitizenProfile(
      id: 'iza-michalska',
      fullName: 'Iza Michałska',
      location: 'Wrocław, Krzyki',
      avatarUrl: '',
      votesCount: 26,
      participationRate: 80,
      delegatingCount: 13,
      votingPower: 1.6,
      interests: ['Edukacja', 'Zielona infrastruktura', 'Demokracja'],
      votingHistory: [
        CitizenVoteHistory(
          votingId: 'urban-green',
          title: 'Park kieszonkowy przy ul. Lipowej',
          choice: VoteChoice.yes,
          category: 'Lokalne',
          date: DateTime(2026, 2, 2),
        ),
      ],
      isCurrentUser: false,
    ),
    CitizenProfile(
      id: 'lukasz-szulc',
      fullName: 'Łukasz Szulc',
      location: 'Katowice, Centrum',
      avatarUrl: '',
      votesCount: 36,
      participationRate: 84,
      delegatingCount: 58,
      votingPower: 2.0,
      interests: ['Transport', 'Budżety miejskie', 'Małe projekty'],
      votingHistory: [
        CitizenVoteHistory(
          votingId: 'regional-public-transport',
          title: 'Budżet regionalny na transport publiczny',
          choice: VoteChoice.no,
          category: 'Budżet',
          date: DateTime(2026, 1, 27),
        ),
      ],
      isCurrentUser: false,
    ),
  ];

  final List<Delegation> _delegations = [
    Delegation(
      id: 'd1',
      sourceCitizenId: 'me',
      sourceName: 'Ty',
      targetCitizenId: 'jan-kowalski',
      targetName: 'Jan Kowalski',
      scope: DelegationScope.regional,
      category: 'Transport',
      note: 'Głosuję w sprawach transportu i mobilności',
      isActive: true,
    ),
    Delegation(
      id: 'd2',
      sourceCitizenId: 'piotr-wisniewski',
      sourceName: 'Piotr Wiśniewski',
      targetCitizenId: 'me',
      targetName: 'Ty',
      scope: DelegationScope.all,
      category: 'Wszystkie sprawy',
      note: 'Zaufanie do doświadczenia w sprawach samorządowych',
      isActive: true,
    ),
    Delegation(
      id: 'd3',
      sourceCitizenId: 'anna-nowak',
      sourceName: 'Anna Nowak',
      targetCitizenId: 'me',
      targetName: 'Ty',
      scope: DelegationScope.national,
      category: 'Cyfryzacja',
      note: 'Delegacja w sprawach cyfrowych i administracyjnych',
      isActive: true,
    ),
  ];

  final List<Voting> _votings = [
    Voting(
      id: 'urban-green',
      title: 'Budowa ścieżki rowerowej oraz parku kieszonkowego przy ul. Lipowej',
      type: 'Uchwała',
      scope: VotingScope.local,
      category: VotingCategory.resolutions,
      status: 'Rozpoczęto',
      initiator: 'Rada Miasta Warszawa',
      summary:
          'Przebudowa rejonu przy ul. Lipowej w kierunku bezpieczniejszej i bardziej zielonej przestrzeni publicznej. Projekt obejmuje wydzielenie ścieżki rowerowej, zieleń, ławki i oświetlenie.',
      justification:
          'Prowadzone konsultacje społeczne wykazały wysoki poziom poparcia dla bezpieczniejszej infrastruktury rowerowej oraz zwiększenia terenów zielonych w dzielnicy.',
      keyChanges: [
        'Dodanie 1,8 km ścieżki rowerowej',
        'Przebudowa skrzyżowania przy ul. Lipowej',
        'Zwiększenie powierzchni zieleni o 28%',
      ],
      impact: [
        'Zwiększenie bezpieczeństwa pieszych i rowerzystów',
        'Poprawa jakości przestrzeni publicznej',
        'Lepsza dostępność dla rodzin i seniorów',
      ],
      costs: [
        'Koszt inwestycji: 12,8 mln zł',
        'Wydatki utrzymaniowe: 0,9 mln zł / rok',
      ],
      sourceDocument: 'https://example.gov/pl/dokumenty/uchwala-lipowa-2026',
      history: [
        'Konsultacje obywatelskie rozpoczęte 04.02.2026',
        'Zgłoszono 14 poprawek do projektu',
        'Rada ds. Transportu rekomenduje przyjęcie',
      ],
      participantCount: 1420,
      turnout: 0.46,
      endsAt: DateTime(2026, 9, 20, 18, 0),
      userHasVoted: false,
      userChoice: null,
      userDelegated: false,
      delegatedTo: null,
      argumentsFor: const [
        VotingArgument(
          author: 'Marta K.',
          text: 'Rozwój infrastruktury rowerowej zmniejsza liczbę wypadków i poprawia jakość życia mieszkańców.',
          supporters: 181,
          isKey: true,
        ),
        VotingArgument(
          author: 'Tomasz S.',
          text: 'Dodatkowa zieleń znacząco podnosi komfort spędzania czasu na ulicy.',
          supporters: 116,
          isKey: false,
        ),
      ],
      argumentsAgainst: const [
        VotingArgument(
          author: 'Robert G.',
          text: 'Koszt inwestycji może być zbyt wysoki w porównaniu do potrzeb innych obszarów.',
          supporters: 92,
          isKey: true,
        ),
      ],
      comments: const [
        CommentItem(
          id: 'c1',
          authorId: 'jan-kowalski',
          authorName: 'Jan Kowalski',
          text: 'Warto połączyć ten projekt z planem rozwoju dojazdu do szkoły i przystanków.',
          likes: 14,
          replies: 3,
          createdAt: null,
          category: 'Transport',
        ),
      ],
      tags: const ['Lokalne', 'Transport', 'Zielona infrastruktura'],
    ),
    Voting(
      id: 'digital-admin',
      title: 'Projekt ustawy o cyfryzacji lokalnych procedur administracyjnych',
      type: 'Ustawa',
      scope: VotingScope.national,
      category: VotingCategory.laws,
      status: 'W toku',
      initiator: 'Ministerstwo Cyfryzacji',
      summary:
          'Ustawa ma uprościć procedury dla obywateli i samorządów, wprowadzając cyfrowe formularze, automatyzację i lepszy dostęp do usług administracyjnych.',
      justification:
          'Prawo w wielu procedurach pozostaje rozproszone, a cyfryzacja pozwala skrócić czas obsługi wniosków i zredukować błędy administracyjne.',
      keyChanges: [
        'Wprowadzenie wspólnego cyfrowego identyfikatora wnioskowania',
        'Ujednolicenie formularzy i elektronicznych podpisów',
        'Automatyczna weryfikacja danych w systemach lokalnych',
      ],
      impact: [
        'Skrócenie czasu obsługi do 40%',
        'Mniejsze koszty obsługi administracyjnej',
        'Większa przejrzystość dla obywateli',
      ],
      costs: [
        'Koszt implementacji: 84 mln zł',
        'Koszt roczny utrzymania: 16 mln zł',
      ],
      sourceDocument: 'https://example.gov/pl/ustawa/cyfryzacja-procedur',
      history: [
        'Projekt złożony 12.01.2026',
        'Komisja ds. Administracji przyjęła zmiany 24.01.2026',
        'Wystąpienia publiczne zakończone 04.02.2026',
      ],
      participantCount: 48190,
      turnout: 0.69,
      endsAt: DateTime(2026, 9, 25, 20, 0),
      userHasVoted: true,
      userChoice: VoteChoice.no,
      userDelegated: false,
      delegatedTo: null,
      argumentsFor: const [
        VotingArgument(
          author: 'Anna N.',
          text: 'Cyfryzacja zmniejsza liczbę formalnych błędów i skraca czas realizacji spraw administracyjnych.',
          supporters: 320,
          isKey: true,
        ),
        VotingArgument(
          author: 'Michał F.',
          text: 'Dzięki temu urzędy będą mogły lepiej reagować na potrzeby obywateli.',
          supporters: 241,
          isKey: false,
        ),
      ],
      argumentsAgainst: const [
        VotingArgument(
          author: 'Katarzyna W.',
          text: 'Zagrożenie dla prywatności i ryzyko nadmiernej centralizacji danych obywateli.',
          supporters: 178,
          isKey: true,
        ),
      ],
      comments: const [
        CommentItem(
          id: 'c2',
          authorId: 'anna-nowak',
          authorName: 'Anna Nowak',
          text: 'Warto zadbać o przejrzyste mechanizmy dostępu do danych i możliwości odwołania się.',
          likes: 22,
          replies: 5,
          createdAt: null,
          category: 'Cyfryzacja',
        ),
      ],
      tags: const ['Krajowe', 'Ustawa', 'Cyfryzacja'],
    ),
    Voting(
      id: 'regional-public-transport',
      title: 'Alokacja środków z Budżetu Obywatelskiego na rozwój transportu publicznego',
      type: 'Budżet',
      scope: VotingScope.regional,
      category: VotingCategory.budgets,
      status: 'Kończy się za 2 dni',
      initiator: 'Sejmik Województwa Śląskiego',
      summary:
          'Plan inwestycji obejmuje nowe linie komunikacji miejskiej, modernizację przystanków oraz zwiększenie frekwencji linii nocnych.',
      justification:
          'Zmniejszenie czasu dojazdu i poprawa dostępności transportu zwiększa mobilność mieszkańców, zwłaszcza w obszarach wymagających integracji lokalnej.',
      keyChanges: [
        'Modernizacja 18 przystanków',
        'Dodatkowe autobusy nocne na odcinku północ-południe',
        'Zwiększenie dostępności dla seniorów i osób z niepełnosprawnościami',
      ],
      impact: [
        'Lepsze połączenia między dzielnicami',
        'Mniejsze korki miejskie',
        'Większa dostępność dla osób starszych',
      ],
      costs: [
        'Całkowity koszt: 34,7 mln zł',
        'Środki z budżetu regionalnego: 18,2 mln zł',
      ],
      sourceDocument: 'https://example.gov/pl/budzet/transport-regionalny',
      history: [
        'Wstępna weryfikacja 11.02.2026',
        'Cykl konsultacji zakończony 15.02.2026',
        'Doprecyzowanie budżetu po rekomendacji komisji',
      ],
      participantCount: 8930,
      turnout: 0.57,
      endsAt: DateTime(2026, 9, 18, 18, 0),
      userHasVoted: false,
      userChoice: null,
      userDelegated: true,
      delegatedTo: 'jan-kowalski',
      argumentsFor: const [
        VotingArgument(
          author: 'Piotr W.',
          text: 'Dobrze zorganizowany transport publiczny poprawia dostępność pracy i usług.',
          supporters: 144,
          isKey: true,
        ),
      ],
      argumentsAgainst: const [
        VotingArgument(
          author: 'Katarzyna W.',
          text: 'Inwestycje powinny być bardziej rozproszone i obejmować lokalne, krótkie trasy.',
          supporters: 88,
          isKey: false,
        ),
      ],
      comments: const [
        CommentItem(
          id: 'c3',
          authorId: 'piotr-wisniewski',
          authorName: 'Piotr Wiśniewski',
          text: 'Największą wartością jest poprawa połączenia pomiędzy dzielnicami i strefą przemysłową.',
          likes: 18,
          replies: 2,
          createdAt: null,
          category: 'Transport',
        ),
      ],
      tags: const ['Regionalne', 'Transport', 'Budżet'],
    ),
    Voting(
      id: 'school-bus',
      title: 'Rozszerzenie kursów szkolnych w rejonie północnym',
      type: 'Uchwała',
      scope: VotingScope.local,
      category: VotingCategory.resolutions,
      status: 'W toku',
      initiator: 'Dzielnica Północ',
      summary:
          'Dodanie dodatkowych kursów szkolnych do połączeń z przedszkolami i szkołami podstawowymi w okolicy rejonu.',
      justification:
          'Wiele rodzin zgłasza trudności z niepełną dostępnością transportu do szkół, co utrudnia regularną obecność dzieci.',
      keyChanges: [
        'Dodanie 4 nowych kursów szkolnych',
        'Ułatwienie dostępu dla rodzin z dziećmi',
        'Wzrost bezpieczeństwa podróży',
      ],
      impact: [
        'Skrócenie czasu dojazdu do szkoły',
        'Lepsza dostępność dla rodzin',
        'Zwiększenie bezpieczeństwa dzieci',
      ],
      costs: [
        'Koszt dodatkowych kursów: 3,1 mln zł',
        'Koszty operacyjne: 440 tys. zł / rok',
      ],
      sourceDocument: 'https://example.gov/pl/uchwala/szkolne-kursy',
      history: [
        'Konsultacje z rodzicami 10.02.2026',
        'Zgłoszono poprawki do trasy kursów',
        'Kolejny etap opiniowania',
      ],
      participantCount: 1120,
      turnout: 0.39,
      endsAt: DateTime(2026, 9, 22, 12, 0),
      userHasVoted: false,
      userChoice: null,
      userDelegated: false,
      delegatedTo: null,
      argumentsFor: const [
        VotingArgument(
          author: 'Ewa B.',
          text: 'Dla wielu rodzin to najważniejsze usprawnienie infrastruktury miejskiej.',
          supporters: 98,
          isKey: true,
        ),
      ],
      argumentsAgainst: const [
        VotingArgument(
          author: 'Grzegorz A.',
          text: 'W niektórych odcinkach bezpieczniej byłoby zainwestować w piesze przejścia.',
          supporters: 54,
          isKey: false,
        ),
      ],
      comments: const [
        CommentItem(
          id: 'c4',
          authorId: 'katarzyna-wojcik',
          authorName: 'Katarzyna Wójcik',
          text: 'Warto też uwzględnić dostęp dla rodzin z dziećmi z niepełnosprawnością.',
          likes: 11,
          replies: 1,
          createdAt: null,
          category: 'Samorząd',
        ),
      ],
      tags: const ['Lokalne', 'Szkoły', 'Transport'],
    ),
    Voting(
      id: 'city-open-data',
      title: 'Otwarcie miejskich danych i API dla lokalnych projektów społecznych',
      type: 'Ustawa',
      scope: VotingScope.local,
      category: VotingCategory.laws,
      status: 'Rozpoczęto',
      initiator: 'Urząd Miasta',
      summary:
          'Umożliwienie dostępu do danych miejskich w formacie otwartym dla organizacji pozarządowych i startupów.',
      justification:
          'Dostęp do lokalnych danych zwiększa innowacyjność i umożliwia lepsze planowanie usług publicznych.',
      keyChanges: [
        'Otwarcie danych o transportcie i infrastrukturze',
        'Uproszczenie dostępu do zbiorów danych publicznych',
        'Wprowadzenie standardów API dla partnerów',
      ],
      impact: [
        'Rozwój lokalnych usług cyfrowych',
        'Wzrost przejrzystości',
        'Lepsza współpraca między sektorem publicznym i społecznym',
      ],
      costs: [
        'Koszt wdrożenia: 6,4 mln zł',
        'Koszt utrzymania: 1,1 mln zł / rok',
      ],
      sourceDocument: 'https://example.gov/pl/otwarte-dane-miasto',
      history: [
        'Spotkanie z NGO 09.02.2026',
        'Wzrost zainteresowania wśród startupów',
        'Powierzenie wdrożenia pionowi cyfryzacji',
      ],
      participantCount: 2430,
      turnout: 0.42,
      endsAt: DateTime(2026, 9, 24, 12, 0),
      userHasVoted: false,
      userChoice: null,
      userDelegated: false,
      delegatedTo: null,
      argumentsFor: const [
        VotingArgument(
          author: 'Michał K.',
          text: 'Dane publiczne pozwalają sektorowi obywatelskiemu tworzyć przydatne usługi i narzędzia.',
          supporters: 143,
          isKey: true,
        ),
      ],
      argumentsAgainst: const [
        VotingArgument(
          author: 'Joanna P.',
          text: 'Należy zapewnić ochronę prywatności i nie wprowadzać ryzykownych standardów dostępu.',
          supporters: 71,
          isKey: false,
        ),
      ],
      comments: const [
        CommentItem(
          id: 'c5',
          authorId: 'marcin-kaczmarek',
          authorName: 'Marcin Kaczmarek',
          text: 'Najważniejsze, aby dane były publiczne, ale z zachowaniem zasad ochrony prywatności.',
          likes: 20,
          replies: 3,
          createdAt: null,
          category: 'Cyfryzacja',
        ),
      ],
      tags: const ['Lokalne', 'Cyfryzacja', 'Otwarte dane'],
    ),
    Voting(
      id: 'mobility-law',
      title: 'Ustawa o elektronicznej rejestracji transportu miejskiego',
      type: 'Ustawa',
      scope: VotingScope.national,
      category: VotingCategory.laws,
      status: 'Rozpoczęto',
      initiator: 'Sejm RP',
      summary:
          'Zmiana przepisów dotyczących monitoringów ruchu, systemów biletowych i interoperacyjności danych transportu miejskiego.',
      justification:
          'Połączenie danych transportowych i ich dostępność w czasie rzeczywistym poprawia mobilność i organizację ruchu w miastach.',
      keyChanges: [
        'Wprowadzenie standardów danych dla transportu miejskiego',
        'Zwiększenie elektronicznej rejestracji stanu infrastruktury',
        'Wspólna infrastruktura dla operatorów i samorządów',
      ],
      impact: [
        'Lepsze zarządzanie ruchem miejskim',
        'Większa przejrzystość i bezpieczeństwo',
        'Lepsze planowanie inwestycji',
      ],
      costs: [
        'Koszt wdrożenia: 42 mln zł',
        'Operacja: 9 mln zł / rok',
      ],
      sourceDocument: 'https://example.gov/pl/ustawa/transport-miejski',
      history: [
        'Projekt zgłoszony 03.2026',
        'Komisja przyjęła rekomendacje 05.2026',
      ],
      participantCount: 124320,
      turnout: 0.58,
      endsAt: DateTime(2026, 10, 2, 18, 0),
      userHasVoted: false,
      userChoice: null,
      userDelegated: false,
      delegatedTo: null,
      argumentsFor: const [
        VotingArgument(
          author: 'Jan K.',
          text: 'Dane w czasie rzeczywistym pozwolą lepiej zarządzać ruchem i skrócić czas dojazdów.',
          supporters: 410,
          isKey: true,
        ),
      ],
      argumentsAgainst: const [
        VotingArgument(
          author: 'Iza M.',
          text: 'Wymaga to dużych nakładów infrastrukturalnych i nie powinno być narzucone na wszystkie miasta naraz.',
          supporters: 129,
          isKey: false,
        ),
      ],
      comments: const [
        CommentItem(
          id: 'c6',
          authorId: 'jan-kowalski',
          authorName: 'Jan Kowalski',
          text: 'To jest ważny krok, ale trzeba zadbać o cyfrową dostępność dla małych samorządów.',
          likes: 23,
          replies: 4,
          createdAt: null,
          category: 'Transport',
        ),
      ],
      tags: const ['Krajowe', 'Ustawa', 'Transport'],
    ),
    Voting(
      id: 'budget-education',
      title: 'Budżet Obywatelski – środki na szkoły i edukację',
      type: 'Budżet',
      scope: VotingScope.local,
      category: VotingCategory.budgets,
      status: 'Zakończone',
      initiator: 'Urząd Miasta',
      summary:
          'Poprawa infrastruktury szkół, dostępności edukacji cyfrowej i nowoczesnych pomieszczeń do nauki poza standardowymi klasami.',
      justification:
          'Wielu mieszkańców wskazuje na potrzebę inwestycji w edukację i wyposażenie szkół jako najważniejszej lokalnej infrastruktury.',
      keyChanges: [
        'Modernizacja 7 szkół',
        'Dodanie 3 laboratoriów STEM',
        'Inwestycja w dostęp do cyfrowego sprzętu',
      ],
      impact: [
        'Poprawa jakości nauczania',
        'Większa dostępność edukacji',
        'Lepsze warunki pracy nauczycieli',
      ],
      costs: [
        'Koszt całkowity: 21,8 mln zł',
        'Pozostałe środki na utrzymanie: 1,2 mln zł',
      ],
      sourceDocument: 'https://example.gov/pl/budzet/edukacja',
      history: [
        'Konsultacje zakończone 01.2026',
        'Głosowanie odbyło się 08.02.2026',
        'Wynik: 68% za',
      ],
      participantCount: 7600,
      turnout: 0.64,
      endsAt: DateTime(2026, 2, 8, 20, 0),
      userHasVoted: true,
      userChoice: VoteChoice.yes,
      userDelegated: false,
      delegatedTo: null,
      argumentsFor: const [
        VotingArgument(
          author: 'Iza M.',
          text: 'Dobra inwestycja w edukację przekłada się na lepsze warunki i jakść życia przyszłych pokoleń.',
          supporters: 218,
          isKey: true,
        ),
      ],
      argumentsAgainst: const [
        VotingArgument(
          author: 'Łukasz S.',
          text: 'Niektórzy preferowali inwestycje w infrastrukturę transportową zamiast szkolną.',
          supporters: 84,
          isKey: false,
        ),
      ],
      comments: const [
        CommentItem(
          id: 'c7',
          authorId: 'iza-michalska',
          authorName: 'Iza Michałska',
          text: 'Najbardziej potrzebne są pomieszczenia i laptop dla szkół podstawowych na obrzeżach miasta.',
          likes: 17,
          replies: 2,
          createdAt: null,
          category: 'Edukacja',
        ),
      ],
      tags: const ['Lokalne', 'Budżet', 'Edukacja'],
    ),
    Voting(
      id: 'neighbourhood-safety',
      title: 'Prywatna infrastruktura bezpieczeństwa sąsiedzkiego',
      type: 'Uchwała',
      scope: VotingScope.local,
      category: VotingCategory.resolutions,
      status: 'Rozpoczęto',
      initiator: 'Stowarzyszenie Sąsiedzi',
      summary:
          'Inwestycja w system monitoringu, oświetlenia i punktów alarmowych wzdłuż ulic osiedlowych.',
      justification:
          'Obywatele zgłaszają potrzebę zwiększenia bezpieczeństwa po zmroku i w strefach o ograniczonej widoczności.',
      keyChanges: [
        'Dodanie 18 punktów oświetlenia',
        'Monitoring w strefie osiedla',
        'Modernizacja wejść i przejść',
      ],
      impact: [
        'Zwiększenie bezpieczeństwa',
        'Wyższy komfort poruszania się po zmroku',
        'Mniejsze zagrożenie dla mieszkańców',
      ],
      costs: [
        'Koszt całkowity: 8,6 mln zł',
        'Koszt utrzymania: 0,7 mln zł / rok',
      ],
      sourceDocument: 'https://example.gov/pl/uchwala/osiedle-bezpieczenstwo',
      history: [
        'Otwarcie projektu 04.02.2026',
        'Wystąpienia od mieszkańców w ramach konsultacji',
      ],
      participantCount: 1845,
      turnout: 0.52,
      endsAt: DateTime(2026, 9, 29, 18, 0),
      userHasVoted: false,
      userChoice: null,
      userDelegated: false,
      delegatedTo: null,
      argumentsFor: const [
        VotingArgument(
          author: 'Marta K.',
          text: 'Bezpieczeństwo mieszkańców powinno być priorytetem przy planowaniu nowych inwestycji miejskich.',
          supporters: 102,
          isKey: true,
        ),
      ],
      argumentsAgainst: const [
        VotingArgument(
          author: 'Grzegorz A.',
          text: 'Monitorowanie może być zbyt inwazyjne i nie wszyscy mieszkańcy popierają ten model.',
          supporters: 64,
          isKey: false,
        ),
      ],
      comments: const [
        CommentItem(
          id: 'c8',
          authorId: 'katarzyna-wojcik',
          authorName: 'Katarzyna Wójcik',
          text: 'Warto połączyć inwestycję z lokalną pikietą bezpieczeństwa i poprawą oświetlenia.',
          likes: 13,
          replies: 2,
          createdAt: null,
          category: 'Bezpieczeństwo',
        ),
      ],
      tags: const ['Lokalne', 'Bezpieczeństwo', 'Uchwała'],
    ),
  ];

  @override
  Future<List<Voting>> getVotings({
    VotingCategory category = VotingCategory.all,
    VotingSort sort = VotingSort.endingSoonest,
  }) async {
    List<Voting> filtered = List<Voting>.from(_votings);

    switch (category) {
      case VotingCategory.all:
        filtered = List<Voting>.from(_votings);
        break;
      case VotingCategory.forYou:
        filtered = _votings
            .where(
              (v) =>
                  v.tags.any(
                    (tag) =>
                        const ['Transport', 'Cyfryzacja', 'Samorząd', 'Edukacja']
                            .contains(tag),
                  ) ||
                  v.scope == VotingScope.local,
            )
            .toList();
        break;
      case VotingCategory.local:
        filtered = _votings.where((v) => v.scope == VotingScope.local).toList();
        break;
      case VotingCategory.regional:
        filtered = _votings.where((v) => v.scope == VotingScope.regional).toList();
        break;
      case VotingCategory.national:
        filtered = _votings.where((v) => v.scope == VotingScope.national).toList();
        break;
      case VotingCategory.laws:
        filtered = _votings.where((v) => v.category == VotingCategory.laws).toList();
        break;
      case VotingCategory.resolutions:
        filtered = _votings.where((v) => v.category == VotingCategory.resolutions).toList();
        break;
      case VotingCategory.budgets:
        filtered = _votings.where((v) => v.category == VotingCategory.budgets).toList();
        break;
      case VotingCategory.myVotes:
        filtered = _votings.where((v) => v.userHasVoted).toList();
        break;
      case VotingCategory.myDelegations:
        filtered = _votings.where((v) => v.userDelegated).toList();
        break;
      case VotingCategory.closed:
        filtered = _votings.where((v) => v.status == 'Zakończone').toList();
        break;
    }

    switch (sort) {
      case VotingSort.endingSoonest:
        filtered.sort((a, b) => a.endsAt.compareTo(b.endsAt));
        break;
      case VotingSort.mostPopular:
        filtered.sort((a, b) => b.participantCount.compareTo(a.participantCount));
        break;
      case VotingSort.newest:
        filtered.sort((a, b) => b.endsAt.compareTo(a.endsAt));
        break;
      case VotingSort.requiresMyVote:
        filtered = filtered.where((v) => !v.userHasVoted && v.status != 'Zakończone').toList();
        break;
    }

    return filtered;
  }

  @override
  Future<Voting?> getVotingById(String id) async {
    return _votings.firstWhere((v) => v.id == id, orElse: () => _votings.first);
  }

  @override
  Future<CitizenProfile?> getCitizenById(String citizenId) async {
    for (final citizen in _citizens) {
      if (citizen.id == citizenId) {
        return citizen;
      }
    }
    return null;
  }

  @override
  Future<List<CitizenProfile>> getCitizenProfiles() async {
    return [..._citizens];
  }

  @override
  Future<List<Delegation>> getDelegations() async {
    return [..._delegations];
  }

  @override
  Future<List<CommentItem>> getComments(String votingId) async {
    final voting = _votings.firstWhere(
      (element) => element.id == votingId,
      orElse: () => _votings.first,
    );
    return [...voting.comments];
  }

  @override
  Future<void> castVote(String votingId, VoteChoice choice, {bool delegated = false}) async {
    for (var i = 0; i < _votings.length; i++) {
      if (_votings[i].id == votingId) {
        _votings[i] = Voting(
          id: _votings[i].id,
          title: _votings[i].title,
          type: _votings[i].type,
          scope: _votings[i].scope,
          category: _votings[i].category,
          status: 'Oddano głos',
          initiator: _votings[i].initiator,
          summary: _votings[i].summary,
          justification: _votings[i].justification,
          keyChanges: _votings[i].keyChanges,
          impact: _votings[i].impact,
          costs: _votings[i].costs,
          sourceDocument: _votings[i].sourceDocument,
          history: _votings[i].history,
          participantCount: _votings[i].participantCount + 1,
          turnout: _votings[i].turnout + 0.02,
          endsAt: _votings[i].endsAt,
          userHasVoted: true,
          userChoice: choice,
          userDelegated: delegated,
          delegatedTo: delegated ? 'jan-kowalski' : null,
          argumentsFor: _votings[i].argumentsFor,
          argumentsAgainst: _votings[i].argumentsAgainst,
          comments: _votings[i].comments,
          tags: _votings[i].tags,
        );
      }
    }
  }

  @override
  Future<void> delegateVote({
    required String sourceCitizenId,
    required String targetCitizenId,
    required DelegationScope scope,
    required String category,
    required String note,
    bool isActive = true,
  }) async {
    final source = await getCitizenById(sourceCitizenId);
    final target = await getCitizenById(targetCitizenId);

    if (source == null || target == null) return;

    final newDelegation = Delegation(
      id: 'd${DateTime.now().millisecondsSinceEpoch}',
      sourceCitizenId: sourceCitizenId,
      sourceName: source.fullName,
      targetCitizenId: targetCitizenId,
      targetName: target.fullName,
      scope: scope,
      category: category,
      note: note,
      isActive: isActive,
    );

    _delegations.add(newDelegation);
  }

  @override
  Future<void> removeDelegation(String sourceCitizenId, String targetCitizenId) async {
    final index = _delegations.indexWhere(
      (d) =>
          d.sourceCitizenId == sourceCitizenId && d.targetCitizenId == targetCitizenId,
    );

    if (index >= 0) {
      _delegations.removeAt(index);
    }
  }

  @override
  Future<List<Voting>> getMyVotes() async {
    return _votings.where((v) => v.userHasVoted).toList();
  }

  @override
  Future<DashboardStats> getDashboardStats() async {
    final activeVotingCount = _votings.where((v) => v.status != 'Zakończone').length;
    final votedCount = _votings.where((v) => v.userHasVoted).length;
    final delegationsCount = _delegations.where((d) => d.isActive).length;

    return DashboardStats(
      activeVotingCount: activeVotingCount,
      votedCount: votedCount,
      delegationsCount: delegationsCount,
      currentVotingPower: 3.0,
    );
  }
}
