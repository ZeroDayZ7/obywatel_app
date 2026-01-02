import 'package:drift/drift.dart';
// Musisz to mieć tutaj!
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';

@DataClassName('DbNotification')
class Notifications extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();

  IntColumn get priority => intEnum<NotificationPriority>()();
  IntColumn get category => intEnum<NotificationCategory>()();

  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
