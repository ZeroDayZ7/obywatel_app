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
mixin _$ConversationMemberDto {

@JsonKey(name: 'ID') String get id;@JsonKey(name: 'ConversationID') String get conversationId;@JsonKey(name: 'UserID') String get userId;@JsonKey(name: 'Role') String get role;@JsonKey(name: 'LastReadSequence') int get lastReadSequence;
/// Create a copy of ConversationMemberDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationMemberDtoCopyWith<ConversationMemberDto> get copyWith => _$ConversationMemberDtoCopyWithImpl<ConversationMemberDto>(this as ConversationMemberDto, _$identity);

  /// Serializes this ConversationMemberDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationMemberDto&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.lastReadSequence, lastReadSequence) || other.lastReadSequence == lastReadSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,userId,role,lastReadSequence);

@override
String toString() {
  return 'ConversationMemberDto(id: $id, conversationId: $conversationId, userId: $userId, role: $role, lastReadSequence: $lastReadSequence)';
}


}

/// @nodoc
abstract mixin class $ConversationMemberDtoCopyWith<$Res>  {
  factory $ConversationMemberDtoCopyWith(ConversationMemberDto value, $Res Function(ConversationMemberDto) _then) = _$ConversationMemberDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ID') String id,@JsonKey(name: 'ConversationID') String conversationId,@JsonKey(name: 'UserID') String userId,@JsonKey(name: 'Role') String role,@JsonKey(name: 'LastReadSequence') int lastReadSequence
});




}
/// @nodoc
class _$ConversationMemberDtoCopyWithImpl<$Res>
    implements $ConversationMemberDtoCopyWith<$Res> {
  _$ConversationMemberDtoCopyWithImpl(this._self, this._then);

  final ConversationMemberDto _self;
  final $Res Function(ConversationMemberDto) _then;

/// Create a copy of ConversationMemberDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? userId = null,Object? role = null,Object? lastReadSequence = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,lastReadSequence: null == lastReadSequence ? _self.lastReadSequence : lastReadSequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationMemberDto].
extension ConversationMemberDtoPatterns on ConversationMemberDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationMemberDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationMemberDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationMemberDto value)  $default,){
final _that = this;
switch (_that) {
case _ConversationMemberDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationMemberDto value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationMemberDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'ConversationID')  String conversationId, @JsonKey(name: 'UserID')  String userId, @JsonKey(name: 'Role')  String role, @JsonKey(name: 'LastReadSequence')  int lastReadSequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationMemberDto() when $default != null:
return $default(_that.id,_that.conversationId,_that.userId,_that.role,_that.lastReadSequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'ConversationID')  String conversationId, @JsonKey(name: 'UserID')  String userId, @JsonKey(name: 'Role')  String role, @JsonKey(name: 'LastReadSequence')  int lastReadSequence)  $default,) {final _that = this;
switch (_that) {
case _ConversationMemberDto():
return $default(_that.id,_that.conversationId,_that.userId,_that.role,_that.lastReadSequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'ConversationID')  String conversationId, @JsonKey(name: 'UserID')  String userId, @JsonKey(name: 'Role')  String role, @JsonKey(name: 'LastReadSequence')  int lastReadSequence)?  $default,) {final _that = this;
switch (_that) {
case _ConversationMemberDto() when $default != null:
return $default(_that.id,_that.conversationId,_that.userId,_that.role,_that.lastReadSequence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationMemberDto implements ConversationMemberDto {
  const _ConversationMemberDto({@JsonKey(name: 'ID') required this.id, @JsonKey(name: 'ConversationID') required this.conversationId, @JsonKey(name: 'UserID') required this.userId, @JsonKey(name: 'Role') required this.role, @JsonKey(name: 'LastReadSequence') this.lastReadSequence = 0});
  factory _ConversationMemberDto.fromJson(Map<String, dynamic> json) => _$ConversationMemberDtoFromJson(json);

@override@JsonKey(name: 'ID') final  String id;
@override@JsonKey(name: 'ConversationID') final  String conversationId;
@override@JsonKey(name: 'UserID') final  String userId;
@override@JsonKey(name: 'Role') final  String role;
@override@JsonKey(name: 'LastReadSequence') final  int lastReadSequence;

/// Create a copy of ConversationMemberDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationMemberDtoCopyWith<_ConversationMemberDto> get copyWith => __$ConversationMemberDtoCopyWithImpl<_ConversationMemberDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationMemberDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationMemberDto&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.lastReadSequence, lastReadSequence) || other.lastReadSequence == lastReadSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,userId,role,lastReadSequence);

@override
String toString() {
  return 'ConversationMemberDto(id: $id, conversationId: $conversationId, userId: $userId, role: $role, lastReadSequence: $lastReadSequence)';
}


}

/// @nodoc
abstract mixin class _$ConversationMemberDtoCopyWith<$Res> implements $ConversationMemberDtoCopyWith<$Res> {
  factory _$ConversationMemberDtoCopyWith(_ConversationMemberDto value, $Res Function(_ConversationMemberDto) _then) = __$ConversationMemberDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ID') String id,@JsonKey(name: 'ConversationID') String conversationId,@JsonKey(name: 'UserID') String userId,@JsonKey(name: 'Role') String role,@JsonKey(name: 'LastReadSequence') int lastReadSequence
});




}
/// @nodoc
class __$ConversationMemberDtoCopyWithImpl<$Res>
    implements _$ConversationMemberDtoCopyWith<$Res> {
  __$ConversationMemberDtoCopyWithImpl(this._self, this._then);

  final _ConversationMemberDto _self;
  final $Res Function(_ConversationMemberDto) _then;

/// Create a copy of ConversationMemberDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? userId = null,Object? role = null,Object? lastReadSequence = null,}) {
  return _then(_ConversationMemberDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,lastReadSequence: null == lastReadSequence ? _self.lastReadSequence : lastReadSequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ConversationDto {

@JsonKey(name: 'ID') String get id;@JsonKey(name: 'Type') String get type;@JsonKey(name: 'Title') String? get title;@JsonKey(name: 'LastSequence') int get lastSequence;@JsonKey(name: 'Members') List<ConversationMemberDto> get members;@JsonKey(name: 'Messages') List<MessageDto?>? get messages;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationDtoCopyWith<ConversationDto> get copyWith => _$ConversationDtoCopyWithImpl<ConversationDto>(this as ConversationDto, _$identity);

  /// Serializes this ConversationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.lastSequence, lastSequence) || other.lastSequence == lastSequence)&&const DeepCollectionEquality().equals(other.members, members)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,lastSequence,const DeepCollectionEquality().hash(members),const DeepCollectionEquality().hash(messages),createdAt,updatedAt);

@override
String toString() {
  return 'ConversationDto(id: $id, type: $type, title: $title, lastSequence: $lastSequence, members: $members, messages: $messages, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ConversationDtoCopyWith<$Res>  {
  factory $ConversationDtoCopyWith(ConversationDto value, $Res Function(ConversationDto) _then) = _$ConversationDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ID') String id,@JsonKey(name: 'Type') String type,@JsonKey(name: 'Title') String? title,@JsonKey(name: 'LastSequence') int lastSequence,@JsonKey(name: 'Members') List<ConversationMemberDto> members,@JsonKey(name: 'Messages') List<MessageDto?>? messages,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ConversationDtoCopyWithImpl<$Res>
    implements $ConversationDtoCopyWith<$Res> {
  _$ConversationDtoCopyWithImpl(this._self, this._then);

  final ConversationDto _self;
  final $Res Function(ConversationDto) _then;

/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = freezed,Object? lastSequence = null,Object? members = null,Object? messages = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,lastSequence: null == lastSequence ? _self.lastSequence : lastSequence // ignore: cast_nullable_to_non_nullable
as int,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<ConversationMemberDto>,messages: freezed == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageDto?>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'Type')  String type, @JsonKey(name: 'Title')  String? title, @JsonKey(name: 'LastSequence')  int lastSequence, @JsonKey(name: 'Members')  List<ConversationMemberDto> members, @JsonKey(name: 'Messages')  List<MessageDto?>? messages, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationDto() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.lastSequence,_that.members,_that.messages,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'Type')  String type, @JsonKey(name: 'Title')  String? title, @JsonKey(name: 'LastSequence')  int lastSequence, @JsonKey(name: 'Members')  List<ConversationMemberDto> members, @JsonKey(name: 'Messages')  List<MessageDto?>? messages, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ConversationDto():
return $default(_that.id,_that.type,_that.title,_that.lastSequence,_that.members,_that.messages,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'Type')  String type, @JsonKey(name: 'Title')  String? title, @JsonKey(name: 'LastSequence')  int lastSequence, @JsonKey(name: 'Members')  List<ConversationMemberDto> members, @JsonKey(name: 'Messages')  List<MessageDto?>? messages, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ConversationDto() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.lastSequence,_that.members,_that.messages,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationDto implements ConversationDto {
  const _ConversationDto({@JsonKey(name: 'ID') required this.id, @JsonKey(name: 'Type') required this.type, @JsonKey(name: 'Title') this.title, @JsonKey(name: 'LastSequence') this.lastSequence = 0, @JsonKey(name: 'Members') final  List<ConversationMemberDto> members = const [], @JsonKey(name: 'Messages') final  List<MessageDto?>? messages, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _members = members,_messages = messages;
  factory _ConversationDto.fromJson(Map<String, dynamic> json) => _$ConversationDtoFromJson(json);

@override@JsonKey(name: 'ID') final  String id;
@override@JsonKey(name: 'Type') final  String type;
@override@JsonKey(name: 'Title') final  String? title;
@override@JsonKey(name: 'LastSequence') final  int lastSequence;
 final  List<ConversationMemberDto> _members;
@override@JsonKey(name: 'Members') List<ConversationMemberDto> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<MessageDto?>? _messages;
@override@JsonKey(name: 'Messages') List<MessageDto?>? get messages {
  final value = _messages;
  if (value == null) return null;
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.lastSequence, lastSequence) || other.lastSequence == lastSequence)&&const DeepCollectionEquality().equals(other._members, _members)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,lastSequence,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_messages),createdAt,updatedAt);

@override
String toString() {
  return 'ConversationDto(id: $id, type: $type, title: $title, lastSequence: $lastSequence, members: $members, messages: $messages, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ConversationDtoCopyWith<$Res> implements $ConversationDtoCopyWith<$Res> {
  factory _$ConversationDtoCopyWith(_ConversationDto value, $Res Function(_ConversationDto) _then) = __$ConversationDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ID') String id,@JsonKey(name: 'Type') String type,@JsonKey(name: 'Title') String? title,@JsonKey(name: 'LastSequence') int lastSequence,@JsonKey(name: 'Members') List<ConversationMemberDto> members,@JsonKey(name: 'Messages') List<MessageDto?>? messages,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ConversationDtoCopyWithImpl<$Res>
    implements _$ConversationDtoCopyWith<$Res> {
  __$ConversationDtoCopyWithImpl(this._self, this._then);

  final _ConversationDto _self;
  final $Res Function(_ConversationDto) _then;

/// Create a copy of ConversationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = freezed,Object? lastSequence = null,Object? members = null,Object? messages = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ConversationDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,lastSequence: null == lastSequence ? _self.lastSequence : lastSequence // ignore: cast_nullable_to_non_nullable
as int,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<ConversationMemberDto>,messages: freezed == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageDto?>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
