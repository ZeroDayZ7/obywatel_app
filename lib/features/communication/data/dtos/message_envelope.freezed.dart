// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_envelope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageEnvelope {

 String? get messageId; String? get conversationId; String? get senderUserId; String? get senderDeviceId; String? get recipientUserId; String? get recipientDeviceId; String? get ciphertext; int? get type; String? get nonce; DateTime? get createdAt; DateTime? get expiresAt; int get version;
/// Create a copy of MessageEnvelope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageEnvelopeCopyWith<MessageEnvelope> get copyWith => _$MessageEnvelopeCopyWithImpl<MessageEnvelope>(this as MessageEnvelope, _$identity);

  /// Serializes this MessageEnvelope to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MessageEnvelope;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageEnvelope&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.senderUserId, _this.senderUserId) || other.senderUserId == _this.senderUserId)&&(identical(other.senderDeviceId, _this.senderDeviceId) || other.senderDeviceId == _this.senderDeviceId)&&(identical(other.recipientUserId, _this.recipientUserId) || other.recipientUserId == _this.recipientUserId)&&(identical(other.recipientDeviceId, _this.recipientDeviceId) || other.recipientDeviceId == _this.recipientDeviceId)&&(identical(other.ciphertext, _this.ciphertext) || other.ciphertext == _this.ciphertext)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.nonce, _this.nonce) || other.nonce == _this.nonce)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.version, _this.version) || other.version == _this.version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MessageEnvelope;
  return Object.hash(runtimeType,_this.messageId,_this.conversationId,_this.senderUserId,_this.senderDeviceId,_this.recipientUserId,_this.recipientDeviceId,_this.ciphertext,_this.type,_this.nonce,_this.createdAt,_this.expiresAt,_this.version);
}

@override
String toString() {
  final _this = this as MessageEnvelope;
  return 'MessageEnvelope(messageId: ${_this.messageId}, conversationId: ${_this.conversationId}, senderUserId: ${_this.senderUserId}, senderDeviceId: ${_this.senderDeviceId}, recipientUserId: ${_this.recipientUserId}, recipientDeviceId: ${_this.recipientDeviceId}, ciphertext: ${_this.ciphertext}, type: ${_this.type}, nonce: ${_this.nonce}, createdAt: ${_this.createdAt}, expiresAt: ${_this.expiresAt}, version: ${_this.version})';
}


}

/// @nodoc
abstract mixin class $MessageEnvelopeCopyWith<$Res>  {
  factory $MessageEnvelopeCopyWith(MessageEnvelope value, $Res Function(MessageEnvelope) _then) = _$MessageEnvelopeCopyWithImpl;
@useResult
$Res call({
 String? messageId, String? conversationId, String? senderUserId, String? senderDeviceId, String? recipientUserId, String? recipientDeviceId, String? ciphertext, int? type, String? nonce, DateTime? createdAt, DateTime? expiresAt, int version
});




}
/// @nodoc
class _$MessageEnvelopeCopyWithImpl<$Res>
    implements $MessageEnvelopeCopyWith<$Res> {
  _$MessageEnvelopeCopyWithImpl(this._self, this._then);

  final MessageEnvelope _self;
  final $Res Function(MessageEnvelope) _then;

/// Create a copy of MessageEnvelope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = freezed,Object? conversationId = freezed,Object? senderUserId = freezed,Object? senderDeviceId = freezed,Object? recipientUserId = freezed,Object? recipientDeviceId = freezed,Object? ciphertext = freezed,Object? type = freezed,Object? nonce = freezed,Object? createdAt = freezed,Object? expiresAt = freezed,Object? version = null,}) {
  return _then(MessageEnvelope(
messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,senderUserId: freezed == senderUserId ? _self.senderUserId : senderUserId // ignore: cast_nullable_to_non_nullable
as String?,senderDeviceId: freezed == senderDeviceId ? _self.senderDeviceId : senderDeviceId // ignore: cast_nullable_to_non_nullable
as String?,recipientUserId: freezed == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String?,recipientDeviceId: freezed == recipientDeviceId ? _self.recipientDeviceId : recipientDeviceId // ignore: cast_nullable_to_non_nullable
as String?,ciphertext: freezed == ciphertext ? _self.ciphertext : ciphertext // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int?,nonce: freezed == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageEnvelope].
extension MessageEnvelopePatterns on MessageEnvelope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageEnvelope value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageEnvelope() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageEnvelope value)  $default,){
final _that = this;
switch (_that) {
case _MessageEnvelope():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageEnvelope value)?  $default,){
final _that = this;
switch (_that) {
case _MessageEnvelope() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? messageId,  String? conversationId,  String? senderUserId,  String? senderDeviceId,  String? recipientUserId,  String? recipientDeviceId,  String? ciphertext,  int? type,  String? nonce,  DateTime? createdAt,  DateTime? expiresAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageEnvelope() when $default != null:
return $default(_that.messageId,_that.conversationId,_that.senderUserId,_that.senderDeviceId,_that.recipientUserId,_that.recipientDeviceId,_that.ciphertext,_that.type,_that.nonce,_that.createdAt,_that.expiresAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? messageId,  String? conversationId,  String? senderUserId,  String? senderDeviceId,  String? recipientUserId,  String? recipientDeviceId,  String? ciphertext,  int? type,  String? nonce,  DateTime? createdAt,  DateTime? expiresAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _MessageEnvelope():
return $default(_that.messageId,_that.conversationId,_that.senderUserId,_that.senderDeviceId,_that.recipientUserId,_that.recipientDeviceId,_that.ciphertext,_that.type,_that.nonce,_that.createdAt,_that.expiresAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? messageId,  String? conversationId,  String? senderUserId,  String? senderDeviceId,  String? recipientUserId,  String? recipientDeviceId,  String? ciphertext,  int? type,  String? nonce,  DateTime? createdAt,  DateTime? expiresAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _MessageEnvelope() when $default != null:
return $default(_that.messageId,_that.conversationId,_that.senderUserId,_that.senderDeviceId,_that.recipientUserId,_that.recipientDeviceId,_that.ciphertext,_that.type,_that.nonce,_that.createdAt,_that.expiresAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageEnvelope implements MessageEnvelope {
  const _MessageEnvelope({this.messageId, this.conversationId, this.senderUserId, this.senderDeviceId, this.recipientUserId, this.recipientDeviceId, this.ciphertext, this.type, this.nonce, this.createdAt, this.expiresAt, this.version = 1});
  factory _MessageEnvelope.fromJson(Map<String, dynamic> json) => _$MessageEnvelopeFromJson(json);

@override final  String? messageId;
@override final  String? conversationId;
@override final  String? senderUserId;
@override final  String? senderDeviceId;
@override final  String? recipientUserId;
@override final  String? recipientDeviceId;
@override final  String? ciphertext;
@override final  int? type;
@override final  String? nonce;
@override final  DateTime? createdAt;
@override final  DateTime? expiresAt;
@override@JsonKey() final  int version;

/// Create a copy of MessageEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageEnvelopeCopyWith<_MessageEnvelope> get copyWith => __$MessageEnvelopeCopyWithImpl<_MessageEnvelope>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageEnvelopeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageEnvelope&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderUserId, senderUserId) || other.senderUserId == senderUserId)&&(identical(other.senderDeviceId, senderDeviceId) || other.senderDeviceId == senderDeviceId)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.recipientDeviceId, recipientDeviceId) || other.recipientDeviceId == recipientDeviceId)&&(identical(other.ciphertext, ciphertext) || other.ciphertext == ciphertext)&&(identical(other.type, type) || other.type == type)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageId,conversationId,senderUserId,senderDeviceId,recipientUserId,recipientDeviceId,ciphertext,type,nonce,createdAt,expiresAt,version);
}

@override
String toString() {
    return 'MessageEnvelope(messageId: $messageId, conversationId: $conversationId, senderUserId: $senderUserId, senderDeviceId: $senderDeviceId, recipientUserId: $recipientUserId, recipientDeviceId: $recipientDeviceId, ciphertext: $ciphertext, type: $type, nonce: $nonce, createdAt: $createdAt, expiresAt: $expiresAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$MessageEnvelopeCopyWith<$Res> implements $MessageEnvelopeCopyWith<$Res> {
  factory _$MessageEnvelopeCopyWith(_MessageEnvelope value, $Res Function(_MessageEnvelope) _then) = __$MessageEnvelopeCopyWithImpl;
@override @useResult
$Res call({
 String? messageId, String? conversationId, String? senderUserId, String? senderDeviceId, String? recipientUserId, String? recipientDeviceId, String? ciphertext, int? type, String? nonce, DateTime? createdAt, DateTime? expiresAt, int version
});




}
/// @nodoc
class __$MessageEnvelopeCopyWithImpl<$Res>
    implements _$MessageEnvelopeCopyWith<$Res> {
  __$MessageEnvelopeCopyWithImpl(this._self, this._then);

  final _MessageEnvelope _self;
  final $Res Function(_MessageEnvelope) _then;

/// Create a copy of MessageEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = freezed,Object? conversationId = freezed,Object? senderUserId = freezed,Object? senderDeviceId = freezed,Object? recipientUserId = freezed,Object? recipientDeviceId = freezed,Object? ciphertext = freezed,Object? type = freezed,Object? nonce = freezed,Object? createdAt = freezed,Object? expiresAt = freezed,Object? version = null,}) {
  return _then(_MessageEnvelope(
messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,senderUserId: freezed == senderUserId ? _self.senderUserId : senderUserId // ignore: cast_nullable_to_non_nullable
as String?,senderDeviceId: freezed == senderDeviceId ? _self.senderDeviceId : senderDeviceId // ignore: cast_nullable_to_non_nullable
as String?,recipientUserId: freezed == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String?,recipientDeviceId: freezed == recipientDeviceId ? _self.recipientDeviceId : recipientDeviceId // ignore: cast_nullable_to_non_nullable
as String?,ciphertext: freezed == ciphertext ? _self.ciphertext : ciphertext // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int?,nonce: freezed == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
