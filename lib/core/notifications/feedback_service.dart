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
    final settings = _ref.read(notificationSettingsProvider);
    if (!settings.appNotifications) return;

    // Tworzymy listę zadań, które mają się wydarzyć
    final List<Future<void>> tasks = [];

    // Sprawdzamy wibracje
    if (settings.vibration) {
      tasks.add(_vibrate(type));
    }

    // Sprawdzamy dźwięk
    if (settings.sound) {
      tasks.add(_playSound(type));
    }

    // Uruchamiamy wszystkie zadania z listy W TYM SAMYM MOMENCIE
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
