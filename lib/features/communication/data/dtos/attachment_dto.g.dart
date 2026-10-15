// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttachmentDto _$AttachmentDtoFromJson(Map<String, dynamic> json) =>
    _AttachmentDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      conversationId: json['conversationId'] as String?,
      messageId: json['messageId'] as String?,
      fileKey: json['fileKey'] as String,
      originalName: json['originalName'] as String,
      contentType: json['contentType'] as String,
      size: (json['size'] as num).toInt(),
      sha256: json['sha256'] as String?,
      status: json['status'] as String,
      metadata:
          json['metadata'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AttachmentDtoToJson(_AttachmentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'conversationId': instance.conversationId,
      'messageId': instance.messageId,
      'fileKey': instance.fileKey,
      'originalName': instance.originalName,
      'contentType': instance.contentType,
      'size': instance.size,
      'sha256': instance.sha256,
      'status': instance.status,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_AttachmentUploadResponseDto _$AttachmentUploadResponseDtoFromJson(
  Map<String, dynamic> json,
) => _AttachmentUploadResponseDto(
  attachment: AttachmentDto.fromJson(
    json['attachment'] as Map<String, dynamic>,
  ),
  uploadUrl: json['uploadUrl'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$AttachmentUploadResponseDtoToJson(
  _AttachmentUploadResponseDto instance,
) => <String, dynamic>{
  'attachment': instance.attachment,
  'uploadUrl': instance.uploadUrl,
  'expiresAt': instance.expiresAt.toIso8601String(),
};

_AttachmentDownloadResponseDto _$AttachmentDownloadResponseDtoFromJson(
  Map<String, dynamic> json,
) => _AttachmentDownloadResponseDto(
  attachmentId: json['attachmentId'] as String,
  contentType: json['contentType'] as String,
  downloadUrl: json['downloadUrl'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$AttachmentDownloadResponseDtoToJson(
  _AttachmentDownloadResponseDto instance,
) => <String, dynamic>{
  'attachmentId': instance.attachmentId,
  'contentType': instance.contentType,
  'downloadUrl': instance.downloadUrl,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
