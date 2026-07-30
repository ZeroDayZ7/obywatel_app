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
    required String displayName,
    String? avatarUrl,
    bool? isOnline,
    DateTime? createdAt,
  }) = _Contact;

  factory Contact.fromEntity(ContactEntity entity) {
    return Contact(
      id: entity.id,
      ownerId: entity.ownerId,
      contactUserId: entity.contactId,
      status: entity.status,
      displayName:
          'Użytkownik ${entity.contactId.length >= 4 ? entity.contactId.substring(0, 4) : entity.contactId}',
      createdAt: entity.createdAt,
    );
  }
}
