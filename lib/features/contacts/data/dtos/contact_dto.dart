// lib/features/contacts/data/dtos/contact_dto.dart
import 'package:drift/drift.dart' hide JsonKey;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/database/database.dart';

part 'contact_dto.freezed.dart';
part 'contact_dto.g.dart';

@freezed
abstract class ContactDto with _$ContactDto {
  const factory ContactDto({
    @JsonKey(name: 'ID') required String id,
    @JsonKey(name: 'OwnerID') required String ownerId,
    @JsonKey(name: 'ContactID') required String contactId,
    @JsonKey(name: 'Status') required String status,
    @JsonKey(name: 'Version') required int version,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ContactDto;

  factory ContactDto.fromJson(Map<String, dynamic> json) =>
      _$ContactDtoFromJson(json);
}

extension ContactDtoX on ContactDto {
  ContactsCompanion toCompanion() {
    return ContactsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      contactId: Value(contactId),
      status: Value(status),
      version: Value(BigInt.from(version)),
      createdAt: createdAt != null ? Value(createdAt!) : const Value.absent(),
      updatedAt: updatedAt != null ? Value(updatedAt!) : const Value.absent(),
    );
  }
}
