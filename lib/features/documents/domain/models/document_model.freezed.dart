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
mixin _$DocumentField {

 String get label; String get value; String get iconName;
/// Create a copy of DocumentField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentFieldCopyWith<DocumentField> get copyWith => _$DocumentFieldCopyWithImpl<DocumentField>(this as DocumentField, _$identity);

  /// Serializes this DocumentField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentField&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.iconName, iconName) || other.iconName == iconName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,value,iconName);

@override
String toString() {
  return 'DocumentField(label: $label, value: $value, iconName: $iconName)';
}


}

/// @nodoc
abstract mixin class $DocumentFieldCopyWith<$Res>  {
  factory $DocumentFieldCopyWith(DocumentField value, $Res Function(DocumentField) _then) = _$DocumentFieldCopyWithImpl;
@useResult
$Res call({
 String label, String value, String iconName
});




}
/// @nodoc
class _$DocumentFieldCopyWithImpl<$Res>
    implements $DocumentFieldCopyWith<$Res> {
  _$DocumentFieldCopyWithImpl(this._self, this._then);

  final DocumentField _self;
  final $Res Function(DocumentField) _then;

/// Create a copy of DocumentField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,Object? iconName = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentField].
extension DocumentFieldPatterns on DocumentField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentField value)  $default,){
final _that = this;
switch (_that) {
case _DocumentField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentField value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String value,  String iconName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentField() when $default != null:
return $default(_that.label,_that.value,_that.iconName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String value,  String iconName)  $default,) {final _that = this;
switch (_that) {
case _DocumentField():
return $default(_that.label,_that.value,_that.iconName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String value,  String iconName)?  $default,) {final _that = this;
switch (_that) {
case _DocumentField() when $default != null:
return $default(_that.label,_that.value,_that.iconName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentField implements DocumentField {
  const _DocumentField({required this.label, required this.value, required this.iconName});
  factory _DocumentField.fromJson(Map<String, dynamic> json) => _$DocumentFieldFromJson(json);

@override final  String label;
@override final  String value;
@override final  String iconName;

/// Create a copy of DocumentField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentFieldCopyWith<_DocumentField> get copyWith => __$DocumentFieldCopyWithImpl<_DocumentField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentFieldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentField&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.iconName, iconName) || other.iconName == iconName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,value,iconName);

@override
String toString() {
  return 'DocumentField(label: $label, value: $value, iconName: $iconName)';
}


}

/// @nodoc
abstract mixin class _$DocumentFieldCopyWith<$Res> implements $DocumentFieldCopyWith<$Res> {
  factory _$DocumentFieldCopyWith(_DocumentField value, $Res Function(_DocumentField) _then) = __$DocumentFieldCopyWithImpl;
@override @useResult
$Res call({
 String label, String value, String iconName
});




}
/// @nodoc
class __$DocumentFieldCopyWithImpl<$Res>
    implements _$DocumentFieldCopyWith<$Res> {
  __$DocumentFieldCopyWithImpl(this._self, this._then);

  final _DocumentField _self;
  final $Res Function(_DocumentField) _then;

/// Create a copy of DocumentField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? iconName = null,}) {
  return _then(_DocumentField(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DocumentModel {

 String get id; String get type; String get status; Map<String, dynamic> get metadata; List<DocumentField> get fields; String? get profileId; String? get issuedAt; String? get expiresAt; String? get qrData;
/// Create a copy of DocumentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentModelCopyWith<DocumentModel> get copyWith => _$DocumentModelCopyWithImpl<DocumentModel>(this as DocumentModel, _$identity);

  /// Serializes this DocumentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.qrData, qrData) || other.qrData == qrData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,status,const DeepCollectionEquality().hash(metadata),const DeepCollectionEquality().hash(fields),profileId,issuedAt,expiresAt,qrData);

@override
String toString() {
  return 'DocumentModel(id: $id, type: $type, status: $status, metadata: $metadata, fields: $fields, profileId: $profileId, issuedAt: $issuedAt, expiresAt: $expiresAt, qrData: $qrData)';
}


}

/// @nodoc
abstract mixin class $DocumentModelCopyWith<$Res>  {
  factory $DocumentModelCopyWith(DocumentModel value, $Res Function(DocumentModel) _then) = _$DocumentModelCopyWithImpl;
@useResult
$Res call({
 String id, String type, String status, Map<String, dynamic> metadata, List<DocumentField> fields, String? profileId, String? issuedAt, String? expiresAt, String? qrData
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? status = null,Object? metadata = null,Object? fields = null,Object? profileId = freezed,Object? issuedAt = freezed,Object? expiresAt = freezed,Object? qrData = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<DocumentField>,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,qrData: freezed == qrData ? _self.qrData : qrData // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String status,  Map<String, dynamic> metadata,  List<DocumentField> fields,  String? profileId,  String? issuedAt,  String? expiresAt,  String? qrData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentModel() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.metadata,_that.fields,_that.profileId,_that.issuedAt,_that.expiresAt,_that.qrData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String status,  Map<String, dynamic> metadata,  List<DocumentField> fields,  String? profileId,  String? issuedAt,  String? expiresAt,  String? qrData)  $default,) {final _that = this;
switch (_that) {
case _DocumentModel():
return $default(_that.id,_that.type,_that.status,_that.metadata,_that.fields,_that.profileId,_that.issuedAt,_that.expiresAt,_that.qrData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String status,  Map<String, dynamic> metadata,  List<DocumentField> fields,  String? profileId,  String? issuedAt,  String? expiresAt,  String? qrData)?  $default,) {final _that = this;
switch (_that) {
case _DocumentModel() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.metadata,_that.fields,_that.profileId,_that.issuedAt,_that.expiresAt,_that.qrData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentModel extends DocumentModel {
  const _DocumentModel({required this.id, required this.type, required this.status, required final  Map<String, dynamic> metadata, required final  List<DocumentField> fields, this.profileId, this.issuedAt, this.expiresAt, this.qrData}): _metadata = metadata,_fields = fields,super._();
  factory _DocumentModel.fromJson(Map<String, dynamic> json) => _$DocumentModelFromJson(json);

@override final  String id;
@override final  String type;
@override final  String status;
 final  Map<String, dynamic> _metadata;
@override Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

 final  List<DocumentField> _fields;
@override List<DocumentField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

@override final  String? profileId;
@override final  String? issuedAt;
@override final  String? expiresAt;
@override final  String? qrData;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&const DeepCollectionEquality().equals(other._fields, _fields)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.qrData, qrData) || other.qrData == qrData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,status,const DeepCollectionEquality().hash(_metadata),const DeepCollectionEquality().hash(_fields),profileId,issuedAt,expiresAt,qrData);

@override
String toString() {
  return 'DocumentModel(id: $id, type: $type, status: $status, metadata: $metadata, fields: $fields, profileId: $profileId, issuedAt: $issuedAt, expiresAt: $expiresAt, qrData: $qrData)';
}


}

/// @nodoc
abstract mixin class _$DocumentModelCopyWith<$Res> implements $DocumentModelCopyWith<$Res> {
  factory _$DocumentModelCopyWith(_DocumentModel value, $Res Function(_DocumentModel) _then) = __$DocumentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String status, Map<String, dynamic> metadata, List<DocumentField> fields, String? profileId, String? issuedAt, String? expiresAt, String? qrData
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? status = null,Object? metadata = null,Object? fields = null,Object? profileId = freezed,Object? issuedAt = freezed,Object? expiresAt = freezed,Object? qrData = freezed,}) {
  return _then(_DocumentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<DocumentField>,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,qrData: freezed == qrData ? _self.qrData : qrData // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
