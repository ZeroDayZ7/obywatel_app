import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';
import 'package:obywatel_plus/core/notifications/notification_settings.dart';
import 'package:vibration/vibration.dart';

abstract interface class FeedbackPlatform {
  Future<bool> hasVibrator();

  Future<void> vibrate({
    List<int>? pattern,
    int? duration,
    List<int>? intensities,
  });

  Future<void> playSound(SystemSoundType sound);
}

class FlutterFeedbackPlatform implements FeedbackPlatform {
  const FlutterFeedbackPlatform();

  @override
  Future<bool> hasVibrator() => Vibration.hasVibrator();

  @override
  Future<void> vibrate({
    List<int>? pattern,
    int? duration,
    List<int>? intensities,
  }) async {
    if (pattern != null || intensities != null) {
      await Vibration.vibrate(
        pattern: pattern ?? const [0, 200],
        intensities: intensities ?? const [0, 255],
      );
      return;
    }
    await Vibration.vibrate(duration: duration ?? 200);
  }

  @override
  Future<void> playSound(SystemSoundType sound) => SystemSound.play(sound);
}

class FeedbackService {
  final Ref? _ref;
  final ProviderContainer? _container;
  final FeedbackPlatform _platform;

  FeedbackService(Object source, {FeedbackPlatform? platform})
      : _ref = source is Ref ? source : null,
        _container = source is ProviderContainer ? source : null,
        _platform = platform ?? const FlutterFeedbackPlatform() {
    if (_ref == null && _container == null) {
      throw ArgumentError.value(
        source,
        'source',
        'FeedbackService requires a Riverpod Ref or ProviderContainer.',
      );
    }
  }

  Future<void> trigger(FeedbackType type) async {
    final settings = _container != null
        ? _container.read(appNotificationSettingsProvider)
        : _ref!.read(appNotificationSettingsProvider);

    if (!settings.appNotifications) {
      return;
    }

    final tasks = <Future<void>>[];
    if (settings.sound) {
      tasks.add(_playSound(type));
    }
    if (settings.vibration) {
      tasks.add(_vibrate(type));
    }

    if (tasks.isNotEmpty) {
      await Future.wait(tasks);
    }
  }

  Future<void> _vibrate(FeedbackType type) async {
    try {
      final hasVibrator = await _platform.hasVibrator();
      if (!hasVibrator) {
        return;
      }

      switch (type) {
        case FeedbackType.securityAlert:
          try {
            await HapticFeedback.heavyImpact();
          } catch (_) {}
          try {
            await _platform.vibrate(
              pattern: [0, 200, 100, 200, 100, 500],
              intensities: [0, 255, 0, 255, 0, 255],
            );
          } catch (_) {}
          break;

        case FeedbackType.error:
          try {
            await HapticFeedback.heavyImpact();
          } catch (_) {}
          try {
            await _platform.vibrate(duration: 400);
          } catch (_) {}
          break;

        case FeedbackType.success:
          try {
            await HapticFeedback.mediumImpact();
          } catch (_) {}
          break;

        case FeedbackType.warning:
          try {
            await HapticFeedback.lightImpact();
          } catch (_) {}
          try {
            await Future.delayed(const Duration(milliseconds: 50));
            await HapticFeedback.lightImpact();
          } catch (_) {}
          break;

        case FeedbackType.info:
          try {
            await HapticFeedback.selectionClick();
          } catch (_) {}
          break;

        case FeedbackType.light:
          try {
            await HapticFeedback.lightImpact();
          } catch (_) {}
          break;

        case FeedbackType.medium:
          try {
            await HapticFeedback.mediumImpact();
          } catch (_) {}
          break;

        case FeedbackType.heavy:
          try {
            await HapticFeedback.heavyImpact();
          } catch (_) {}
          break;

        case FeedbackType.selection:
          try {
            await HapticFeedback.selectionClick();
          } catch (_) {}
          break;
      }
    } catch (_) {
      // Nie przerywamy UI, gdy urządzenie nie obsługuje efektu.
    }
  }

  Future<void> _playSound(FeedbackType type) async {
    try {
      final sound = switch (type) {
        FeedbackType.error || FeedbackType.securityAlert => SystemSoundType.alert,
        _ => SystemSoundType.click,
      };

      await _platform.playSound(sound);
    } catch (e) {
      debugPrint('Error playing sound: $e');
      // Jest to tylko lokalny efekt aplikacji; nie wolno wywoływać awarii UI.
    }
  }
}

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return FeedbackService(ref);
});
