// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConversationMember {

 String get id; String get conversationId; String get userId; String get role; int get lastReadSequence;
/// Create a copy of ConversationMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationMemberCopyWith<ConversationMember> get copyWith => _$ConversationMemberCopyWithImpl<ConversationMember>(this as ConversationMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationMember&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.lastReadSequence, lastReadSequence) || other.lastReadSequence == lastReadSequence));
}


@override
int get hashCode => Object.hash(runtimeType,id,conversationId,userId,role,lastReadSequence);

@override
String toString() {
  return 'ConversationMember(id: $id, conversationId: $conversationId, userId: $userId, role: $role, lastReadSequence: $lastReadSequence)';
}


}

/// @nodoc
abstract mixin class $ConversationMemberCopyWith<$Res>  {
  factory $ConversationMemberCopyWith(ConversationMember value, $Res Function(ConversationMember) _then) = _$ConversationMemberCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String userId, String role, int lastReadSequence
});




}
/// @nodoc
class _$ConversationMemberCopyWithImpl<$Res>
    implements $ConversationMemberCopyWith<$Res> {
  _$ConversationMemberCopyWithImpl(this._self, this._then);

  final ConversationMember _self;
  final $Res Function(ConversationMember) _then;

/// Create a copy of ConversationMember
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


/// Adds pattern-matching-related methods to [ConversationMember].
extension ConversationMemberPatterns on ConversationMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationMember value)  $default,){
final _that = this;
switch (_that) {
case _ConversationMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationMember value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String userId,  String role,  int lastReadSequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationMember() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String userId,  String role,  int lastReadSequence)  $default,) {final _that = this;
switch (_that) {
case _ConversationMember():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String userId,  String role,  int lastReadSequence)?  $default,) {final _that = this;
switch (_that) {
case _ConversationMember() when $default != null:
return $default(_that.id,_that.conversationId,_that.userId,_that.role,_that.lastReadSequence);case _:
  return null;

}
}

}

/// @nodoc


class _ConversationMember implements ConversationMember {
  const _ConversationMember({required this.id, required this.conversationId, required this.userId, required this.role, required this.lastReadSequence});
  

@override final  String id;
@override final  String conversationId;
@override final  String userId;
@override final  String role;
@override final  int lastReadSequence;

/// Create a copy of ConversationMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationMemberCopyWith<_ConversationMember> get copyWith => __$ConversationMemberCopyWithImpl<_ConversationMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationMember&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.lastReadSequence, lastReadSequence) || other.lastReadSequence == lastReadSequence));
}


@override
int get hashCode => Object.hash(runtimeType,id,conversationId,userId,role,lastReadSequence);

@override
String toString() {
  return 'ConversationMember(id: $id, conversationId: $conversationId, userId: $userId, role: $role, lastReadSequence: $lastReadSequence)';
}


}

/// @nodoc
abstract mixin class _$ConversationMemberCopyWith<$Res> implements $ConversationMemberCopyWith<$Res> {
  factory _$ConversationMemberCopyWith(_ConversationMember value, $Res Function(_ConversationMember) _then) = __$ConversationMemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String userId, String role, int lastReadSequence
});




}
/// @nodoc
class __$ConversationMemberCopyWithImpl<$Res>
    implements _$ConversationMemberCopyWith<$Res> {
  __$ConversationMemberCopyWithImpl(this._self, this._then);

  final _ConversationMember _self;
  final $Res Function(_ConversationMember) _then;

/// Create a copy of ConversationMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? userId = null,Object? role = null,Object? lastReadSequence = null,}) {
  return _then(_ConversationMember(
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
mixin _$Conversation {

 String get id; String get type; String? get title; int get lastSequence; List<ConversationMember> get members; List<Message?>? get messages; DateTime? get updatedAt;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.lastSequence, lastSequence) || other.lastSequence == lastSequence)&&const DeepCollectionEquality().equals(other.members, members)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,title,lastSequence,const DeepCollectionEquality().hash(members),const DeepCollectionEquality().hash(messages),updatedAt);

@override
String toString() {
  return 'Conversation(id: $id, type: $type, title: $title, lastSequence: $lastSequence, members: $members, messages: $messages, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
 String id, String type, String? title, int lastSequence, List<ConversationMember> members, List<Message?>? messages, DateTime? updatedAt
});




}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = freezed,Object? lastSequence = null,Object? members = null,Object? messages = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,lastSequence: null == lastSequence ? _self.lastSequence : lastSequence // ignore: cast_nullable_to_non_nullable
as int,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<ConversationMember>,messages: freezed == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<Message?>?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String? title,  int lastSequence,  List<ConversationMember> members,  List<Message?>? messages,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.lastSequence,_that.members,_that.messages,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String? title,  int lastSequence,  List<ConversationMember> members,  List<Message?>? messages,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.id,_that.type,_that.title,_that.lastSequence,_that.members,_that.messages,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String? title,  int lastSequence,  List<ConversationMember> members,  List<Message?>? messages,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.lastSequence,_that.members,_that.messages,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Conversation implements Conversation {
  const _Conversation({required this.id, required this.type, this.title, this.lastSequence = 0, final  List<ConversationMember> members = const [], final  List<Message?>? messages, this.updatedAt}): _members = members,_messages = messages;
  

@override final  String id;
@override final  String type;
@override final  String? title;
@override@JsonKey() final  int lastSequence;
 final  List<ConversationMember> _members;
@override@JsonKey() List<ConversationMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<Message?>? _messages;
@override List<Message?>? get messages {
  final value = _messages;
  if (value == null) return null;
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? updatedAt;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.lastSequence, lastSequence) || other.lastSequence == lastSequence)&&const DeepCollectionEquality().equals(other._members, _members)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,title,lastSequence,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_messages),updatedAt);

@override
String toString() {
  return 'Conversation(id: $id, type: $type, title: $title, lastSequence: $lastSequence, members: $members, messages: $messages, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String? title, int lastSequence, List<ConversationMember> members, List<Message?>? messages, DateTime? updatedAt
});




}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = freezed,Object? lastSequence = null,Object? members = null,Object? messages = freezed,Object? updatedAt = freezed,}) {
  return _then(_Conversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,lastSequence: null == lastSequence ? _self.lastSequence : lastSequence // ignore: cast_nullable_to_non_nullable
as int,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<ConversationMember>,messages: freezed == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<Message?>?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
