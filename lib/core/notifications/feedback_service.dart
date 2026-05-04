import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';
// Musisz zaimportować swój notifier z features!
// Podaj poprawną ścieżkę do Twojego pliku
import 'package:obywatel_plus/features/settings/domain/notification_settings_notifier.dart';
import 'package:vibration/vibration.dart';

class FeedbackService {
  // Ref pozwala nam czytać inne providery wewnątrz klasy
  final Ref _ref;

  FeedbackService(this._ref);

  Future<void> trigger(FeedbackType type) async {
    bool canVibrate = false;
    bool canSound = false;
    bool canShowAppNotifications = true;

    try {
      final settings = _ref.read(notificationSettingsProvider);
      canVibrate = settings.vibration;
      canSound = settings.sound;
      canShowAppNotifications = settings.appNotifications;
    } catch (_) {
      // Jeśli rzuci błąd (bo provider usunięty), canVibrate zostaje false.
      // To zapobiega "żarciu" powiadomień i błędom w logach.
    }

    if (!canShowAppNotifications) return;

    final List<Future<void>> tasks = [];
    if (canVibrate) tasks.add(_vibrate(type));
    if (canSound) tasks.add(_playSound(type));

    if (tasks.isNotEmpty) {
      await Future.wait(tasks);
    }
  }

  Future<void> _vibrate(FeedbackType type) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) return;

    switch (type) {
      case FeedbackType.securityAlert:
        await Vibration.vibrate(
          pattern: [0, 200, 100, 200, 100, 500],
          intensities: [0, 255, 0, 255, 0, 255],
        );
      case FeedbackType.error:
        await HapticFeedback.heavyImpact();
        await Vibration.vibrate(duration: 400);
      case FeedbackType.success:
        await HapticFeedback.mediumImpact();
      case FeedbackType.warning:
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 50));
        await HapticFeedback.lightImpact();
      case FeedbackType.info:
        await HapticFeedback.selectionClick();
    }
  }

  Future<void> _playSound(FeedbackType type) async {
    SystemSoundType sound;

    switch (type) {
      case FeedbackType.error:
      case FeedbackType.securityAlert:
        sound = SystemSoundType.alert;
        break;
      default:
        sound = SystemSoundType.click;
    }

    await SystemSound.play(sound);
  }
}

// Definicja providera
final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return FeedbackService(ref);
});
