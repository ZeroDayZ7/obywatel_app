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

 String get label; String get value; String get iconName; bool get isSensitive;
/// Create a copy of DocumentField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentFieldCopyWith<DocumentField> get copyWith => _$DocumentFieldCopyWithImpl<DocumentField>(this as DocumentField, _$identity);

  /// Serializes this DocumentField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentField&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,value,iconName,isSensitive);

@override
String toString() {
  return 'DocumentField(label: $label, value: $value, iconName: $iconName, isSensitive: $isSensitive)';
}


}

/// @nodoc
abstract mixin class $DocumentFieldCopyWith<$Res>  {
  factory $DocumentFieldCopyWith(DocumentField value, $Res Function(DocumentField) _then) = _$DocumentFieldCopyWithImpl;
@useResult
$Res call({
 String label, String value, String iconName, bool isSensitive
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
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,Object? iconName = null,Object? isSensitive = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,isSensitive: null == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String value,  String iconName,  bool isSensitive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentField() when $default != null:
return $default(_that.label,_that.value,_that.iconName,_that.isSensitive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String value,  String iconName,  bool isSensitive)  $default,) {final _that = this;
switch (_that) {
case _DocumentField():
return $default(_that.label,_that.value,_that.iconName,_that.isSensitive);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String value,  String iconName,  bool isSensitive)?  $default,) {final _that = this;
switch (_that) {
case _DocumentField() when $default != null:
return $default(_that.label,_that.value,_that.iconName,_that.isSensitive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentField extends DocumentField {
  const _DocumentField({required this.label, required this.value, required this.iconName, this.isSensitive = false}): super._();
  factory _DocumentField.fromJson(Map<String, dynamic> json) => _$DocumentFieldFromJson(json);

@override final  String label;
@override final  String value;
@override final  String iconName;
@override@JsonKey() final  bool isSensitive;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentField&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,value,iconName,isSensitive);

@override
String toString() {
  return 'DocumentField(label: $label, value: $value, iconName: $iconName, isSensitive: $isSensitive)';
}


}

/// @nodoc
abstract mixin class _$DocumentFieldCopyWith<$Res> implements $DocumentFieldCopyWith<$Res> {
  factory _$DocumentFieldCopyWith(_DocumentField value, $Res Function(_DocumentField) _then) = __$DocumentFieldCopyWithImpl;
@override @useResult
$Res call({
 String label, String value, String iconName, bool isSensitive
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
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? iconName = null,Object? isSensitive = null,}) {
  return _then(_DocumentField(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,isSensitive: null == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DocumentModel {

 String get id; String get title; String get iconName; String get colorHex; DocumentCategory get category; List<DocumentField> get fields; String? get qrData; String? get status; bool get isVerified; String? get subtitle; String? get expiryDate;
/// Create a copy of DocumentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentModelCopyWith<DocumentModel> get copyWith => _$DocumentModelCopyWithImpl<DocumentModel>(this as DocumentModel, _$identity);

  /// Serializes this DocumentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.qrData, qrData) || other.qrData == qrData)&&(identical(other.status, status) || other.status == status)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,iconName,colorHex,category,const DeepCollectionEquality().hash(fields),qrData,status,isVerified,subtitle,expiryDate);

@override
String toString() {
  return 'DocumentModel(id: $id, title: $title, iconName: $iconName, colorHex: $colorHex, category: $category, fields: $fields, qrData: $qrData, status: $status, isVerified: $isVerified, subtitle: $subtitle, expiryDate: $expiryDate)';
}


}

/// @nodoc
abstract mixin class $DocumentModelCopyWith<$Res>  {
  factory $DocumentModelCopyWith(DocumentModel value, $Res Function(DocumentModel) _then) = _$DocumentModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String iconName, String colorHex, DocumentCategory category, List<DocumentField> fields, String? qrData, String? status, bool isVerified, String? subtitle, String? expiryDate
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? iconName = null,Object? colorHex = null,Object? category = null,Object? fields = null,Object? qrData = freezed,Object? status = freezed,Object? isVerified = null,Object? subtitle = freezed,Object? expiryDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DocumentCategory,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<DocumentField>,qrData: freezed == qrData ? _self.qrData : qrData // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String iconName,  String colorHex,  DocumentCategory category,  List<DocumentField> fields,  String? qrData,  String? status,  bool isVerified,  String? subtitle,  String? expiryDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentModel() when $default != null:
return $default(_that.id,_that.title,_that.iconName,_that.colorHex,_that.category,_that.fields,_that.qrData,_that.status,_that.isVerified,_that.subtitle,_that.expiryDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String iconName,  String colorHex,  DocumentCategory category,  List<DocumentField> fields,  String? qrData,  String? status,  bool isVerified,  String? subtitle,  String? expiryDate)  $default,) {final _that = this;
switch (_that) {
case _DocumentModel():
return $default(_that.id,_that.title,_that.iconName,_that.colorHex,_that.category,_that.fields,_that.qrData,_that.status,_that.isVerified,_that.subtitle,_that.expiryDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String iconName,  String colorHex,  DocumentCategory category,  List<DocumentField> fields,  String? qrData,  String? status,  bool isVerified,  String? subtitle,  String? expiryDate)?  $default,) {final _that = this;
switch (_that) {
case _DocumentModel() when $default != null:
return $default(_that.id,_that.title,_that.iconName,_that.colorHex,_that.category,_that.fields,_that.qrData,_that.status,_that.isVerified,_that.subtitle,_that.expiryDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentModel extends DocumentModel {
  const _DocumentModel({required this.id, required this.title, required this.iconName, required this.colorHex, required this.category, required final  List<DocumentField> fields, this.qrData, this.status, this.isVerified = false, this.subtitle, this.expiryDate}): _fields = fields,super._();
  factory _DocumentModel.fromJson(Map<String, dynamic> json) => _$DocumentModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String iconName;
@override final  String colorHex;
@override final  DocumentCategory category;
 final  List<DocumentField> _fields;
@override List<DocumentField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

@override final  String? qrData;
@override final  String? status;
@override@JsonKey() final  bool isVerified;
@override final  String? subtitle;
@override final  String? expiryDate;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._fields, _fields)&&(identical(other.qrData, qrData) || other.qrData == qrData)&&(identical(other.status, status) || other.status == status)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,iconName,colorHex,category,const DeepCollectionEquality().hash(_fields),qrData,status,isVerified,subtitle,expiryDate);

@override
String toString() {
  return 'DocumentModel(id: $id, title: $title, iconName: $iconName, colorHex: $colorHex, category: $category, fields: $fields, qrData: $qrData, status: $status, isVerified: $isVerified, subtitle: $subtitle, expiryDate: $expiryDate)';
}


}

/// @nodoc
abstract mixin class _$DocumentModelCopyWith<$Res> implements $DocumentModelCopyWith<$Res> {
  factory _$DocumentModelCopyWith(_DocumentModel value, $Res Function(_DocumentModel) _then) = __$DocumentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String iconName, String colorHex, DocumentCategory category, List<DocumentField> fields, String? qrData, String? status, bool isVerified, String? subtitle, String? expiryDate
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? iconName = null,Object? colorHex = null,Object? category = null,Object? fields = null,Object? qrData = freezed,Object? status = freezed,Object? isVerified = null,Object? subtitle = freezed,Object? expiryDate = freezed,}) {
  return _then(_DocumentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DocumentCategory,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<DocumentField>,qrData: freezed == qrData ? _self.qrData : qrData // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
