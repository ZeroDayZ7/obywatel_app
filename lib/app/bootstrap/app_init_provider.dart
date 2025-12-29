import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/logic/startup_runner.dart';

final appInitProvider = NotifierProvider<AppInitNotifier, AppInitStatus>(
  AppInitNotifier.new,
);

class AppInitNotifier extends Notifier<AppInitStatus> {
  @override
  AppInitStatus build() {
    // Startujemy proces od razu przy budowaniu providera
    _runBootstrap();
    return const AppInitStatus.loading();
  }

  Future<void> _runBootstrap() async {
    // Delegujemy pracę do Runnera
    final runner = StartupRunner(ref);

    // Oczekujemy na wynik (zwraca authorized, blocked lub forceUpdate)
    state = await runner.run();
  }

  /// Metoda do ponowienia próby (np. po błędzie sieci w 'Retry' screen)
  Future<void> recheck() async {
    state = const AppInitStatus.loading();
    await _runBootstrap();
  }
}
