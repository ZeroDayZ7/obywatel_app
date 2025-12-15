import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BootstrapStep {
  String get name;

  /// Czy krok ma się uruchomić (feature flag / env / platform)
  bool shouldRun(Ref ref) => true;

  /// Główna logika kroku
  Future<void> run(Ref ref);
}
