import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';

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
    @Default(LocalSecurityMethod.none)
    LocalSecurityMethod localSecurityMethod,
  }) = _SecurityState;

  /// Stan początkowy - SAFE DEFAULT
  factory SecurityState.initial() => const SecurityState(
    hasLocalLock: false,
    isPinConfigured: false,
    isBiometricEnabled: false,
    canUseBiometrics: false,
    isSetupCompleted: false,
    initialized: false,
    localSecurityMethod: LocalSecurityMethod.none,
  );

  /// Getter pomocniczy dla Routera
  /// Pokazujemy blokadę tylko gdy:
  /// 1. Serwis jest gotowy (initialized)
  /// 2. Setup jest zrobiony
  /// 3. Została wybrana poprawna metoda lokalna
  /// 4. Flaga blokady jest aktywna
  bool get shouldShowLock =>
      initialized &&
      isSetupCompleted &&
      localSecurityMethod != LocalSecurityMethod.none &&
      hasLocalLock;

  bool get hasConfiguredLocalMethod =>
      localSecurityMethod != LocalSecurityMethod.none;
}
