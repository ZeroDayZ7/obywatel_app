// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttachmentDto {

 String get id; String get userId; String? get conversationId; String? get messageId; String get fileKey; String get originalName; String get contentType; int get size; String? get sha256; String get status; Map<String, dynamic> get metadata; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of AttachmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentDtoCopyWith<AttachmentDto> get copyWith => _$AttachmentDtoCopyWithImpl<AttachmentDto>(this as AttachmentDto, _$identity);

  /// Serializes this AttachmentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachmentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.size, size) || other.size == size)&&(identical(other.sha256, sha256) || other.sha256 == sha256)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,conversationId,messageId,fileKey,originalName,contentType,size,sha256,status,const DeepCollectionEquality().hash(metadata),createdAt,updatedAt);

@override
String toString() {
  return 'AttachmentDto(id: $id, userId: $userId, conversationId: $conversationId, messageId: $messageId, fileKey: $fileKey, originalName: $originalName, contentType: $contentType, size: $size, sha256: $sha256, status: $status, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AttachmentDtoCopyWith<$Res>  {
  factory $AttachmentDtoCopyWith(AttachmentDto value, $Res Function(AttachmentDto) _then) = _$AttachmentDtoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? conversationId, String? messageId, String fileKey, String originalName, String contentType, int size, String? sha256, String status, Map<String, dynamic> metadata, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$AttachmentDtoCopyWithImpl<$Res>
    implements $AttachmentDtoCopyWith<$Res> {
  _$AttachmentDtoCopyWithImpl(this._self, this._then);

  final AttachmentDto _self;
  final $Res Function(AttachmentDto) _then;

/// Create a copy of AttachmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? conversationId = freezed,Object? messageId = freezed,Object? fileKey = null,Object? originalName = null,Object? contentType = null,Object? size = null,Object? sha256 = freezed,Object? status = null,Object? metadata = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as String,originalName: null == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,sha256: freezed == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachmentDto].
extension AttachmentDtoPatterns on AttachmentDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachmentDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentDto value)  $default,){
final _that = this;
switch (_that) {
case _AttachmentDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentDto value)?  $default,){
final _that = this;
switch (_that) {
case _AttachmentDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? conversationId,  String? messageId,  String fileKey,  String originalName,  String contentType,  int size,  String? sha256,  String status,  Map<String, dynamic> metadata,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachmentDto() when $default != null:
return $default(_that.id,_that.userId,_that.conversationId,_that.messageId,_that.fileKey,_that.originalName,_that.contentType,_that.size,_that.sha256,_that.status,_that.metadata,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? conversationId,  String? messageId,  String fileKey,  String originalName,  String contentType,  int size,  String? sha256,  String status,  Map<String, dynamic> metadata,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AttachmentDto():
return $default(_that.id,_that.userId,_that.conversationId,_that.messageId,_that.fileKey,_that.originalName,_that.contentType,_that.size,_that.sha256,_that.status,_that.metadata,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? conversationId,  String? messageId,  String fileKey,  String originalName,  String contentType,  int size,  String? sha256,  String status,  Map<String, dynamic> metadata,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AttachmentDto() when $default != null:
return $default(_that.id,_that.userId,_that.conversationId,_that.messageId,_that.fileKey,_that.originalName,_that.contentType,_that.size,_that.sha256,_that.status,_that.metadata,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachmentDto implements AttachmentDto {
  const _AttachmentDto({required this.id, required this.userId, this.conversationId, this.messageId, required this.fileKey, required this.originalName, required this.contentType, required this.size, this.sha256, required this.status, final  Map<String, dynamic> metadata = const <String, dynamic>{}, this.createdAt, this.updatedAt}): _metadata = metadata;
  factory _AttachmentDto.fromJson(Map<String, dynamic> json) => _$AttachmentDtoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? conversationId;
@override final  String? messageId;
@override final  String fileKey;
@override final  String originalName;
@override final  String contentType;
@override final  int size;
@override final  String? sha256;
@override final  String status;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of AttachmentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentDtoCopyWith<_AttachmentDto> get copyWith => __$AttachmentDtoCopyWithImpl<_AttachmentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachmentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.size, size) || other.size == size)&&(identical(other.sha256, sha256) || other.sha256 == sha256)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,conversationId,messageId,fileKey,originalName,contentType,size,sha256,status,const DeepCollectionEquality().hash(_metadata),createdAt,updatedAt);

@override
String toString() {
  return 'AttachmentDto(id: $id, userId: $userId, conversationId: $conversationId, messageId: $messageId, fileKey: $fileKey, originalName: $originalName, contentType: $contentType, size: $size, sha256: $sha256, status: $status, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AttachmentDtoCopyWith<$Res> implements $AttachmentDtoCopyWith<$Res> {
  factory _$AttachmentDtoCopyWith(_AttachmentDto value, $Res Function(_AttachmentDto) _then) = __$AttachmentDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? conversationId, String? messageId, String fileKey, String originalName, String contentType, int size, String? sha256, String status, Map<String, dynamic> metadata, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$AttachmentDtoCopyWithImpl<$Res>
    implements _$AttachmentDtoCopyWith<$Res> {
  __$AttachmentDtoCopyWithImpl(this._self, this._then);

  final _AttachmentDto _self;
  final $Res Function(_AttachmentDto) _then;

/// Create a copy of AttachmentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? conversationId = freezed,Object? messageId = freezed,Object? fileKey = null,Object? originalName = null,Object? contentType = null,Object? size = null,Object? sha256 = freezed,Object? status = null,Object? metadata = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AttachmentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as String,originalName: null == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,sha256: freezed == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AttachmentUploadResponseDto {

 AttachmentDto get attachment; String get uploadUrl; DateTime get expiresAt;
/// Create a copy of AttachmentUploadResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentUploadResponseDtoCopyWith<AttachmentUploadResponseDto> get copyWith => _$AttachmentUploadResponseDtoCopyWithImpl<AttachmentUploadResponseDto>(this as AttachmentUploadResponseDto, _$identity);

  /// Serializes this AttachmentUploadResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachmentUploadResponseDto&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attachment,uploadUrl,expiresAt);

@override
String toString() {
  return 'AttachmentUploadResponseDto(attachment: $attachment, uploadUrl: $uploadUrl, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $AttachmentUploadResponseDtoCopyWith<$Res>  {
  factory $AttachmentUploadResponseDtoCopyWith(AttachmentUploadResponseDto value, $Res Function(AttachmentUploadResponseDto) _then) = _$AttachmentUploadResponseDtoCopyWithImpl;
@useResult
$Res call({
 AttachmentDto attachment, String uploadUrl, DateTime expiresAt
});


$AttachmentDtoCopyWith<$Res> get attachment;

}
/// @nodoc
class _$AttachmentUploadResponseDtoCopyWithImpl<$Res>
    implements $AttachmentUploadResponseDtoCopyWith<$Res> {
  _$AttachmentUploadResponseDtoCopyWithImpl(this._self, this._then);

  final AttachmentUploadResponseDto _self;
  final $Res Function(AttachmentUploadResponseDto) _then;

/// Create a copy of AttachmentUploadResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attachment = null,Object? uploadUrl = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
attachment: null == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as AttachmentDto,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of AttachmentUploadResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttachmentDtoCopyWith<$Res> get attachment {
  
  return $AttachmentDtoCopyWith<$Res>(_self.attachment, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttachmentUploadResponseDto].
extension AttachmentUploadResponseDtoPatterns on AttachmentUploadResponseDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentUploadResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachmentUploadResponseDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentUploadResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _AttachmentUploadResponseDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentUploadResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _AttachmentUploadResponseDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AttachmentDto attachment,  String uploadUrl,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachmentUploadResponseDto() when $default != null:
return $default(_that.attachment,_that.uploadUrl,_that.expiresAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AttachmentDto attachment,  String uploadUrl,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _AttachmentUploadResponseDto():
return $default(_that.attachment,_that.uploadUrl,_that.expiresAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AttachmentDto attachment,  String uploadUrl,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _AttachmentUploadResponseDto() when $default != null:
return $default(_that.attachment,_that.uploadUrl,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachmentUploadResponseDto implements AttachmentUploadResponseDto {
  const _AttachmentUploadResponseDto({required this.attachment, required this.uploadUrl, required this.expiresAt});
  factory _AttachmentUploadResponseDto.fromJson(Map<String, dynamic> json) => _$AttachmentUploadResponseDtoFromJson(json);

@override final  AttachmentDto attachment;
@override final  String uploadUrl;
@override final  DateTime expiresAt;

/// Create a copy of AttachmentUploadResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentUploadResponseDtoCopyWith<_AttachmentUploadResponseDto> get copyWith => __$AttachmentUploadResponseDtoCopyWithImpl<_AttachmentUploadResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentUploadResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachmentUploadResponseDto&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attachment,uploadUrl,expiresAt);

@override
String toString() {
  return 'AttachmentUploadResponseDto(attachment: $attachment, uploadUrl: $uploadUrl, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$AttachmentUploadResponseDtoCopyWith<$Res> implements $AttachmentUploadResponseDtoCopyWith<$Res> {
  factory _$AttachmentUploadResponseDtoCopyWith(_AttachmentUploadResponseDto value, $Res Function(_AttachmentUploadResponseDto) _then) = __$AttachmentUploadResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 AttachmentDto attachment, String uploadUrl, DateTime expiresAt
});


@override $AttachmentDtoCopyWith<$Res> get attachment;

}
/// @nodoc
class __$AttachmentUploadResponseDtoCopyWithImpl<$Res>
    implements _$AttachmentUploadResponseDtoCopyWith<$Res> {
  __$AttachmentUploadResponseDtoCopyWithImpl(this._self, this._then);

  final _AttachmentUploadResponseDto _self;
  final $Res Function(_AttachmentUploadResponseDto) _then;

/// Create a copy of AttachmentUploadResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attachment = null,Object? uploadUrl = null,Object? expiresAt = null,}) {
  return _then(_AttachmentUploadResponseDto(
attachment: null == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as AttachmentDto,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of AttachmentUploadResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttachmentDtoCopyWith<$Res> get attachment {
  
  return $AttachmentDtoCopyWith<$Res>(_self.attachment, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}


/// @nodoc
mixin _$AttachmentDownloadResponseDto {

 String get attachmentId; String get contentType; String get downloadUrl; DateTime get expiresAt;
/// Create a copy of AttachmentDownloadResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentDownloadResponseDtoCopyWith<AttachmentDownloadResponseDto> get copyWith => _$AttachmentDownloadResponseDtoCopyWithImpl<AttachmentDownloadResponseDto>(this as AttachmentDownloadResponseDto, _$identity);

  /// Serializes this AttachmentDownloadResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachmentDownloadResponseDto&&(identical(other.attachmentId, attachmentId) || other.attachmentId == attachmentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attachmentId,contentType,downloadUrl,expiresAt);

@override
String toString() {
  return 'AttachmentDownloadResponseDto(attachmentId: $attachmentId, contentType: $contentType, downloadUrl: $downloadUrl, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $AttachmentDownloadResponseDtoCopyWith<$Res>  {
  factory $AttachmentDownloadResponseDtoCopyWith(AttachmentDownloadResponseDto value, $Res Function(AttachmentDownloadResponseDto) _then) = _$AttachmentDownloadResponseDtoCopyWithImpl;
@useResult
$Res call({
 String attachmentId, String contentType, String downloadUrl, DateTime expiresAt
});




}
/// @nodoc
class _$AttachmentDownloadResponseDtoCopyWithImpl<$Res>
    implements $AttachmentDownloadResponseDtoCopyWith<$Res> {
  _$AttachmentDownloadResponseDtoCopyWithImpl(this._self, this._then);

  final AttachmentDownloadResponseDto _self;
  final $Res Function(AttachmentDownloadResponseDto) _then;

/// Create a copy of AttachmentDownloadResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attachmentId = null,Object? contentType = null,Object? downloadUrl = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
attachmentId: null == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachmentDownloadResponseDto].
extension AttachmentDownloadResponseDtoPatterns on AttachmentDownloadResponseDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentDownloadResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachmentDownloadResponseDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentDownloadResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _AttachmentDownloadResponseDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentDownloadResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _AttachmentDownloadResponseDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String attachmentId,  String contentType,  String downloadUrl,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachmentDownloadResponseDto() when $default != null:
return $default(_that.attachmentId,_that.contentType,_that.downloadUrl,_that.expiresAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String attachmentId,  String contentType,  String downloadUrl,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _AttachmentDownloadResponseDto():
return $default(_that.attachmentId,_that.contentType,_that.downloadUrl,_that.expiresAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String attachmentId,  String contentType,  String downloadUrl,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _AttachmentDownloadResponseDto() when $default != null:
return $default(_that.attachmentId,_that.contentType,_that.downloadUrl,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachmentDownloadResponseDto implements AttachmentDownloadResponseDto {
  const _AttachmentDownloadResponseDto({required this.attachmentId, required this.contentType, required this.downloadUrl, required this.expiresAt});
  factory _AttachmentDownloadResponseDto.fromJson(Map<String, dynamic> json) => _$AttachmentDownloadResponseDtoFromJson(json);

@override final  String attachmentId;
@override final  String contentType;
@override final  String downloadUrl;
@override final  DateTime expiresAt;

/// Create a copy of AttachmentDownloadResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentDownloadResponseDtoCopyWith<_AttachmentDownloadResponseDto> get copyWith => __$AttachmentDownloadResponseDtoCopyWithImpl<_AttachmentDownloadResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentDownloadResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachmentDownloadResponseDto&&(identical(other.attachmentId, attachmentId) || other.attachmentId == attachmentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attachmentId,contentType,downloadUrl,expiresAt);

@override
String toString() {
  return 'AttachmentDownloadResponseDto(attachmentId: $attachmentId, contentType: $contentType, downloadUrl: $downloadUrl, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$AttachmentDownloadResponseDtoCopyWith<$Res> implements $AttachmentDownloadResponseDtoCopyWith<$Res> {
  factory _$AttachmentDownloadResponseDtoCopyWith(_AttachmentDownloadResponseDto value, $Res Function(_AttachmentDownloadResponseDto) _then) = __$AttachmentDownloadResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String attachmentId, String contentType, String downloadUrl, DateTime expiresAt
});




}
/// @nodoc
class __$AttachmentDownloadResponseDtoCopyWithImpl<$Res>
    implements _$AttachmentDownloadResponseDtoCopyWith<$Res> {
  __$AttachmentDownloadResponseDtoCopyWithImpl(this._self, this._then);

  final _AttachmentDownloadResponseDto _self;
  final $Res Function(_AttachmentDownloadResponseDto) _then;

/// Create a copy of AttachmentDownloadResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attachmentId = null,Object? contentType = null,Object? downloadUrl = null,Object? expiresAt = null,}) {
  return _then(_AttachmentDownloadResponseDto(
attachmentId: null == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
