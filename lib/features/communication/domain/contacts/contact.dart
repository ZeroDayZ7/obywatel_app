import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/database/database.dart';

part 'contact.freezed.dart';

@freezed
abstract class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String ownerId,
    required String contactUserId,
    required String status,
    required String direction,
    String? localAlias,
    required String displayName,
    String? avatarUrl,
    bool? isOnline,
    DateTime? createdAt,
  }) = _Contact;

  factory Contact.fromEntity(
    ContactEntity entity, {
    String? currentUserId,
  }) {
    final currentUser = (currentUserId ?? '').trim();
    final peerUserId = switch (currentUser.isEmpty) {
      true => entity.contactId,
      false => () {
        if (entity.ownerId == currentUser) return entity.contactId;
        if (entity.contactId == currentUser) return entity.ownerId;
        return entity.contactId;
      }(),
    };

    final normalizedAlias = (entity.localAlias ?? '').trim();
    final resolvedDisplayName = normalizedAlias.isNotEmpty
        ? normalizedAlias
        : 'Użytkownik ${peerUserId.length >= 4 ? peerUserId.substring(0, 4) : peerUserId}';

    return Contact(
      id: entity.id,
      ownerId: entity.ownerId,
      contactUserId: peerUserId,
      status: entity.status,
      direction: entity.direction,
      localAlias: normalizedAlias.isNotEmpty ? normalizedAlias : null,
      displayName: resolvedDisplayName,
      createdAt: entity.createdAt,
    );
  }
}

extension ContactPeerUserIdX on Contact {
  String peerUserIdForCurrentUser(String currentUserId) {
    if (ownerId == currentUserId) {
      return contactUserId;
    }
    if (contactUserId == currentUserId) {
      return ownerId;
    }
    throw ArgumentError.value(
      currentUserId,
      'currentUserId',
      'The provided user is not a participant in this contact relation',
    );
  }
}
