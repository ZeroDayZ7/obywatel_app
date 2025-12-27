import 'package:freezed_annotation/freezed_annotation.dart';

// Wymagane do generowania kodu:
part 'security_state.freezed.dart';

// ================================================================
// 1. STAN (SecurityState) z Freezed
// ================================================================

@freezed
sealed class SecurityState with _$SecurityState {
  // Prywatny konstruktor jest potrzebny, abyśmy mogli dodać gettery (np. shouldShowLock)
  const SecurityState._();

  const factory SecurityState({
    required bool hasLocalLock, // Czy ekran blokady jest aktywny?
    required bool isPinConfigured, // Czy user ustawił PIN?
    required bool isBiometricEnabled, // Czy włączył biometrię w ustawieniach?
    required bool canUseBiometrics, // Czy urządzenie obsługuje biometrię?
    required bool isSetupCompleted, // Czy zakończył wizard powitalny?
    required bool initialized, // Czy serwis skończył się ładować?
  }) = _SecurityState;

  /// Stan początkowy - SAFE DEFAULT
  /// Ustawiamy hasLocalLock na TRUE, aby aplikacja domyślnie była "bezpieczna"
  /// zanim zdążymy odczytać dysk. To zapobiega mignięciu Home.
  factory SecurityState.initial() => const SecurityState(
    hasLocalLock: true,
    isPinConfigured: false,
    isBiometricEnabled: false,
    canUseBiometrics: false,
    isSetupCompleted: false,
    initialized: false,
  );

  /// Getter pomocniczy dla Routera
  /// Pokazujemy blokadę tylko gdy:
  /// 1. Serwis jest gotowy (initialized)
  /// 2. Setup jest zrobiony
  /// 3. PIN jest ustawiony
  /// 4. Flaga blokady jest aktywna
  bool get shouldShowLock =>
      initialized && isSetupCompleted && isPinConfigured && hasLocalLock;
}
