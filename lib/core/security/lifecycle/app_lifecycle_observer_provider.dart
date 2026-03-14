import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_lifecycle_observer.dart';

final appLifecycleObserverProvider = Provider<AppLifecycleObserver>((ref) {
  final observer = AppLifecycleObserver(ref);

  WidgetsBinding.instance.addObserver(observer);

  ref.onDispose(() {
    WidgetsBinding.instance.removeObserver(observer);
  });

  return observer;
});
