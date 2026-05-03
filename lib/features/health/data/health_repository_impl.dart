import 'package:obywatel_plus/features/health/domain/models/health_record.dart';
import 'package:obywatel_plus/features/health/domain/repositories/health_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_repository_impl.g.dart';

class HealthRepositoryImpl implements HealthRepository {
  @override
  Future<List<HealthRecord>> getRecordsByType(HealthRecordType type) async {
    // Symulacja opóźnienia bazy/API
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      HealthRecord(
        id: '1',
        title: '${type.name.toUpperCase()} #123',
        date: DateTime.now(),
        type: type,
        status: 'Aktywne',
        doctorName: 'dr Jan Kowalski',
      ),
      HealthRecord(
        id: '2',
        title: '${type.name.toUpperCase()} #456',
        date: DateTime.now().subtract(const Duration(days: 5)),
        type: type,
        status: 'Zrealizowane',
      ),
    ];
  }

  @override
  Future<HealthRecord> getRecordDetails(String id) async {
    throw UnimplementedError();
  }
}

@Riverpod(keepAlive: true)
HealthRepository healthRepository(Ref ref) {
  return HealthRepositoryImpl();
}
