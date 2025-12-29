import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';

/// Interfejs pojedynczego zadania startowego.
abstract interface class StartupTask {
  /// Nazwa zadania do logowania (np. 'Storage Init')
  String get name;

  /// Wykonuje logikę inicjalizacji.
  ///
  /// Zwraca:
  /// * `null` -> Zadanie wykonane pomyślnie, przejdź do następnego.
  /// * `AppInitStatus` -> Błąd lub wymuszone przerwanie (np. Force Update), zatrzymaj runnera.
  Future<AppInitStatus?> initialize(Ref ref);
}
