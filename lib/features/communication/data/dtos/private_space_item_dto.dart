class PrivateSpaceItemDto {
  const PrivateSpaceItemDto({
    required this.id,
    required this.spaceId,
    required this.ownerId,
    required this.deviceId,
    required this.title,
    required this.contentType,
    required this.encryptedPayload,
    required this.syncVersion,
    required this.createdAt,
    required this.updatedAt,
    this.status = 'active',
  });

  final String id;
  final String spaceId;
  final String ownerId;
  final String deviceId;
  final String title;
  final String contentType;
  final String encryptedPayload;
  final int syncVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  factory PrivateSpaceItemDto.fromJson(Map<String, dynamic> json) {
    return PrivateSpaceItemDto(
      id: (json['id'] ?? '').toString(),
      spaceId: (json['spaceId'] ?? '').toString(),
      ownerId: (json['ownerId'] ?? '').toString(),
      deviceId: (json['deviceId'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      contentType: (json['contentType'] ?? 'text').toString(),
      encryptedPayload: (json['encryptedPayload'] ?? '').toString(),
      syncVersion: (json['syncVersion'] is num)
          ? (json['syncVersion'] as num).toInt()
          : int.tryParse((json['syncVersion'] ?? '0').toString()) ?? 0,
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedAt: DateTime.tryParse((json['updatedAt'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      status: (json['status'] ?? 'active').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spaceId': spaceId,
      'ownerId': ownerId,
      'deviceId': deviceId,
      'title': title,
      'contentType': contentType,
      'encryptedPayload': encryptedPayload,
      'syncVersion': syncVersion,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'status': status,
    };
  }
}
