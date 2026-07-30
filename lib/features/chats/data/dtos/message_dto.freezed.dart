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

 String get id;@JsonKey(name: 'conversation_id') String get conversationId;@JsonKey(name: 'sender_id') String get senderId;@JsonKey(name: 'encrypted_payload') String get encryptedPayload; String get nonce;@JsonKey(name: 'sequence_number') int get sequenceNumber;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageDtoCopyWith<MessageDto> get copyWith => _$MessageDtoCopyWithImpl<MessageDto>(this as MessageDto, _$identity);

  /// Serializes this MessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.encryptedPayload, encryptedPayload) || other.encryptedPayload == encryptedPayload)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.sequenceNumber, sequenceNumber) || other.sequenceNumber == sequenceNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,encryptedPayload,nonce,sequenceNumber,createdAt);

@override
String toString() {
  return 'MessageDto(id: $id, conversationId: $conversationId, senderId: $senderId, encryptedPayload: $encryptedPayload, nonce: $nonce, sequenceNumber: $sequenceNumber, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MessageDtoCopyWith<$Res>  {
  factory $MessageDtoCopyWith(MessageDto value, $Res Function(MessageDto) _then) = _$MessageDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'conversation_id') String conversationId,@JsonKey(name: 'sender_id') String senderId,@JsonKey(name: 'encrypted_payload') String encryptedPayload, String nonce,@JsonKey(name: 'sequence_number') int sequenceNumber,@JsonKey(name: 'created_at') DateTime createdAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? encryptedPayload = null,Object? nonce = null,Object? sequenceNumber = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,encryptedPayload: null == encryptedPayload ? _self.encryptedPayload : encryptedPayload // ignore: cast_nullable_to_non_nullable
as String,nonce: null == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String,sequenceNumber: null == sequenceNumber ? _self.sequenceNumber : sequenceNumber // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'sender_id')  String senderId, @JsonKey(name: 'encrypted_payload')  String encryptedPayload,  String nonce, @JsonKey(name: 'sequence_number')  int sequenceNumber, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.encryptedPayload,_that.nonce,_that.sequenceNumber,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'sender_id')  String senderId, @JsonKey(name: 'encrypted_payload')  String encryptedPayload,  String nonce, @JsonKey(name: 'sequence_number')  int sequenceNumber, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _MessageDto():
return $default(_that.id,_that.conversationId,_that.senderId,_that.encryptedPayload,_that.nonce,_that.sequenceNumber,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'sender_id')  String senderId, @JsonKey(name: 'encrypted_payload')  String encryptedPayload,  String nonce, @JsonKey(name: 'sequence_number')  int sequenceNumber, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.encryptedPayload,_that.nonce,_that.sequenceNumber,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageDto implements MessageDto {
  const _MessageDto({required this.id, @JsonKey(name: 'conversation_id') required this.conversationId, @JsonKey(name: 'sender_id') required this.senderId, @JsonKey(name: 'encrypted_payload') required this.encryptedPayload, required this.nonce, @JsonKey(name: 'sequence_number') required this.sequenceNumber, @JsonKey(name: 'created_at') required this.createdAt});
  factory _MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'conversation_id') final  String conversationId;
@override@JsonKey(name: 'sender_id') final  String senderId;
@override@JsonKey(name: 'encrypted_payload') final  String encryptedPayload;
@override final  String nonce;
@override@JsonKey(name: 'sequence_number') final  int sequenceNumber;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.encryptedPayload, encryptedPayload) || other.encryptedPayload == encryptedPayload)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.sequenceNumber, sequenceNumber) || other.sequenceNumber == sequenceNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,encryptedPayload,nonce,sequenceNumber,createdAt);

@override
String toString() {
  return 'MessageDto(id: $id, conversationId: $conversationId, senderId: $senderId, encryptedPayload: $encryptedPayload, nonce: $nonce, sequenceNumber: $sequenceNumber, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MessageDtoCopyWith<$Res> implements $MessageDtoCopyWith<$Res> {
  factory _$MessageDtoCopyWith(_MessageDto value, $Res Function(_MessageDto) _then) = __$MessageDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'conversation_id') String conversationId,@JsonKey(name: 'sender_id') String senderId,@JsonKey(name: 'encrypted_payload') String encryptedPayload, String nonce,@JsonKey(name: 'sequence_number') int sequenceNumber,@JsonKey(name: 'created_at') DateTime createdAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? encryptedPayload = null,Object? nonce = null,Object? sequenceNumber = null,Object? createdAt = null,}) {
  return _then(_MessageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,encryptedPayload: null == encryptedPayload ? _self.encryptedPayload : encryptedPayload // ignore: cast_nullable_to_non_nullable
as String,nonce: null == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String,sequenceNumber: null == sequenceNumber ? _self.sequenceNumber : sequenceNumber // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
