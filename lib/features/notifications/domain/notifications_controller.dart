import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'notification_model.dart';

part 'notifications_controller.g.dart';

@riverpod
class NotificationsController extends _$NotificationsController {
  @override
  Stream<List<NotificationModel>> build() {
    // Automatycznie czyść stary kosz przy inicjalizacji kontrolera (opcjonalnie)
    // vacuumOldNotifications();

    return ref.watch(notificationsDaoProvider).watchAllNotifications();
  }

  Future<void> markAsRead(String id) async {
    await ref.read(notificationsDaoProvider).markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    await ref.read(notificationsDaoProvider).markAllAsRead();
  }

  Future<void> moveToTrash(String id) async {
    await ref
        .read(notificationsDaoProvider)
        .updateDeletedAt(id, DateTime.now());
  }

  Future<void> restoreFromTrash(String id) async {
    await ref.read(notificationsDaoProvider).updateDeletedAt(id, null);
  }

  Future<void> deletePermanently(String id) async {
    await ref.read(notificationsDaoProvider).deleteNotification(id);
  }

  Future<void> vacuumOldNotifications() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    await ref.read(notificationsDaoProvider).deleteOlderThan(sevenDaysAgo);
  }

  Future<void> clearAllTrash() async {
    await ref.read(notificationsDaoProvider).deleteAllTrash();
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
