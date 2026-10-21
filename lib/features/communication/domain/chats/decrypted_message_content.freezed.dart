// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'decrypted_message_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DecryptedMessageContent {

 String get text; String? get attachmentId; String? get attachmentKey; String? get fileName; String? get contentType; int? get size; String? get sha256;
/// Create a copy of DecryptedMessageContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DecryptedMessageContentCopyWith<DecryptedMessageContent> get copyWith => _$DecryptedMessageContentCopyWithImpl<DecryptedMessageContent>(this as DecryptedMessageContent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DecryptedMessageContent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DecryptedMessageContent&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.attachmentId, _this.attachmentId) || other.attachmentId == _this.attachmentId)&&(identical(other.attachmentKey, _this.attachmentKey) || other.attachmentKey == _this.attachmentKey)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.contentType, _this.contentType) || other.contentType == _this.contentType)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.sha256, _this.sha256) || other.sha256 == _this.sha256));
}


@override
int get hashCode {
  final _this = this as DecryptedMessageContent;
  return Object.hash(runtimeType,_this.text,_this.attachmentId,_this.attachmentKey,_this.fileName,_this.contentType,_this.size,_this.sha256);
}

@override
String toString() {
  final _this = this as DecryptedMessageContent;
  return 'DecryptedMessageContent(text: ${_this.text}, attachmentId: ${_this.attachmentId}, attachmentKey: ${_this.attachmentKey}, fileName: ${_this.fileName}, contentType: ${_this.contentType}, size: ${_this.size}, sha256: ${_this.sha256})';
}


}

/// @nodoc
abstract mixin class $DecryptedMessageContentCopyWith<$Res>  {
  factory $DecryptedMessageContentCopyWith(DecryptedMessageContent value, $Res Function(DecryptedMessageContent) _then) = _$DecryptedMessageContentCopyWithImpl;
@useResult
$Res call({
 String text, String? attachmentId, String? attachmentKey, String? fileName, String? contentType, int? size, String? sha256
});




}
/// @nodoc
class _$DecryptedMessageContentCopyWithImpl<$Res>
    implements $DecryptedMessageContentCopyWith<$Res> {
  _$DecryptedMessageContentCopyWithImpl(this._self, this._then);

  final DecryptedMessageContent _self;
  final $Res Function(DecryptedMessageContent) _then;

/// Create a copy of DecryptedMessageContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? attachmentId = freezed,Object? attachmentKey = freezed,Object? fileName = freezed,Object? contentType = freezed,Object? size = freezed,Object? sha256 = freezed,}) {
  return _then(DecryptedMessageContent(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,attachmentId: freezed == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String?,attachmentKey: freezed == attachmentKey ? _self.attachmentKey : attachmentKey // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,sha256: freezed == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DecryptedMessageContent].
extension DecryptedMessageContentPatterns on DecryptedMessageContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DecryptedMessageContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DecryptedMessageContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DecryptedMessageContent value)  $default,){
final _that = this;
switch (_that) {
case _DecryptedMessageContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DecryptedMessageContent value)?  $default,){
final _that = this;
switch (_that) {
case _DecryptedMessageContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String? attachmentId,  String? attachmentKey,  String? fileName,  String? contentType,  int? size,  String? sha256)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DecryptedMessageContent() when $default != null:
return $default(_that.text,_that.attachmentId,_that.attachmentKey,_that.fileName,_that.contentType,_that.size,_that.sha256);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String? attachmentId,  String? attachmentKey,  String? fileName,  String? contentType,  int? size,  String? sha256)  $default,) {final _that = this;
switch (_that) {
case _DecryptedMessageContent():
return $default(_that.text,_that.attachmentId,_that.attachmentKey,_that.fileName,_that.contentType,_that.size,_that.sha256);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String? attachmentId,  String? attachmentKey,  String? fileName,  String? contentType,  int? size,  String? sha256)?  $default,) {final _that = this;
switch (_that) {
case _DecryptedMessageContent() when $default != null:
return $default(_that.text,_that.attachmentId,_that.attachmentKey,_that.fileName,_that.contentType,_that.size,_that.sha256);case _:
  return null;

}
}

}

/// @nodoc


class _DecryptedMessageContent implements DecryptedMessageContent {
  const _DecryptedMessageContent({required this.text, this.attachmentId, this.attachmentKey, this.fileName, this.contentType, this.size, this.sha256});
  

@override final  String text;
@override final  String? attachmentId;
@override final  String? attachmentKey;
@override final  String? fileName;
@override final  String? contentType;
@override final  int? size;
@override final  String? sha256;

/// Create a copy of DecryptedMessageContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DecryptedMessageContentCopyWith<_DecryptedMessageContent> get copyWith => __$DecryptedMessageContentCopyWithImpl<_DecryptedMessageContent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DecryptedMessageContent&&(identical(other.text, text) || other.text == text)&&(identical(other.attachmentId, attachmentId) || other.attachmentId == attachmentId)&&(identical(other.attachmentKey, attachmentKey) || other.attachmentKey == attachmentKey)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.size, size) || other.size == size)&&(identical(other.sha256, sha256) || other.sha256 == sha256));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,attachmentId,attachmentKey,fileName,contentType,size,sha256);
}

@override
String toString() {
    return 'DecryptedMessageContent(text: $text, attachmentId: $attachmentId, attachmentKey: $attachmentKey, fileName: $fileName, contentType: $contentType, size: $size, sha256: $sha256)';
}


}

/// @nodoc
abstract mixin class _$DecryptedMessageContentCopyWith<$Res> implements $DecryptedMessageContentCopyWith<$Res> {
  factory _$DecryptedMessageContentCopyWith(_DecryptedMessageContent value, $Res Function(_DecryptedMessageContent) _then) = __$DecryptedMessageContentCopyWithImpl;
@override @useResult
$Res call({
 String text, String? attachmentId, String? attachmentKey, String? fileName, String? contentType, int? size, String? sha256
});




}
/// @nodoc
class __$DecryptedMessageContentCopyWithImpl<$Res>
    implements _$DecryptedMessageContentCopyWith<$Res> {
  __$DecryptedMessageContentCopyWithImpl(this._self, this._then);

  final _DecryptedMessageContent _self;
  final $Res Function(_DecryptedMessageContent) _then;

/// Create a copy of DecryptedMessageContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? attachmentId = freezed,Object? attachmentKey = freezed,Object? fileName = freezed,Object? contentType = freezed,Object? size = freezed,Object? sha256 = freezed,}) {
  return _then(_DecryptedMessageContent(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,attachmentId: freezed == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String?,attachmentKey: freezed == attachmentKey ? _self.attachmentKey : attachmentKey // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,sha256: freezed == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
