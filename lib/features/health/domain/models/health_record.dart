import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_record.freezed.dart';
part 'health_record.g.dart';

enum HealthRecordType { prescriptions, referrals, history, vaccinations }

@freezed
sealed class HealthRecord with _$HealthRecord {
  const factory HealthRecord({
    required String id,
    required String title,
    required DateTime date,
    required HealthRecordType type,
    required String status,
    String? description,
    String? doctorName,
  }) = _HealthRecord;

  factory HealthRecord.fromJson(Map<String, dynamic> json) =>
      _$HealthRecordFromJson(json);
}
