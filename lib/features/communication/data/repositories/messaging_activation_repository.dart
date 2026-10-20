import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';
import 'package:obywatel_plus/features/communication/domain/models/messaging_activation_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messaging_activation_repository.g.dart';

class MessagingActivationRepository {
  const MessagingActivationRepository(this._db);

  final AppDatabase _db;

  Future<MessagingActivationState?> readForContext({
    required String userId,
    required String deviceId,
  }) async {
    final row = await (_db.select(_db.messagingActivationStates)
          ..where(
            (tbl) => tbl.userId.equals(userId) & tbl.deviceId.equals(deviceId),
          ))
        .getSingleOrNull();

    if (row == null) {
      return null;
    }

    final hasMeaningfulStatus =
        row.status != 'not_started' || row.consentAccepted || row.requiresTermsAcceptance;

    return MessagingActivationState(
      status: hasMeaningfulStatus
          ? MessagingActivationDto(
              userId: row.userId,
              status: row.status,
              consentAccepted: row.consentAccepted,
              termsVersion: row.termsVersion,
              currentTermsVersion: row.currentTermsVersion,
              requiresTermsAcceptance: row.requiresTermsAcceptance,
              deviceId: row.deviceId,
            )
          : null,
      terms: null,
      keyRegistrationStatus: row.keyRegistrationStatus,
      errorMessage: row.keyRegistrationStatus == 'failed' ? row.lastError : null,
    );
  }

  Future<void> saveState({
    required String userId,
    required String deviceId,
    required MessagingActivationState state,
  }) async {
    final existing = await (_db.select(_db.messagingActivationStates)
          ..where(
            (tbl) => tbl.userId.equals(userId) & tbl.deviceId.equals(deviceId),
          ))
        .getSingleOrNull();

    final now = DateTime.now().toUtc();
    final row = MessagingActivationStateRow(
      userId: userId,
      deviceId: deviceId,
      consentAccepted: state.status?.consentAccepted ?? false,
      status: state.status?.status ?? 'not_started',
      termsVersion: state.status?.termsVersion ?? '',
      currentTermsVersion: state.status?.currentTermsVersion ?? '',
      requiresTermsAcceptance: state.status?.requiresTermsAcceptance ?? false,
      keyRegistrationStatus: state.keyRegistrationStatus,
      lastError: state.keyRegistrationStatus == 'failed' ? state.errorMessage : null,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    await _db.transaction(() async {
      await _db
          .into(_db.messagingActivationStates)
          .insert(row, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> clearForContext({
    required String userId,
    required String deviceId,
  }) async {
    await (_db.delete(_db.messagingActivationStates)
          ..where(
            (tbl) => tbl.userId.equals(userId) & tbl.deviceId.equals(deviceId),
          ))
        .go();
  }

  Future<void> setKeyRegistrationStatus({
    required String userId,
    required String deviceId,
    required String status,
  }) async {
    final current = await readForContext(userId: userId, deviceId: deviceId);
    if (current == null) {
      return;
    }

    await saveState(
      userId: userId,
      deviceId: deviceId,
      state: current.copyWith(keyRegistrationStatus: status),
    );
  }
}

@riverpod
MessagingActivationRepository messagingActivationRepository(Ref ref) {
  return MessagingActivationRepository(ref.watch(appDatabaseProvider));
}
