String _stringFromJson(Object? value) => value?.toString() ?? '';
String? _nullableStringFromJson(Object? value) => value?.toString();
Map<String, dynamic> _metadataFromJson(Object? value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return const <String, dynamic>{};
}

class AttachmentDto {
  const AttachmentDto({
    required this.id,
    required this.userId,
    this.conversationId,
    this.messageId,
    required this.fileKey,
    required this.originalName,
    required this.contentType,
    required this.size,
    this.sha256,
    required this.status,
    this.metadata = const <String, dynamic>{},
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String? conversationId;
  final String? messageId;
  final String fileKey;
  final String originalName;
  final String contentType;
  final int size;
  final String? sha256;
  final String status;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AttachmentDto.fromJson(Map<String, dynamic> json) {
    return AttachmentDto(
      id: _stringFromJson(json['id']),
      userId: _stringFromJson(json['userId']),
      conversationId: _nullableStringFromJson(json['conversationId']),
      messageId: _nullableStringFromJson(json['messageId']),
      fileKey: _stringFromJson(json['fileKey']),
      originalName: _stringFromJson(json['originalName']),
      contentType: _stringFromJson(json['contentType']),
      size: (json['size'] is int)
          ? json['size'] as int
          : int.tryParse(json['size']?.toString() ?? '0') ?? 0,
      sha256: _nullableStringFromJson(json['sha256']),
      status: _stringFromJson(json['status']),
      metadata: _metadataFromJson(json['metadata']),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      if (conversationId != null) 'conversationId': conversationId,
      if (messageId != null) 'messageId': messageId,
      'fileKey': fileKey,
      'originalName': originalName,
      'contentType': contentType,
      'size': size,
      if (sha256 != null) 'sha256': sha256,
      'status': status,
      'metadata': metadata,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

class AttachmentUploadResponseDto {
  const AttachmentUploadResponseDto({
    required this.attachment,
    required this.uploadUrl,
    required this.expiresAt,
  });

  final AttachmentDto attachment;
  final String uploadUrl;
  final DateTime expiresAt;

  factory AttachmentUploadResponseDto.fromJson(Map<String, dynamic> json) {
    final rawAttachment = json['attachment'];
    return AttachmentUploadResponseDto(
      attachment: rawAttachment is Map
          ? AttachmentDto.fromJson(Map<String, dynamic>.from(rawAttachment))
          : const AttachmentDto(
              id: '',
              userId: '',
              fileKey: '',
              originalName: '',
              contentType: '',
              size: 0,
              status: '',
            ),
      uploadUrl: _stringFromJson(json['uploadUrl']),
      expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'attachment': attachment.toJson(),
      'uploadUrl': uploadUrl,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
