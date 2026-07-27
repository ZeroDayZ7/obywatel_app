// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DocumentModel {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'profile_id') String? get profileId;@JsonKey(name: 'type') String get type;@JsonKey(name: 'status') String get status;@JsonKey(name: 'encrypted_meta') String get encryptedMeta;@JsonKey(name: 'issued_at') String? get issuedAt;@JsonKey(name: 'expires_at') String? get expiresAt;
/// Create a copy of DocumentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentModelCopyWith<DocumentModel> get copyWith => _$DocumentModelCopyWithImpl<DocumentModel>(this as DocumentModel, _$identity);

  /// Serializes this DocumentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.encryptedMeta, encryptedMeta) || other.encryptedMeta == encryptedMeta)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileId,type,status,encryptedMeta,issuedAt,expiresAt);

@override
String toString() {
  return 'DocumentModel(id: $id, profileId: $profileId, type: $type, status: $status, encryptedMeta: $encryptedMeta, issuedAt: $issuedAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $DocumentModelCopyWith<$Res>  {
  factory $DocumentModelCopyWith(DocumentModel value, $Res Function(DocumentModel) _then) = _$DocumentModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'profile_id') String? profileId,@JsonKey(name: 'type') String type,@JsonKey(name: 'status') String status,@JsonKey(name: 'encrypted_meta') String encryptedMeta,@JsonKey(name: 'issued_at') String? issuedAt,@JsonKey(name: 'expires_at') String? expiresAt
});




}
/// @nodoc
class _$DocumentModelCopyWithImpl<$Res>
    implements $DocumentModelCopyWith<$Res> {
  _$DocumentModelCopyWithImpl(this._self, this._then);

  final DocumentModel _self;
  final $Res Function(DocumentModel) _then;

/// Create a copy of DocumentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = freezed,Object? type = null,Object? status = null,Object? encryptedMeta = null,Object? issuedAt = freezed,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,encryptedMeta: null == encryptedMeta ? _self.encryptedMeta : encryptedMeta // ignore: cast_nullable_to_non_nullable
as String,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentModel].
extension DocumentModelPatterns on DocumentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentModel value)  $default,){
final _that = this;
switch (_that) {
case _DocumentModel():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentModel value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'profile_id')  String? profileId, @JsonKey(name: 'type')  String type, @JsonKey(name: 'status')  String status, @JsonKey(name: 'encrypted_meta')  String encryptedMeta, @JsonKey(name: 'issued_at')  String? issuedAt, @JsonKey(name: 'expires_at')  String? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentModel() when $default != null:
return $default(_that.id,_that.profileId,_that.type,_that.status,_that.encryptedMeta,_that.issuedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'profile_id')  String? profileId, @JsonKey(name: 'type')  String type, @JsonKey(name: 'status')  String status, @JsonKey(name: 'encrypted_meta')  String encryptedMeta, @JsonKey(name: 'issued_at')  String? issuedAt, @JsonKey(name: 'expires_at')  String? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _DocumentModel():
return $default(_that.id,_that.profileId,_that.type,_that.status,_that.encryptedMeta,_that.issuedAt,_that.expiresAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'profile_id')  String? profileId, @JsonKey(name: 'type')  String type, @JsonKey(name: 'status')  String status, @JsonKey(name: 'encrypted_meta')  String encryptedMeta, @JsonKey(name: 'issued_at')  String? issuedAt, @JsonKey(name: 'expires_at')  String? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _DocumentModel() when $default != null:
return $default(_that.id,_that.profileId,_that.type,_that.status,_that.encryptedMeta,_that.issuedAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentModel extends DocumentModel {
  const _DocumentModel({@JsonKey(name: 'id') this.id = '', @JsonKey(name: 'profile_id') this.profileId, @JsonKey(name: 'type') this.type = '', @JsonKey(name: 'status') this.status = '', @JsonKey(name: 'encrypted_meta') this.encryptedMeta = '', @JsonKey(name: 'issued_at') this.issuedAt, @JsonKey(name: 'expires_at') this.expiresAt}): super._();
  factory _DocumentModel.fromJson(Map<String, dynamic> json) => _$DocumentModelFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'profile_id') final  String? profileId;
@override@JsonKey(name: 'type') final  String type;
@override@JsonKey(name: 'status') final  String status;
@override@JsonKey(name: 'encrypted_meta') final  String encryptedMeta;
@override@JsonKey(name: 'issued_at') final  String? issuedAt;
@override@JsonKey(name: 'expires_at') final  String? expiresAt;

/// Create a copy of DocumentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentModelCopyWith<_DocumentModel> get copyWith => __$DocumentModelCopyWithImpl<_DocumentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.encryptedMeta, encryptedMeta) || other.encryptedMeta == encryptedMeta)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileId,type,status,encryptedMeta,issuedAt,expiresAt);

@override
String toString() {
  return 'DocumentModel(id: $id, profileId: $profileId, type: $type, status: $status, encryptedMeta: $encryptedMeta, issuedAt: $issuedAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$DocumentModelCopyWith<$Res> implements $DocumentModelCopyWith<$Res> {
  factory _$DocumentModelCopyWith(_DocumentModel value, $Res Function(_DocumentModel) _then) = __$DocumentModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'profile_id') String? profileId,@JsonKey(name: 'type') String type,@JsonKey(name: 'status') String status,@JsonKey(name: 'encrypted_meta') String encryptedMeta,@JsonKey(name: 'issued_at') String? issuedAt,@JsonKey(name: 'expires_at') String? expiresAt
});




}
/// @nodoc
class __$DocumentModelCopyWithImpl<$Res>
    implements _$DocumentModelCopyWith<$Res> {
  __$DocumentModelCopyWithImpl(this._self, this._then);

  final _DocumentModel _self;
  final $Res Function(_DocumentModel) _then;

/// Create a copy of DocumentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = freezed,Object? type = null,Object? status = null,Object? encryptedMeta = null,Object? issuedAt = freezed,Object? expiresAt = freezed,}) {
  return _then(_DocumentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,encryptedMeta: null == encryptedMeta ? _self.encryptedMeta : encryptedMeta // ignore: cast_nullable_to_non_nullable
as String,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
