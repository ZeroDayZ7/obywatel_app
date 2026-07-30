// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationDto {

 String get id;@JsonKey(name: 'participant_ids') List<String> get participantIds;@JsonKey(name: 'last_message') MessageDto? get lastMessage;@JsonKey(name: 'unread_count') int get unreadCount;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationDtoCopyWith<ConversationDto> get copyWith => _$ConversationDtoCopyWithImpl<ConversationDto>(this as ConversationDto, _$identity);

  /// Serializes this ConversationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationDto&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.participantIds, participantIds)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(participantIds),lastMessage,unreadCount,updatedAt);

@override
String toString() {
  return 'ConversationDto(id: $id, participantIds: $participantIds, lastMessage: $lastMessage, unreadCount: $unreadCount, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ConversationDtoCopyWith<$Res>  {
  factory $ConversationDtoCopyWith(ConversationDto value, $Res Function(ConversationDto) _then) = _$ConversationDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'participant_ids') List<String> participantIds,@JsonKey(name: 'last_message') MessageDto? lastMessage,@JsonKey(name: 'unread_count') int unreadCount,@JsonKey(name: 'updated_at') DateTime updatedAt
});


$MessageDtoCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class _$ConversationDtoCopyWithImpl<$Res>
    implements $ConversationDtoCopyWith<$Res> {
  _$ConversationDtoCopyWithImpl(this._self, this._then);

  final ConversationDto _self;
  final $Res Function(ConversationDto) _then;

/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? participantIds = null,Object? lastMessage = freezed,Object? unreadCount = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as MessageDto?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageDtoCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $MessageDtoCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConversationDto].
extension ConversationDtoPatterns on ConversationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationDto value)  $default,){
final _that = this;
switch (_that) {
case _ConversationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationDto value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'participant_ids')  List<String> participantIds, @JsonKey(name: 'last_message')  MessageDto? lastMessage, @JsonKey(name: 'unread_count')  int unreadCount, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationDto() when $default != null:
return $default(_that.id,_that.participantIds,_that.lastMessage,_that.unreadCount,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'participant_ids')  List<String> participantIds, @JsonKey(name: 'last_message')  MessageDto? lastMessage, @JsonKey(name: 'unread_count')  int unreadCount, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ConversationDto():
return $default(_that.id,_that.participantIds,_that.lastMessage,_that.unreadCount,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'participant_ids')  List<String> participantIds, @JsonKey(name: 'last_message')  MessageDto? lastMessage, @JsonKey(name: 'unread_count')  int unreadCount, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ConversationDto() when $default != null:
return $default(_that.id,_that.participantIds,_that.lastMessage,_that.unreadCount,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationDto implements ConversationDto {
  const _ConversationDto({required this.id, @JsonKey(name: 'participant_ids') required final  List<String> participantIds, @JsonKey(name: 'last_message') this.lastMessage, @JsonKey(name: 'unread_count') this.unreadCount = 0, @JsonKey(name: 'updated_at') required this.updatedAt}): _participantIds = participantIds;
  factory _ConversationDto.fromJson(Map<String, dynamic> json) => _$ConversationDtoFromJson(json);

@override final  String id;
 final  List<String> _participantIds;
@override@JsonKey(name: 'participant_ids') List<String> get participantIds {
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantIds);
}

@override@JsonKey(name: 'last_message') final  MessageDto? lastMessage;
@override@JsonKey(name: 'unread_count') final  int unreadCount;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationDtoCopyWith<_ConversationDto> get copyWith => __$ConversationDtoCopyWithImpl<_ConversationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationDto&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._participantIds, _participantIds)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_participantIds),lastMessage,unreadCount,updatedAt);

@override
String toString() {
  return 'ConversationDto(id: $id, participantIds: $participantIds, lastMessage: $lastMessage, unreadCount: $unreadCount, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ConversationDtoCopyWith<$Res> implements $ConversationDtoCopyWith<$Res> {
  factory _$ConversationDtoCopyWith(_ConversationDto value, $Res Function(_ConversationDto) _then) = __$ConversationDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'participant_ids') List<String> participantIds,@JsonKey(name: 'last_message') MessageDto? lastMessage,@JsonKey(name: 'unread_count') int unreadCount,@JsonKey(name: 'updated_at') DateTime updatedAt
});


@override $MessageDtoCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class __$ConversationDtoCopyWithImpl<$Res>
    implements _$ConversationDtoCopyWith<$Res> {
  __$ConversationDtoCopyWithImpl(this._self, this._then);

  final _ConversationDto _self;
  final $Res Function(_ConversationDto) _then;

/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? participantIds = null,Object? lastMessage = freezed,Object? unreadCount = null,Object? updatedAt = null,}) {
  return _then(_ConversationDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as MessageDto?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageDtoCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $MessageDtoCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}

// dart format on
