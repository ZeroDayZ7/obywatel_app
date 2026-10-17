// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_input_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PendingAttachment {

 String get fileName; Uint8List get bytes; String get mimeType; String? get filePath; bool get isImage;
/// Create a copy of PendingAttachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingAttachmentCopyWith<PendingAttachment> get copyWith => _$PendingAttachmentCopyWithImpl<PendingAttachment>(this as PendingAttachment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingAttachment&&(identical(other.fileName, fileName) || other.fileName == fileName)&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.isImage, isImage) || other.isImage == isImage));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,const DeepCollectionEquality().hash(bytes),mimeType,filePath,isImage);

@override
String toString() {
  return 'PendingAttachment(fileName: $fileName, bytes: $bytes, mimeType: $mimeType, filePath: $filePath, isImage: $isImage)';
}


}

/// @nodoc
abstract mixin class $PendingAttachmentCopyWith<$Res>  {
  factory $PendingAttachmentCopyWith(PendingAttachment value, $Res Function(PendingAttachment) _then) = _$PendingAttachmentCopyWithImpl;
@useResult
$Res call({
 String fileName, Uint8List bytes, String mimeType, String? filePath, bool isImage
});




}
/// @nodoc
class _$PendingAttachmentCopyWithImpl<$Res>
    implements $PendingAttachmentCopyWith<$Res> {
  _$PendingAttachmentCopyWithImpl(this._self, this._then);

  final PendingAttachment _self;
  final $Res Function(PendingAttachment) _then;

/// Create a copy of PendingAttachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? bytes = null,Object? mimeType = null,Object? filePath = freezed,Object? isImage = null,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,isImage: null == isImage ? _self.isImage : isImage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingAttachment].
extension PendingAttachmentPatterns on PendingAttachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingAttachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingAttachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingAttachment value)  $default,){
final _that = this;
switch (_that) {
case _PendingAttachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingAttachment value)?  $default,){
final _that = this;
switch (_that) {
case _PendingAttachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  Uint8List bytes,  String mimeType,  String? filePath,  bool isImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingAttachment() when $default != null:
return $default(_that.fileName,_that.bytes,_that.mimeType,_that.filePath,_that.isImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  Uint8List bytes,  String mimeType,  String? filePath,  bool isImage)  $default,) {final _that = this;
switch (_that) {
case _PendingAttachment():
return $default(_that.fileName,_that.bytes,_that.mimeType,_that.filePath,_that.isImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  Uint8List bytes,  String mimeType,  String? filePath,  bool isImage)?  $default,) {final _that = this;
switch (_that) {
case _PendingAttachment() when $default != null:
return $default(_that.fileName,_that.bytes,_that.mimeType,_that.filePath,_that.isImage);case _:
  return null;

}
}

}

/// @nodoc


class _PendingAttachment implements PendingAttachment {
  const _PendingAttachment({required this.fileName, required this.bytes, required this.mimeType, this.filePath, this.isImage = false});
  

@override final  String fileName;
@override final  Uint8List bytes;
@override final  String mimeType;
@override final  String? filePath;
@override@JsonKey() final  bool isImage;

/// Create a copy of PendingAttachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingAttachmentCopyWith<_PendingAttachment> get copyWith => __$PendingAttachmentCopyWithImpl<_PendingAttachment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingAttachment&&(identical(other.fileName, fileName) || other.fileName == fileName)&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.isImage, isImage) || other.isImage == isImage));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,const DeepCollectionEquality().hash(bytes),mimeType,filePath,isImage);

@override
String toString() {
  return 'PendingAttachment(fileName: $fileName, bytes: $bytes, mimeType: $mimeType, filePath: $filePath, isImage: $isImage)';
}


}

/// @nodoc
abstract mixin class _$PendingAttachmentCopyWith<$Res> implements $PendingAttachmentCopyWith<$Res> {
  factory _$PendingAttachmentCopyWith(_PendingAttachment value, $Res Function(_PendingAttachment) _then) = __$PendingAttachmentCopyWithImpl;
@override @useResult
$Res call({
 String fileName, Uint8List bytes, String mimeType, String? filePath, bool isImage
});




}
/// @nodoc
class __$PendingAttachmentCopyWithImpl<$Res>
    implements _$PendingAttachmentCopyWith<$Res> {
  __$PendingAttachmentCopyWithImpl(this._self, this._then);

  final _PendingAttachment _self;
  final $Res Function(_PendingAttachment) _then;

/// Create a copy of PendingAttachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? bytes = null,Object? mimeType = null,Object? filePath = freezed,Object? isImage = null,}) {
  return _then(_PendingAttachment(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,isImage: null == isImage ? _self.isImage : isImage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$MessageInputState {

 String get text; PendingAttachment? get attachment; bool get isSending; String? get errorMessage; String? get preparedAttachmentId; String? get uploadUrl; String? get uploadedAttachmentId;
/// Create a copy of MessageInputState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageInputStateCopyWith<MessageInputState> get copyWith => _$MessageInputStateCopyWithImpl<MessageInputState>(this as MessageInputState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageInputState&&(identical(other.text, text) || other.text == text)&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.preparedAttachmentId, preparedAttachmentId) || other.preparedAttachmentId == preparedAttachmentId)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.uploadedAttachmentId, uploadedAttachmentId) || other.uploadedAttachmentId == uploadedAttachmentId));
}


@override
int get hashCode => Object.hash(runtimeType,text,attachment,isSending,errorMessage,preparedAttachmentId,uploadUrl,uploadedAttachmentId);

@override
String toString() {
  return 'MessageInputState(text: $text, attachment: $attachment, isSending: $isSending, errorMessage: $errorMessage, preparedAttachmentId: $preparedAttachmentId, uploadUrl: $uploadUrl, uploadedAttachmentId: $uploadedAttachmentId)';
}


}

/// @nodoc
abstract mixin class $MessageInputStateCopyWith<$Res>  {
  factory $MessageInputStateCopyWith(MessageInputState value, $Res Function(MessageInputState) _then) = _$MessageInputStateCopyWithImpl;
@useResult
$Res call({
 String text, PendingAttachment? attachment, bool isSending, String? errorMessage, String? preparedAttachmentId, String? uploadUrl, String? uploadedAttachmentId
});


$PendingAttachmentCopyWith<$Res>? get attachment;

}
/// @nodoc
class _$MessageInputStateCopyWithImpl<$Res>
    implements $MessageInputStateCopyWith<$Res> {
  _$MessageInputStateCopyWithImpl(this._self, this._then);

  final MessageInputState _self;
  final $Res Function(MessageInputState) _then;

/// Create a copy of MessageInputState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? attachment = freezed,Object? isSending = null,Object? errorMessage = freezed,Object? preparedAttachmentId = freezed,Object? uploadUrl = freezed,Object? uploadedAttachmentId = freezed,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,attachment: freezed == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as PendingAttachment?,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,preparedAttachmentId: freezed == preparedAttachmentId ? _self.preparedAttachmentId : preparedAttachmentId // ignore: cast_nullable_to_non_nullable
as String?,uploadUrl: freezed == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String?,uploadedAttachmentId: freezed == uploadedAttachmentId ? _self.uploadedAttachmentId : uploadedAttachmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MessageInputState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PendingAttachmentCopyWith<$Res>? get attachment {
    if (_self.attachment == null) {
    return null;
  }

  return $PendingAttachmentCopyWith<$Res>(_self.attachment!, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}


/// Adds pattern-matching-related methods to [MessageInputState].
extension MessageInputStatePatterns on MessageInputState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageInputState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageInputState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageInputState value)  $default,){
final _that = this;
switch (_that) {
case _MessageInputState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageInputState value)?  $default,){
final _that = this;
switch (_that) {
case _MessageInputState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  PendingAttachment? attachment,  bool isSending,  String? errorMessage,  String? preparedAttachmentId,  String? uploadUrl,  String? uploadedAttachmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageInputState() when $default != null:
return $default(_that.text,_that.attachment,_that.isSending,_that.errorMessage,_that.preparedAttachmentId,_that.uploadUrl,_that.uploadedAttachmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  PendingAttachment? attachment,  bool isSending,  String? errorMessage,  String? preparedAttachmentId,  String? uploadUrl,  String? uploadedAttachmentId)  $default,) {final _that = this;
switch (_that) {
case _MessageInputState():
return $default(_that.text,_that.attachment,_that.isSending,_that.errorMessage,_that.preparedAttachmentId,_that.uploadUrl,_that.uploadedAttachmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  PendingAttachment? attachment,  bool isSending,  String? errorMessage,  String? preparedAttachmentId,  String? uploadUrl,  String? uploadedAttachmentId)?  $default,) {final _that = this;
switch (_that) {
case _MessageInputState() when $default != null:
return $default(_that.text,_that.attachment,_that.isSending,_that.errorMessage,_that.preparedAttachmentId,_that.uploadUrl,_that.uploadedAttachmentId);case _:
  return null;

}
}

}

/// @nodoc


class _MessageInputState extends MessageInputState {
  const _MessageInputState({this.text = '', this.attachment, this.isSending = false, this.errorMessage, this.preparedAttachmentId, this.uploadUrl, this.uploadedAttachmentId}): super._();
  

@override@JsonKey() final  String text;
@override final  PendingAttachment? attachment;
@override@JsonKey() final  bool isSending;
@override final  String? errorMessage;
@override final  String? preparedAttachmentId;
@override final  String? uploadUrl;
@override final  String? uploadedAttachmentId;

/// Create a copy of MessageInputState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageInputStateCopyWith<_MessageInputState> get copyWith => __$MessageInputStateCopyWithImpl<_MessageInputState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageInputState&&(identical(other.text, text) || other.text == text)&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.preparedAttachmentId, preparedAttachmentId) || other.preparedAttachmentId == preparedAttachmentId)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.uploadedAttachmentId, uploadedAttachmentId) || other.uploadedAttachmentId == uploadedAttachmentId));
}


@override
int get hashCode => Object.hash(runtimeType,text,attachment,isSending,errorMessage,preparedAttachmentId,uploadUrl,uploadedAttachmentId);

@override
String toString() {
  return 'MessageInputState(text: $text, attachment: $attachment, isSending: $isSending, errorMessage: $errorMessage, preparedAttachmentId: $preparedAttachmentId, uploadUrl: $uploadUrl, uploadedAttachmentId: $uploadedAttachmentId)';
}


}

/// @nodoc
abstract mixin class _$MessageInputStateCopyWith<$Res> implements $MessageInputStateCopyWith<$Res> {
  factory _$MessageInputStateCopyWith(_MessageInputState value, $Res Function(_MessageInputState) _then) = __$MessageInputStateCopyWithImpl;
@override @useResult
$Res call({
 String text, PendingAttachment? attachment, bool isSending, String? errorMessage, String? preparedAttachmentId, String? uploadUrl, String? uploadedAttachmentId
});


@override $PendingAttachmentCopyWith<$Res>? get attachment;

}
/// @nodoc
class __$MessageInputStateCopyWithImpl<$Res>
    implements _$MessageInputStateCopyWith<$Res> {
  __$MessageInputStateCopyWithImpl(this._self, this._then);

  final _MessageInputState _self;
  final $Res Function(_MessageInputState) _then;

/// Create a copy of MessageInputState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? attachment = freezed,Object? isSending = null,Object? errorMessage = freezed,Object? preparedAttachmentId = freezed,Object? uploadUrl = freezed,Object? uploadedAttachmentId = freezed,}) {
  return _then(_MessageInputState(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,attachment: freezed == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as PendingAttachment?,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,preparedAttachmentId: freezed == preparedAttachmentId ? _self.preparedAttachmentId : preparedAttachmentId // ignore: cast_nullable_to_non_nullable
as String?,uploadUrl: freezed == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String?,uploadedAttachmentId: freezed == uploadedAttachmentId ? _self.uploadedAttachmentId : uploadedAttachmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MessageInputState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PendingAttachmentCopyWith<$Res>? get attachment {
    if (_self.attachment == null) {
    return null;
  }

  return $PendingAttachmentCopyWith<$Res>(_self.attachment!, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}

// dart format on
