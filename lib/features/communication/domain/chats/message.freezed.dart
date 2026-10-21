// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Message {

 String get id; String get conversationId; String get senderId; String get content; bool get isMine; DateTime get createdAt; String get status; bool get isEncrypted; String get encryptedPayload; String? get attachmentId;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Message;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.senderId, _this.senderId) || other.senderId == _this.senderId)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.isMine, _this.isMine) || other.isMine == _this.isMine)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.isEncrypted, _this.isEncrypted) || other.isEncrypted == _this.isEncrypted)&&(identical(other.encryptedPayload, _this.encryptedPayload) || other.encryptedPayload == _this.encryptedPayload)&&(identical(other.attachmentId, _this.attachmentId) || other.attachmentId == _this.attachmentId));
}


@override
int get hashCode {
  final _this = this as Message;
  return Object.hash(runtimeType,_this.id,_this.conversationId,_this.senderId,_this.content,_this.isMine,_this.createdAt,_this.status,_this.isEncrypted,_this.encryptedPayload,_this.attachmentId);
}

@override
String toString() {
  final _this = this as Message;
  return 'Message(id: ${_this.id}, conversationId: ${_this.conversationId}, senderId: ${_this.senderId}, content: ${_this.content}, isMine: ${_this.isMine}, createdAt: ${_this.createdAt}, status: ${_this.status}, isEncrypted: ${_this.isEncrypted}, encryptedPayload: ${_this.encryptedPayload}, attachmentId: ${_this.attachmentId})';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String senderId, String content, bool isMine, DateTime createdAt, String status, bool isEncrypted, String encryptedPayload, String? attachmentId
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? content = null,Object? isMine = null,Object? createdAt = null,Object? status = null,Object? isEncrypted = null,Object? encryptedPayload = null,Object? attachmentId = freezed,}) {
  return _then(Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isEncrypted: null == isEncrypted ? _self.isEncrypted : isEncrypted // ignore: cast_nullable_to_non_nullable
as bool,encryptedPayload: null == encryptedPayload ? _self.encryptedPayload : encryptedPayload // ignore: cast_nullable_to_non_nullable
as String,attachmentId: freezed == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String content,  bool isMine,  DateTime createdAt,  String status,  bool isEncrypted,  String encryptedPayload,  String? attachmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.content,_that.isMine,_that.createdAt,_that.status,_that.isEncrypted,_that.encryptedPayload,_that.attachmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String content,  bool isMine,  DateTime createdAt,  String status,  bool isEncrypted,  String encryptedPayload,  String? attachmentId)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.conversationId,_that.senderId,_that.content,_that.isMine,_that.createdAt,_that.status,_that.isEncrypted,_that.encryptedPayload,_that.attachmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String senderId,  String content,  bool isMine,  DateTime createdAt,  String status,  bool isEncrypted,  String encryptedPayload,  String? attachmentId)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.content,_that.isMine,_that.createdAt,_that.status,_that.isEncrypted,_that.encryptedPayload,_that.attachmentId);case _:
  return null;

}
}

}

/// @nodoc


class _Message implements Message {
  const _Message({required this.id, required this.conversationId, required this.senderId, required this.content, required this.isMine, required this.createdAt, this.status = 'pending', this.isEncrypted = true, this.encryptedPayload = '', this.attachmentId});
  

@override final  String id;
@override final  String conversationId;
@override final  String senderId;
@override final  String content;
@override final  bool isMine;
@override final  DateTime createdAt;
@override@JsonKey() final  String status;
@override@JsonKey() final  bool isEncrypted;
@override@JsonKey() final  String encryptedPayload;
@override final  String? attachmentId;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.isEncrypted, isEncrypted) || other.isEncrypted == isEncrypted)&&(identical(other.encryptedPayload, encryptedPayload) || other.encryptedPayload == encryptedPayload)&&(identical(other.attachmentId, attachmentId) || other.attachmentId == attachmentId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,conversationId,senderId,content,isMine,createdAt,status,isEncrypted,encryptedPayload,attachmentId);
}

@override
String toString() {
    return 'Message(id: $id, conversationId: $conversationId, senderId: $senderId, content: $content, isMine: $isMine, createdAt: $createdAt, status: $status, isEncrypted: $isEncrypted, encryptedPayload: $encryptedPayload, attachmentId: $attachmentId)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String senderId, String content, bool isMine, DateTime createdAt, String status, bool isEncrypted, String encryptedPayload, String? attachmentId
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? content = null,Object? isMine = null,Object? createdAt = null,Object? status = null,Object? isEncrypted = null,Object? encryptedPayload = null,Object? attachmentId = freezed,}) {
  return _then(_Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isEncrypted: null == isEncrypted ? _self.isEncrypted : isEncrypted // ignore: cast_nullable_to_non_nullable
as bool,encryptedPayload: null == encryptedPayload ? _self.encryptedPayload : encryptedPayload // ignore: cast_nullable_to_non_nullable
as String,attachmentId: freezed == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
