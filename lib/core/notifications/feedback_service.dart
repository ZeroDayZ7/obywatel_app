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
  final Ref _ref;
  final FeedbackPlatform _platform;

  FeedbackService(this._ref, {FeedbackPlatform? platform})
      : _platform = platform ?? const FlutterFeedbackPlatform();

  Future<void> trigger(
    FeedbackType type, {
    NotificationModuleId moduleId = NotificationModuleId.general,
  }) async {
    final settings = _ref.read(appNotificationSettingsProvider);
    final modulePolicy = _ref
            .read(moduleNotificationSettingsProvider)[moduleId] ??
        ModuleFeedbackPolicy(moduleId: moduleId);

    final canSound = settings.appNotifications &&
        modulePolicy.isSoundEnabled(globalEnabled: settings.sound);
    final canVibrate = settings.appNotifications &&
        modulePolicy.isVibrationEnabled(globalEnabled: settings.vibration);

    if (!settings.appNotifications || (!canSound && !canVibrate)) {
      return;
    }

    final tasks = <Future<void>>[];
    if (canVibrate) {
      tasks.add(_vibrate(type));
    }
    if (canSound) {
      tasks.add(_playSound(type));
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
          await _platform.vibrate(
            pattern: [0, 200, 100, 200, 100, 500],
            intensities: [0, 255, 0, 255, 0, 255],
          );
          break;

        case FeedbackType.error:
          await HapticFeedback.heavyImpact();
          await _platform.vibrate(duration: 400);
          break;

        case FeedbackType.success:
          await HapticFeedback.mediumImpact();
          break;

        case FeedbackType.warning:
          await HapticFeedback.lightImpact();
          await Future.delayed(const Duration(milliseconds: 50));
          await HapticFeedback.lightImpact();
          break;

        case FeedbackType.info:
          await HapticFeedback.selectionClick();
          break;

        case FeedbackType.light:
          await HapticFeedback.lightImpact();
          break;

        case FeedbackType.medium:
          await HapticFeedback.mediumImpact();
          break;

        case FeedbackType.heavy:
          await HapticFeedback.heavyImpact();
          break;

        case FeedbackType.selection:
          await HapticFeedback.selectionClick();
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
