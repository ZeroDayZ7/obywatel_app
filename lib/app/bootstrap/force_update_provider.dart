// lib/app/bootstrap/force_update_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForceUpdateNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void requireUpdate() => state = true;
  void clear() => state = false;
}

final forceUpdateProvider = NotifierProvider<ForceUpdateNotifier, bool>(
  ForceUpdateNotifier.new,
);
