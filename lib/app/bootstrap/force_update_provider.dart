// force_update_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForceUpdateData {
  final bool required;
  final String windowsUrl;

  ForceUpdateData({required this.required, this.windowsUrl = ''});
}

class ForceUpdateNotifier extends Notifier<ForceUpdateData> {
  @override
  ForceUpdateData build() => ForceUpdateData(required: false);

  void requireUpdate({String windowsUrl = ''}) {
    state = ForceUpdateData(required: true, windowsUrl: windowsUrl);
  }

  void clear() => state = ForceUpdateData(required: false);
}

final forceUpdateProvider =
    NotifierProvider<ForceUpdateNotifier, ForceUpdateData>(
      ForceUpdateNotifier.new,
    );
