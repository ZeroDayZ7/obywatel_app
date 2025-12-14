import 'package:hive/hive.dart';

part 'notification_hive_model.g.dart';

@HiveType(typeId: 10)
class NotificationHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime? readAt;

  @HiveField(5)
  final String type;

  @HiveField(6)
  final String? route;

  NotificationHiveModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.readAt,
    required this.type,
    this.route,
  });
}
