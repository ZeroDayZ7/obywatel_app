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

  Future<void> addTestNotification() async {
    final now = DateTime.now();

    // Lista rozbudowanych powiadomień do testowania BottomSheet
    final List<NotificationModel> testMocks = [
      NotificationModel(
        id: 'test_adm_${now.millisecondsSinceEpoch}',
        title: "Decyzja administracyjna",
        content:
            "Szanowny Panie/Pani, informujemy, że w dniu dzisiejszym została wydana pozytywna decyzja nr 2026/ADM/123 w sprawie Twojego wniosku o dofinansowanie fotowoltaiki. Pełna treść decyzji wraz z uzasadnieniem i pouczeniem o przysługujących środkach odwoławczych jest dostępna w portalu e-Urząd. Masz 14 dni na wniesienie ewentualnego sprzeciwu.",
        createdAt: now,
        priority: NotificationPriority.info,
        category: NotificationCategory.administrative,
        isRead: false,
      ),
      NotificationModel(
        id: 'test_sec_${now.millisecondsSinceEpoch}',
        title: "Wykryto próbę logowania",
        content:
            "Alert bezpieczeństwa! Wykryto logowanie do Twojego konta Obywatel Plus z nowego urządzenia: Chrome na systemie Linux (IP: 192.168.1.102). Jeśli to nie Ty podjąłeś tę próbę, natychmiast zablokuj dostęp do swojego profilu i zmień hasło w zakładce Ustawienia.",
        createdAt: now.subtract(const Duration(minutes: 15)),
        priority: NotificationPriority.error,
        category: NotificationCategory.security,
        isRead: false,
      ),
      NotificationModel(
        id: 'test_pay_${now.millisecondsSinceEpoch}',
        title: "Przypomnienie o płatności",
        content:
            "Przypominamy o zbliżającym się terminie płatności za podatek od nieruchomości (IV rata). Kwota: 142,50 PLN. Termin upływa 15 stycznia 2026 r. Możesz dokonać płatności bezpośrednio w aplikacji, korzystając z kodu BLIK lub szybkiego przelewu.",
        createdAt: now.subtract(const Duration(hours: 2)),
        priority: NotificationPriority.warning,
        category: NotificationCategory.payments,
        isRead: false,
      ),
    ];

    // Zapisujemy listę do bazy za pomocą Twojego DAO
    await ref.read(notificationsDaoProvider).upsertNotifications(testMocks);
  }
}

@riverpod
Stream<List<NotificationModel>> trashNotifications(Ref ref) {
  return ref.watch(notificationsDaoProvider).watchTrashNotifications();
}
