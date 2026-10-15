// lib/features/communication/data/dtos/attachment_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_dto.freezed.dart';
part 'attachment_dto.g.dart';

@freezed
abstract class AttachmentDto with _$AttachmentDto {
  const factory AttachmentDto({
    required String id,
    required String userId,
    String? conversationId,
    String? messageId,
    required String fileKey,
    required String originalName,
    required String contentType,
    required int size,
    String? sha256,
    required String status,
    @Default(<String, dynamic>{}) Map<String, dynamic> metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AttachmentDto;

  factory AttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$AttachmentDtoFromJson(json);
}

@freezed
abstract class AttachmentUploadResponseDto with _$AttachmentUploadResponseDto {
  const factory AttachmentUploadResponseDto({
    required AttachmentDto attachment,
    required String uploadUrl,
    required DateTime expiresAt,
  }) = _AttachmentUploadResponseDto;

  factory AttachmentUploadResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AttachmentUploadResponseDtoFromJson(json);
}

@freezed
abstract class AttachmentDownloadResponseDto with _$AttachmentDownloadResponseDto {
  const factory AttachmentDownloadResponseDto({
    required String attachmentId,
    required String contentType,
    required String downloadUrl,
    required DateTime expiresAt,
  }) = _AttachmentDownloadResponseDto;

  factory AttachmentDownloadResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AttachmentDownloadResponseDtoFromJson(json);
}