import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/tables/sync_state.dart';

part 'sync_state_dao.g.dart';

@DriftAccessor(tables: [SyncState])
class SyncStateDao extends DatabaseAccessor<AppDatabase>
    with _$SyncStateDaoMixin {
  SyncStateDao(super.db);

  Future<SyncStateEntity?> getForUser(String userId) {
    return (select(syncState)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
  }

  Future<void> upsertCheckpoint({
    required String userId,
    required BigInt lastKnownMessageVersion,
    required BigInt lastKnownContactVersion,
  }) async {
    await transaction(() async {
      await into(syncState).insertOnConflictUpdate(
        SyncStateCompanion(
          userId: Value(userId),
          lastKnownMessageVersion: Value(lastKnownMessageVersion),
          lastKnownContactVersion: Value(lastKnownContactVersion),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }
}
