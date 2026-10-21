// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageRecord {

 String? get id; String? get messageId; String? get conversationId; String? get senderUserId; String? get senderDeviceId; String? get recipientUserId; String? get recipientDeviceId; String? get ciphertext; String? get type; DateTime? get createdAt; DateTime? get expiresAt; bool get isDelivered; int get version;
/// Create a copy of MessageRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageRecordCopyWith<MessageRecord> get copyWith => _$MessageRecordCopyWithImpl<MessageRecord>(this as MessageRecord, _$identity);

  /// Serializes this MessageRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MessageRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.senderUserId, _this.senderUserId) || other.senderUserId == _this.senderUserId)&&(identical(other.senderDeviceId, _this.senderDeviceId) || other.senderDeviceId == _this.senderDeviceId)&&(identical(other.recipientUserId, _this.recipientUserId) || other.recipientUserId == _this.recipientUserId)&&(identical(other.recipientDeviceId, _this.recipientDeviceId) || other.recipientDeviceId == _this.recipientDeviceId)&&(identical(other.ciphertext, _this.ciphertext) || other.ciphertext == _this.ciphertext)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.isDelivered, _this.isDelivered) || other.isDelivered == _this.isDelivered)&&(identical(other.version, _this.version) || other.version == _this.version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MessageRecord;
  return Object.hash(runtimeType,_this.id,_this.messageId,_this.conversationId,_this.senderUserId,_this.senderDeviceId,_this.recipientUserId,_this.recipientDeviceId,_this.ciphertext,_this.type,_this.createdAt,_this.expiresAt,_this.isDelivered,_this.version);
}

@override
String toString() {
  final _this = this as MessageRecord;
  return 'MessageRecord(id: ${_this.id}, messageId: ${_this.messageId}, conversationId: ${_this.conversationId}, senderUserId: ${_this.senderUserId}, senderDeviceId: ${_this.senderDeviceId}, recipientUserId: ${_this.recipientUserId}, recipientDeviceId: ${_this.recipientDeviceId}, ciphertext: ${_this.ciphertext}, type: ${_this.type}, createdAt: ${_this.createdAt}, expiresAt: ${_this.expiresAt}, isDelivered: ${_this.isDelivered}, version: ${_this.version})';
}


}

/// @nodoc
abstract mixin class $MessageRecordCopyWith<$Res>  {
  factory $MessageRecordCopyWith(MessageRecord value, $Res Function(MessageRecord) _then) = _$MessageRecordCopyWithImpl;
@useResult
$Res call({
 String? id, String? messageId, String? conversationId, String? senderUserId, String? senderDeviceId, String? recipientUserId, String? recipientDeviceId, String? ciphertext, String? type, DateTime? createdAt, DateTime? expiresAt, bool isDelivered, int version
});




}
/// @nodoc
class _$MessageRecordCopyWithImpl<$Res>
    implements $MessageRecordCopyWith<$Res> {
  _$MessageRecordCopyWithImpl(this._self, this._then);

  final MessageRecord _self;
  final $Res Function(MessageRecord) _then;

/// Create a copy of MessageRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? messageId = freezed,Object? conversationId = freezed,Object? senderUserId = freezed,Object? senderDeviceId = freezed,Object? recipientUserId = freezed,Object? recipientDeviceId = freezed,Object? ciphertext = freezed,Object? type = freezed,Object? createdAt = freezed,Object? expiresAt = freezed,Object? isDelivered = null,Object? version = null,}) {
  return _then(MessageRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,senderUserId: freezed == senderUserId ? _self.senderUserId : senderUserId // ignore: cast_nullable_to_non_nullable
as String?,senderDeviceId: freezed == senderDeviceId ? _self.senderDeviceId : senderDeviceId // ignore: cast_nullable_to_non_nullable
as String?,recipientUserId: freezed == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String?,recipientDeviceId: freezed == recipientDeviceId ? _self.recipientDeviceId : recipientDeviceId // ignore: cast_nullable_to_non_nullable
as String?,ciphertext: freezed == ciphertext ? _self.ciphertext : ciphertext // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDelivered: null == isDelivered ? _self.isDelivered : isDelivered // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageRecord].
extension MessageRecordPatterns on MessageRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageRecord value)  $default,){
final _that = this;
switch (_that) {
case _MessageRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MessageRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? messageId,  String? conversationId,  String? senderUserId,  String? senderDeviceId,  String? recipientUserId,  String? recipientDeviceId,  String? ciphertext,  String? type,  DateTime? createdAt,  DateTime? expiresAt,  bool isDelivered,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageRecord() when $default != null:
return $default(_that.id,_that.messageId,_that.conversationId,_that.senderUserId,_that.senderDeviceId,_that.recipientUserId,_that.recipientDeviceId,_that.ciphertext,_that.type,_that.createdAt,_that.expiresAt,_that.isDelivered,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? messageId,  String? conversationId,  String? senderUserId,  String? senderDeviceId,  String? recipientUserId,  String? recipientDeviceId,  String? ciphertext,  String? type,  DateTime? createdAt,  DateTime? expiresAt,  bool isDelivered,  int version)  $default,) {final _that = this;
switch (_that) {
case _MessageRecord():
return $default(_that.id,_that.messageId,_that.conversationId,_that.senderUserId,_that.senderDeviceId,_that.recipientUserId,_that.recipientDeviceId,_that.ciphertext,_that.type,_that.createdAt,_that.expiresAt,_that.isDelivered,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? messageId,  String? conversationId,  String? senderUserId,  String? senderDeviceId,  String? recipientUserId,  String? recipientDeviceId,  String? ciphertext,  String? type,  DateTime? createdAt,  DateTime? expiresAt,  bool isDelivered,  int version)?  $default,) {final _that = this;
switch (_that) {
case _MessageRecord() when $default != null:
return $default(_that.id,_that.messageId,_that.conversationId,_that.senderUserId,_that.senderDeviceId,_that.recipientUserId,_that.recipientDeviceId,_that.ciphertext,_that.type,_that.createdAt,_that.expiresAt,_that.isDelivered,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageRecord implements MessageRecord {
  const _MessageRecord({this.id, this.messageId, this.conversationId, this.senderUserId, this.senderDeviceId, this.recipientUserId, this.recipientDeviceId, this.ciphertext, this.type, this.createdAt, this.expiresAt, this.isDelivered = false, this.version = 1});
  factory _MessageRecord.fromJson(Map<String, dynamic> json) => _$MessageRecordFromJson(json);

@override final  String? id;
@override final  String? messageId;
@override final  String? conversationId;
@override final  String? senderUserId;
@override final  String? senderDeviceId;
@override final  String? recipientUserId;
@override final  String? recipientDeviceId;
@override final  String? ciphertext;
@override final  String? type;
@override final  DateTime? createdAt;
@override final  DateTime? expiresAt;
@override@JsonKey() final  bool isDelivered;
@override@JsonKey() final  int version;

/// Create a copy of MessageRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageRecordCopyWith<_MessageRecord> get copyWith => __$MessageRecordCopyWithImpl<_MessageRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderUserId, senderUserId) || other.senderUserId == senderUserId)&&(identical(other.senderDeviceId, senderDeviceId) || other.senderDeviceId == senderDeviceId)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.recipientDeviceId, recipientDeviceId) || other.recipientDeviceId == recipientDeviceId)&&(identical(other.ciphertext, ciphertext) || other.ciphertext == ciphertext)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isDelivered, isDelivered) || other.isDelivered == isDelivered)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,messageId,conversationId,senderUserId,senderDeviceId,recipientUserId,recipientDeviceId,ciphertext,type,createdAt,expiresAt,isDelivered,version);
}

@override
String toString() {
    return 'MessageRecord(id: $id, messageId: $messageId, conversationId: $conversationId, senderUserId: $senderUserId, senderDeviceId: $senderDeviceId, recipientUserId: $recipientUserId, recipientDeviceId: $recipientDeviceId, ciphertext: $ciphertext, type: $type, createdAt: $createdAt, expiresAt: $expiresAt, isDelivered: $isDelivered, version: $version)';
}


}

/// @nodoc
abstract mixin class _$MessageRecordCopyWith<$Res> implements $MessageRecordCopyWith<$Res> {
  factory _$MessageRecordCopyWith(_MessageRecord value, $Res Function(_MessageRecord) _then) = __$MessageRecordCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? messageId, String? conversationId, String? senderUserId, String? senderDeviceId, String? recipientUserId, String? recipientDeviceId, String? ciphertext, String? type, DateTime? createdAt, DateTime? expiresAt, bool isDelivered, int version
});




}
/// @nodoc
class __$MessageRecordCopyWithImpl<$Res>
    implements _$MessageRecordCopyWith<$Res> {
  __$MessageRecordCopyWithImpl(this._self, this._then);

  final _MessageRecord _self;
  final $Res Function(_MessageRecord) _then;

/// Create a copy of MessageRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? messageId = freezed,Object? conversationId = freezed,Object? senderUserId = freezed,Object? senderDeviceId = freezed,Object? recipientUserId = freezed,Object? recipientDeviceId = freezed,Object? ciphertext = freezed,Object? type = freezed,Object? createdAt = freezed,Object? expiresAt = freezed,Object? isDelivered = null,Object? version = null,}) {
  return _then(_MessageRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,senderUserId: freezed == senderUserId ? _self.senderUserId : senderUserId // ignore: cast_nullable_to_non_nullable
as String?,senderDeviceId: freezed == senderDeviceId ? _self.senderDeviceId : senderDeviceId // ignore: cast_nullable_to_non_nullable
as String?,recipientUserId: freezed == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String?,recipientDeviceId: freezed == recipientDeviceId ? _self.recipientDeviceId : recipientDeviceId // ignore: cast_nullable_to_non_nullable
as String?,ciphertext: freezed == ciphertext ? _self.ciphertext : ciphertext // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDelivered: null == isDelivered ? _self.isDelivered : isDelivered // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
