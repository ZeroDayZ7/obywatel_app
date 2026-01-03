import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/notifications/data/notification_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'notification_model.dart';

part 'notifications_controller.g.dart';

@riverpod
class NotificationsController extends _$NotificationsController {
  @override
  Stream<List<NotificationModel>> build() {
    final stream = ref.watch(notificationsDaoProvider).watchAllNotifications();
    // Automatycznie czyść stary kosz przy inicjalizacji kontrolera (opcjonalnie)
    // vacuumOldNotifications();
    Future.microtask(() => syncWithBackend());

    return stream;
  }

  Future<void> markAsRead(String id) async {
    // 1. Lokalnie
    await ref.read(notificationsDaoProvider).markAsRead(id);
    // 2. Serwer
    try {
      await NotificationApi(ref.read(authDioProvider)).markAsRead(id);
    } catch (e) {
      ref
          .read(appLoggerProvider)
          .e('Błąd oznaczania jako przeczytane w API: $id');
    }
  }

  Future<void> markAllAsRead() async {
    final logger = ref.read(appLoggerProvider);

    // 1. Najpierw baza lokalna (Błyskawiczna reakcja UI)
    await ref.read(notificationsDaoProvider).markAllAsRead();

    // 2. Potem strzał do API
    try {
      final dio = ref.read(authDioProvider);
      await NotificationApi(dio).markAllAsRead();
      logger.i(
        '✅ Oznaczono wszystkie powiadomienia jako przeczytane na serwerze',
      );
    } catch (e) {
      logger.e(
        '❌ Nie udało się zsynchronizować statusu "przeczytane" z serwerem',
      );
      // Tutaj opcjonalnie: jeśli API padnie, można by przeładować dane z serwera,
      // żeby przywrócić stan faktyczny, ale w mObywatelu zazwyczaj zostawia się to do następnej synchro.
    }
  }

  Future<void> moveToTrash(String id) async {
    // 1. Lokalnie
    await ref
        .read(notificationsDaoProvider)
        .updateDeletedAt(id, DateTime.now());
    // 2. Serwer (Soft Delete)
    try {
      await NotificationApi(ref.read(authDioProvider)).moveToTrash(id);
    } catch (e) {
      ref.read(appLoggerProvider).e('Błąd przenoszenia do kosza w API: $id');
    }
  }

  Future<void> clearAllTrash() async {
    // 1. Lokalnie
    await ref.read(notificationsDaoProvider).deleteAllTrash();
    // 2. Serwer (Hard Delete)
    try {
      await NotificationApi(ref.read(authDioProvider)).clearTrash();
    } catch (e) {
      ref.read(appLoggerProvider).e('Błąd czyszczenia kosza w API');
    }
  }

  Future<void> restoreFromTrash(String id) async {
    // 1. Lokalnie (UI reaguje od razu)
    await ref.read(notificationsDaoProvider).updateDeletedAt(id, null);

    // 2. Serwer
    try {
      await NotificationApi(ref.read(authDioProvider)).restoreFromTrash(id);
      ref
          .read(appLoggerProvider)
          .i('✅ Przywrócono powiadomienie na serwerze: $id');
    } catch (e) {
      ref.read(appLoggerProvider).e('❌ Błąd przywracania z kosza w API: $id');
      // Opcjonalnie: jeśli API zwróci błąd, przywracamy deletedAt lokalnie
      // await ref.read(notificationsDaoProvider).updateDeletedAt(id, DateTime.now());
    }
  }

  Future<void> deletePermanently(String id) async {
    // 1. Lokalnie
    await ref.read(notificationsDaoProvider).deleteNotification(id);

    // 2. API
    try {
      await NotificationApi(ref.read(authDioProvider)).deletePermanently(id);
    } catch (e) {
      ref.read(appLoggerProvider).e('Błąd usuwania w API: $id');
    }
  }

  Future<void> vacuumOldNotifications() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    await ref.read(notificationsDaoProvider).deleteOlderThan(sevenDaysAgo);
  }

  Future<void> syncWithBackend() async {
    final logger = ref.read(appLoggerProvider);
    try {
      final api = NotificationApi(ref.read(authDioProvider));
      final remoteNotifications = await api.fetchNotifications();

      // ZMIANA: Zamiast upsertNotifications, używamy nowej metody sync
      await ref
          .read(notificationsDaoProvider)
          .syncLocalWithRemote(remoteNotifications);

      logger.i(
        '🔄 Synchronizacja zakończona: ${remoteNotifications.length} powiadomień',
      );
    } catch (e, st) {
      logger.e('❌ Błąd synchronizacji powiadomień', error: e, stackTrace: st);
    }
  }
}

@riverpod
Stream<List<NotificationModel>> trashNotifications(Ref ref) {
  return ref.watch(notificationsDaoProvider).watchTrashNotifications();
}
