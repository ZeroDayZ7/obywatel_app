import 'package:obywatel_plus/features/health/data/health_repository_impl.dart';
import 'package:obywatel_plus/features/health/domain/models/health_record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_records_provider.g.dart';

@riverpod
class HealthRecordsNotifier extends _$HealthRecordsNotifier {
  @override
  FutureOr<List<HealthRecord>> build(HealthRecordType type) {
    return ref.read(healthRepositoryProvider).getRecordsByType(type);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
