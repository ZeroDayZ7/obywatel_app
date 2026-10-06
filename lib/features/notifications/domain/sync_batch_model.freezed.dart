// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_batch_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncEventDto {

 String get id;@JsonKey(name: 'event_type') String get eventType; Map<String, dynamic> get payload;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of SyncEventDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncEventDtoCopyWith<SyncEventDto> get copyWith => _$SyncEventDtoCopyWithImpl<SyncEventDto>(this as SyncEventDto, _$identity);

  /// Serializes this SyncEventDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncEventDto&&(identical(other.id, id) || other.id == id)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,eventType,const DeepCollectionEquality().hash(payload),createdAt);

@override
String toString() {
  return 'SyncEventDto(id: $id, eventType: $eventType, payload: $payload, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SyncEventDtoCopyWith<$Res>  {
  factory $SyncEventDtoCopyWith(SyncEventDto value, $Res Function(SyncEventDto) _then) = _$SyncEventDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'event_type') String eventType, Map<String, dynamic> payload,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$SyncEventDtoCopyWithImpl<$Res>
    implements $SyncEventDtoCopyWith<$Res> {
  _$SyncEventDtoCopyWithImpl(this._self, this._then);

  final SyncEventDto _self;
  final $Res Function(SyncEventDto) _then;

/// Create a copy of SyncEventDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventType = null,Object? payload = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncEventDto].
extension SyncEventDtoPatterns on SyncEventDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncEventDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncEventDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncEventDto value)  $default,){
final _that = this;
switch (_that) {
case _SyncEventDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncEventDto value)?  $default,){
final _that = this;
switch (_that) {
case _SyncEventDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'event_type')  String eventType,  Map<String, dynamic> payload, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncEventDto() when $default != null:
return $default(_that.id,_that.eventType,_that.payload,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'event_type')  String eventType,  Map<String, dynamic> payload, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _SyncEventDto():
return $default(_that.id,_that.eventType,_that.payload,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'event_type')  String eventType,  Map<String, dynamic> payload, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SyncEventDto() when $default != null:
return $default(_that.id,_that.eventType,_that.payload,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncEventDto implements SyncEventDto {
  const _SyncEventDto({required this.id, @JsonKey(name: 'event_type') required this.eventType, required final  Map<String, dynamic> payload, @JsonKey(name: 'created_at') required this.createdAt}): _payload = payload;
  factory _SyncEventDto.fromJson(Map<String, dynamic> json) => _$SyncEventDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'event_type') final  String eventType;
 final  Map<String, dynamic> _payload;
@override Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of SyncEventDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncEventDtoCopyWith<_SyncEventDto> get copyWith => __$SyncEventDtoCopyWithImpl<_SyncEventDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncEventDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncEventDto&&(identical(other.id, id) || other.id == id)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,eventType,const DeepCollectionEquality().hash(_payload),createdAt);

@override
String toString() {
  return 'SyncEventDto(id: $id, eventType: $eventType, payload: $payload, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SyncEventDtoCopyWith<$Res> implements $SyncEventDtoCopyWith<$Res> {
  factory _$SyncEventDtoCopyWith(_SyncEventDto value, $Res Function(_SyncEventDto) _then) = __$SyncEventDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'event_type') String eventType, Map<String, dynamic> payload,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$SyncEventDtoCopyWithImpl<$Res>
    implements _$SyncEventDtoCopyWith<$Res> {
  __$SyncEventDtoCopyWithImpl(this._self, this._then);

  final _SyncEventDto _self;
  final $Res Function(_SyncEventDto) _then;

/// Create a copy of SyncEventDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventType = null,Object? payload = null,Object? createdAt = null,}) {
  return _then(_SyncEventDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SyncBatchRequestDto {

 List<SyncEventDto> get events;
/// Create a copy of SyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncBatchRequestDtoCopyWith<SyncBatchRequestDto> get copyWith => _$SyncBatchRequestDtoCopyWithImpl<SyncBatchRequestDto>(this as SyncBatchRequestDto, _$identity);

  /// Serializes this SyncBatchRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncBatchRequestDto&&const DeepCollectionEquality().equals(other.events, events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(events));

@override
String toString() {
  return 'SyncBatchRequestDto(events: $events)';
}


}

/// @nodoc
abstract mixin class $SyncBatchRequestDtoCopyWith<$Res>  {
  factory $SyncBatchRequestDtoCopyWith(SyncBatchRequestDto value, $Res Function(SyncBatchRequestDto) _then) = _$SyncBatchRequestDtoCopyWithImpl;
@useResult
$Res call({
 List<SyncEventDto> events
});




}
/// @nodoc
class _$SyncBatchRequestDtoCopyWithImpl<$Res>
    implements $SyncBatchRequestDtoCopyWith<$Res> {
  _$SyncBatchRequestDtoCopyWithImpl(this._self, this._then);

  final SyncBatchRequestDto _self;
  final $Res Function(SyncBatchRequestDto) _then;

/// Create a copy of SyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? events = null,}) {
  return _then(_self.copyWith(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<SyncEventDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncBatchRequestDto].
extension SyncBatchRequestDtoPatterns on SyncBatchRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncBatchRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncBatchRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncBatchRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _SyncBatchRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncBatchRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _SyncBatchRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SyncEventDto> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncBatchRequestDto() when $default != null:
return $default(_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SyncEventDto> events)  $default,) {final _that = this;
switch (_that) {
case _SyncBatchRequestDto():
return $default(_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SyncEventDto> events)?  $default,) {final _that = this;
switch (_that) {
case _SyncBatchRequestDto() when $default != null:
return $default(_that.events);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncBatchRequestDto implements SyncBatchRequestDto {
  const _SyncBatchRequestDto({required final  List<SyncEventDto> events}): _events = events;
  factory _SyncBatchRequestDto.fromJson(Map<String, dynamic> json) => _$SyncBatchRequestDtoFromJson(json);

 final  List<SyncEventDto> _events;
@override List<SyncEventDto> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of SyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncBatchRequestDtoCopyWith<_SyncBatchRequestDto> get copyWith => __$SyncBatchRequestDtoCopyWithImpl<_SyncBatchRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncBatchRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncBatchRequestDto&&const DeepCollectionEquality().equals(other._events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_events));

@override
String toString() {
  return 'SyncBatchRequestDto(events: $events)';
}


}

/// @nodoc
abstract mixin class _$SyncBatchRequestDtoCopyWith<$Res> implements $SyncBatchRequestDtoCopyWith<$Res> {
  factory _$SyncBatchRequestDtoCopyWith(_SyncBatchRequestDto value, $Res Function(_SyncBatchRequestDto) _then) = __$SyncBatchRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 List<SyncEventDto> events
});




}
/// @nodoc
class __$SyncBatchRequestDtoCopyWithImpl<$Res>
    implements _$SyncBatchRequestDtoCopyWith<$Res> {
  __$SyncBatchRequestDtoCopyWithImpl(this._self, this._then);

  final _SyncBatchRequestDto _self;
  final $Res Function(_SyncBatchRequestDto) _then;

/// Create a copy of SyncBatchRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? events = null,}) {
  return _then(_SyncBatchRequestDto(
events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<SyncEventDto>,
  ));
}


}


/// @nodoc
mixin _$SyncBatchResponseDto {

@JsonKey(name: 'processed_event_ids') List<String> get processedEventIds;@JsonKey(name: 'failed_event_ids') List<String>? get failedEventIds;
/// Create a copy of SyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncBatchResponseDtoCopyWith<SyncBatchResponseDto> get copyWith => _$SyncBatchResponseDtoCopyWithImpl<SyncBatchResponseDto>(this as SyncBatchResponseDto, _$identity);

  /// Serializes this SyncBatchResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncBatchResponseDto&&const DeepCollectionEquality().equals(other.processedEventIds, processedEventIds)&&const DeepCollectionEquality().equals(other.failedEventIds, failedEventIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(processedEventIds),const DeepCollectionEquality().hash(failedEventIds));

@override
String toString() {
  return 'SyncBatchResponseDto(processedEventIds: $processedEventIds, failedEventIds: $failedEventIds)';
}


}

/// @nodoc
abstract mixin class $SyncBatchResponseDtoCopyWith<$Res>  {
  factory $SyncBatchResponseDtoCopyWith(SyncBatchResponseDto value, $Res Function(SyncBatchResponseDto) _then) = _$SyncBatchResponseDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'processed_event_ids') List<String> processedEventIds,@JsonKey(name: 'failed_event_ids') List<String>? failedEventIds
});




}
/// @nodoc
class _$SyncBatchResponseDtoCopyWithImpl<$Res>
    implements $SyncBatchResponseDtoCopyWith<$Res> {
  _$SyncBatchResponseDtoCopyWithImpl(this._self, this._then);

  final SyncBatchResponseDto _self;
  final $Res Function(SyncBatchResponseDto) _then;

/// Create a copy of SyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? processedEventIds = null,Object? failedEventIds = freezed,}) {
  return _then(_self.copyWith(
processedEventIds: null == processedEventIds ? _self.processedEventIds : processedEventIds // ignore: cast_nullable_to_non_nullable
as List<String>,failedEventIds: freezed == failedEventIds ? _self.failedEventIds : failedEventIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncBatchResponseDto].
extension SyncBatchResponseDtoPatterns on SyncBatchResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncBatchResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncBatchResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncBatchResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SyncBatchResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncBatchResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SyncBatchResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'processed_event_ids')  List<String> processedEventIds, @JsonKey(name: 'failed_event_ids')  List<String>? failedEventIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncBatchResponseDto() when $default != null:
return $default(_that.processedEventIds,_that.failedEventIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'processed_event_ids')  List<String> processedEventIds, @JsonKey(name: 'failed_event_ids')  List<String>? failedEventIds)  $default,) {final _that = this;
switch (_that) {
case _SyncBatchResponseDto():
return $default(_that.processedEventIds,_that.failedEventIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'processed_event_ids')  List<String> processedEventIds, @JsonKey(name: 'failed_event_ids')  List<String>? failedEventIds)?  $default,) {final _that = this;
switch (_that) {
case _SyncBatchResponseDto() when $default != null:
return $default(_that.processedEventIds,_that.failedEventIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncBatchResponseDto implements SyncBatchResponseDto {
  const _SyncBatchResponseDto({@JsonKey(name: 'processed_event_ids') required final  List<String> processedEventIds, @JsonKey(name: 'failed_event_ids') final  List<String>? failedEventIds}): _processedEventIds = processedEventIds,_failedEventIds = failedEventIds;
  factory _SyncBatchResponseDto.fromJson(Map<String, dynamic> json) => _$SyncBatchResponseDtoFromJson(json);

 final  List<String> _processedEventIds;
@override@JsonKey(name: 'processed_event_ids') List<String> get processedEventIds {
  if (_processedEventIds is EqualUnmodifiableListView) return _processedEventIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_processedEventIds);
}

 final  List<String>? _failedEventIds;
@override@JsonKey(name: 'failed_event_ids') List<String>? get failedEventIds {
  final value = _failedEventIds;
  if (value == null) return null;
  if (_failedEventIds is EqualUnmodifiableListView) return _failedEventIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncBatchResponseDtoCopyWith<_SyncBatchResponseDto> get copyWith => __$SyncBatchResponseDtoCopyWithImpl<_SyncBatchResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncBatchResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncBatchResponseDto&&const DeepCollectionEquality().equals(other._processedEventIds, _processedEventIds)&&const DeepCollectionEquality().equals(other._failedEventIds, _failedEventIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_processedEventIds),const DeepCollectionEquality().hash(_failedEventIds));

@override
String toString() {
  return 'SyncBatchResponseDto(processedEventIds: $processedEventIds, failedEventIds: $failedEventIds)';
}


}

/// @nodoc
abstract mixin class _$SyncBatchResponseDtoCopyWith<$Res> implements $SyncBatchResponseDtoCopyWith<$Res> {
  factory _$SyncBatchResponseDtoCopyWith(_SyncBatchResponseDto value, $Res Function(_SyncBatchResponseDto) _then) = __$SyncBatchResponseDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'processed_event_ids') List<String> processedEventIds,@JsonKey(name: 'failed_event_ids') List<String>? failedEventIds
});




}
/// @nodoc
class __$SyncBatchResponseDtoCopyWithImpl<$Res>
    implements _$SyncBatchResponseDtoCopyWith<$Res> {
  __$SyncBatchResponseDtoCopyWithImpl(this._self, this._then);

  final _SyncBatchResponseDto _self;
  final $Res Function(_SyncBatchResponseDto) _then;

/// Create a copy of SyncBatchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? processedEventIds = null,Object? failedEventIds = freezed,}) {
  return _then(_SyncBatchResponseDto(
processedEventIds: null == processedEventIds ? _self._processedEventIds : processedEventIds // ignore: cast_nullable_to_non_nullable
as List<String>,failedEventIds: freezed == failedEventIds ? _self._failedEventIds : failedEventIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
