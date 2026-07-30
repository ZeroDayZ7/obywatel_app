// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageDto {

@JsonKey(name: 'ID') String get id;@JsonKey(name: 'ConversationID') String get conversationId;@JsonKey(name: 'SenderID') String get senderId;@JsonKey(name: 'SenderDeviceID') String? get senderDeviceId;@JsonKey(name: 'Type') String get type;@JsonKey(name: 'Sequence') int get sequence;@JsonKey(name: 'Version') int get version;@JsonKey(name: 'EncryptedPayload') String get encryptedPayload;@JsonKey(name: 'Nonce') String? get nonce;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageDtoCopyWith<MessageDto> get copyWith => _$MessageDtoCopyWithImpl<MessageDto>(this as MessageDto, _$identity);

  /// Serializes this MessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderDeviceId, senderDeviceId) || other.senderDeviceId == senderDeviceId)&&(identical(other.type, type) || other.type == type)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.version, version) || other.version == version)&&(identical(other.encryptedPayload, encryptedPayload) || other.encryptedPayload == encryptedPayload)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,senderDeviceId,type,sequence,version,encryptedPayload,nonce,createdAt);

@override
String toString() {
  return 'MessageDto(id: $id, conversationId: $conversationId, senderId: $senderId, senderDeviceId: $senderDeviceId, type: $type, sequence: $sequence, version: $version, encryptedPayload: $encryptedPayload, nonce: $nonce, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MessageDtoCopyWith<$Res>  {
  factory $MessageDtoCopyWith(MessageDto value, $Res Function(MessageDto) _then) = _$MessageDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ID') String id,@JsonKey(name: 'ConversationID') String conversationId,@JsonKey(name: 'SenderID') String senderId,@JsonKey(name: 'SenderDeviceID') String? senderDeviceId,@JsonKey(name: 'Type') String type,@JsonKey(name: 'Sequence') int sequence,@JsonKey(name: 'Version') int version,@JsonKey(name: 'EncryptedPayload') String encryptedPayload,@JsonKey(name: 'Nonce') String? nonce,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$MessageDtoCopyWithImpl<$Res>
    implements $MessageDtoCopyWith<$Res> {
  _$MessageDtoCopyWithImpl(this._self, this._then);

  final MessageDto _self;
  final $Res Function(MessageDto) _then;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? senderDeviceId = freezed,Object? type = null,Object? sequence = null,Object? version = null,Object? encryptedPayload = null,Object? nonce = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderDeviceId: freezed == senderDeviceId ? _self.senderDeviceId : senderDeviceId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,encryptedPayload: null == encryptedPayload ? _self.encryptedPayload : encryptedPayload // ignore: cast_nullable_to_non_nullable
as String,nonce: freezed == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageDto].
extension MessageDtoPatterns on MessageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageDto value)  $default,){
final _that = this;
switch (_that) {
case _MessageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'ConversationID')  String conversationId, @JsonKey(name: 'SenderID')  String senderId, @JsonKey(name: 'SenderDeviceID')  String? senderDeviceId, @JsonKey(name: 'Type')  String type, @JsonKey(name: 'Sequence')  int sequence, @JsonKey(name: 'Version')  int version, @JsonKey(name: 'EncryptedPayload')  String encryptedPayload, @JsonKey(name: 'Nonce')  String? nonce, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderDeviceId,_that.type,_that.sequence,_that.version,_that.encryptedPayload,_that.nonce,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'ConversationID')  String conversationId, @JsonKey(name: 'SenderID')  String senderId, @JsonKey(name: 'SenderDeviceID')  String? senderDeviceId, @JsonKey(name: 'Type')  String type, @JsonKey(name: 'Sequence')  int sequence, @JsonKey(name: 'Version')  int version, @JsonKey(name: 'EncryptedPayload')  String encryptedPayload, @JsonKey(name: 'Nonce')  String? nonce, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _MessageDto():
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderDeviceId,_that.type,_that.sequence,_that.version,_that.encryptedPayload,_that.nonce,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'ConversationID')  String conversationId, @JsonKey(name: 'SenderID')  String senderId, @JsonKey(name: 'SenderDeviceID')  String? senderDeviceId, @JsonKey(name: 'Type')  String type, @JsonKey(name: 'Sequence')  int sequence, @JsonKey(name: 'Version')  int version, @JsonKey(name: 'EncryptedPayload')  String encryptedPayload, @JsonKey(name: 'Nonce')  String? nonce, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderDeviceId,_that.type,_that.sequence,_that.version,_that.encryptedPayload,_that.nonce,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageDto implements MessageDto {
  const _MessageDto({@JsonKey(name: 'ID') required this.id, @JsonKey(name: 'ConversationID') required this.conversationId, @JsonKey(name: 'SenderID') required this.senderId, @JsonKey(name: 'SenderDeviceID') this.senderDeviceId, @JsonKey(name: 'Type') required this.type, @JsonKey(name: 'Sequence') this.sequence = 0, @JsonKey(name: 'Version') this.version = 1, @JsonKey(name: 'EncryptedPayload') this.encryptedPayload = '', @JsonKey(name: 'Nonce') this.nonce, @JsonKey(name: 'created_at') required this.createdAt});
  factory _MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

@override@JsonKey(name: 'ID') final  String id;
@override@JsonKey(name: 'ConversationID') final  String conversationId;
@override@JsonKey(name: 'SenderID') final  String senderId;
@override@JsonKey(name: 'SenderDeviceID') final  String? senderDeviceId;
@override@JsonKey(name: 'Type') final  String type;
@override@JsonKey(name: 'Sequence') final  int sequence;
@override@JsonKey(name: 'Version') final  int version;
@override@JsonKey(name: 'EncryptedPayload') final  String encryptedPayload;
@override@JsonKey(name: 'Nonce') final  String? nonce;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageDtoCopyWith<_MessageDto> get copyWith => __$MessageDtoCopyWithImpl<_MessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderDeviceId, senderDeviceId) || other.senderDeviceId == senderDeviceId)&&(identical(other.type, type) || other.type == type)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.version, version) || other.version == version)&&(identical(other.encryptedPayload, encryptedPayload) || other.encryptedPayload == encryptedPayload)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,senderDeviceId,type,sequence,version,encryptedPayload,nonce,createdAt);

@override
String toString() {
  return 'MessageDto(id: $id, conversationId: $conversationId, senderId: $senderId, senderDeviceId: $senderDeviceId, type: $type, sequence: $sequence, version: $version, encryptedPayload: $encryptedPayload, nonce: $nonce, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MessageDtoCopyWith<$Res> implements $MessageDtoCopyWith<$Res> {
  factory _$MessageDtoCopyWith(_MessageDto value, $Res Function(_MessageDto) _then) = __$MessageDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ID') String id,@JsonKey(name: 'ConversationID') String conversationId,@JsonKey(name: 'SenderID') String senderId,@JsonKey(name: 'SenderDeviceID') String? senderDeviceId,@JsonKey(name: 'Type') String type,@JsonKey(name: 'Sequence') int sequence,@JsonKey(name: 'Version') int version,@JsonKey(name: 'EncryptedPayload') String encryptedPayload,@JsonKey(name: 'Nonce') String? nonce,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$MessageDtoCopyWithImpl<$Res>
    implements _$MessageDtoCopyWith<$Res> {
  __$MessageDtoCopyWithImpl(this._self, this._then);

  final _MessageDto _self;
  final $Res Function(_MessageDto) _then;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? senderDeviceId = freezed,Object? type = null,Object? sequence = null,Object? version = null,Object? encryptedPayload = null,Object? nonce = freezed,Object? createdAt = null,}) {
  return _then(_MessageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderDeviceId: freezed == senderDeviceId ? _self.senderDeviceId : senderDeviceId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,encryptedPayload: null == encryptedPayload ? _self.encryptedPayload : encryptedPayload // ignore: cast_nullable_to_non_nullable
as String,nonce: freezed == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
