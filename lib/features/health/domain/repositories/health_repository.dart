

import 'package:obywatel_plus/features/health/domain/models/health_record.dart';

abstract class HealthRepository {
  Future<List<HealthRecord>> getRecordsByType(HealthRecordType type);
  Future<HealthRecord> getRecordDetails(String id);
}