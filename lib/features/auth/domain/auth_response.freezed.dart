// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AuthResponse _$AuthResponseFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'twoFaRequired':
          return _TwoFaRequired.fromJson(
            json
          );
                case 'preTrust':
          return _PreTrust.fromJson(
            json
          );
                case 'fullSuccess':
          return _FullSuccess.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'AuthResponse',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$AuthResponse {



  /// Serializes this AuthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthResponse);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthResponse()';
}


}

/// @nodoc
class $AuthResponseCopyWith<$Res>  {
$AuthResponseCopyWith(AuthResponse _, $Res Function(AuthResponse) __);
}


/// Adds pattern-matching-related methods to [AuthResponse].
extension AuthResponsePatterns on AuthResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _TwoFaRequired value)?  twoFaRequired,TResult Function( _PreTrust value)?  preTrust,TResult Function( _FullSuccess value)?  fullSuccess,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that);case _PreTrust() when preTrust != null:
return preTrust(_that);case _FullSuccess() when fullSuccess != null:
return fullSuccess(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _TwoFaRequired value)  twoFaRequired,required TResult Function( _PreTrust value)  preTrust,required TResult Function( _FullSuccess value)  fullSuccess,}){
final _that = this;
switch (_that) {
case _TwoFaRequired():
return twoFaRequired(_that);case _PreTrust():
return preTrust(_that);case _FullSuccess():
return fullSuccess(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _TwoFaRequired value)?  twoFaRequired,TResult? Function( _PreTrust value)?  preTrust,TResult? Function( _FullSuccess value)?  fullSuccess,}){
final _that = this;
switch (_that) {
case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that);case _PreTrust() when preTrust != null:
return preTrust(_that);case _FullSuccess() when fullSuccess != null:
return fullSuccess(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String twoFaToken)?  twoFaRequired,TResult Function( String setupToken,  String challenge)?  preTrust,TResult Function( String accessToken,  String refreshToken)?  fullSuccess,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that.twoFaToken);case _PreTrust() when preTrust != null:
return preTrust(_that.setupToken,_that.challenge);case _FullSuccess() when fullSuccess != null:
return fullSuccess(_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String twoFaToken)  twoFaRequired,required TResult Function( String setupToken,  String challenge)  preTrust,required TResult Function( String accessToken,  String refreshToken)  fullSuccess,}) {final _that = this;
switch (_that) {
case _TwoFaRequired():
return twoFaRequired(_that.twoFaToken);case _PreTrust():
return preTrust(_that.setupToken,_that.challenge);case _FullSuccess():
return fullSuccess(_that.accessToken,_that.refreshToken);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String twoFaToken)?  twoFaRequired,TResult? Function( String setupToken,  String challenge)?  preTrust,TResult? Function( String accessToken,  String refreshToken)?  fullSuccess,}) {final _that = this;
switch (_that) {
case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that.twoFaToken);case _PreTrust() when preTrust != null:
return preTrust(_that.setupToken,_that.challenge);case _FullSuccess() when fullSuccess != null:
return fullSuccess(_that.accessToken,_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TwoFaRequired implements AuthResponse {
  const _TwoFaRequired({this.twoFaToken = '', final  String? $type}): $type = $type ?? 'twoFaRequired';
  factory _TwoFaRequired.fromJson(Map<String, dynamic> json) => _$TwoFaRequiredFromJson(json);

@JsonKey() final  String twoFaToken;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TwoFaRequiredCopyWith<_TwoFaRequired> get copyWith => __$TwoFaRequiredCopyWithImpl<_TwoFaRequired>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TwoFaRequiredToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TwoFaRequired&&(identical(other.twoFaToken, twoFaToken) || other.twoFaToken == twoFaToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,twoFaToken);

@override
String toString() {
  return 'AuthResponse.twoFaRequired(twoFaToken: $twoFaToken)';
}


}

/// @nodoc
abstract mixin class _$TwoFaRequiredCopyWith<$Res> implements $AuthResponseCopyWith<$Res> {
  factory _$TwoFaRequiredCopyWith(_TwoFaRequired value, $Res Function(_TwoFaRequired) _then) = __$TwoFaRequiredCopyWithImpl;
@useResult
$Res call({
 String twoFaToken
});




}
/// @nodoc
class __$TwoFaRequiredCopyWithImpl<$Res>
    implements _$TwoFaRequiredCopyWith<$Res> {
  __$TwoFaRequiredCopyWithImpl(this._self, this._then);

  final _TwoFaRequired _self;
  final $Res Function(_TwoFaRequired) _then;

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? twoFaToken = null,}) {
  return _then(_TwoFaRequired(
twoFaToken: null == twoFaToken ? _self.twoFaToken : twoFaToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class _PreTrust implements AuthResponse {
  const _PreTrust({this.setupToken = '', this.challenge = '', final  String? $type}): $type = $type ?? 'preTrust';
  factory _PreTrust.fromJson(Map<String, dynamic> json) => _$PreTrustFromJson(json);

@JsonKey() final  String setupToken;
@JsonKey() final  String challenge;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreTrustCopyWith<_PreTrust> get copyWith => __$PreTrustCopyWithImpl<_PreTrust>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreTrustToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreTrust&&(identical(other.setupToken, setupToken) || other.setupToken == setupToken)&&(identical(other.challenge, challenge) || other.challenge == challenge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,setupToken,challenge);

@override
String toString() {
  return 'AuthResponse.preTrust(setupToken: $setupToken, challenge: $challenge)';
}


}

/// @nodoc
abstract mixin class _$PreTrustCopyWith<$Res> implements $AuthResponseCopyWith<$Res> {
  factory _$PreTrustCopyWith(_PreTrust value, $Res Function(_PreTrust) _then) = __$PreTrustCopyWithImpl;
@useResult
$Res call({
 String setupToken, String challenge
});




}
/// @nodoc
class __$PreTrustCopyWithImpl<$Res>
    implements _$PreTrustCopyWith<$Res> {
  __$PreTrustCopyWithImpl(this._self, this._then);

  final _PreTrust _self;
  final $Res Function(_PreTrust) _then;

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? setupToken = null,Object? challenge = null,}) {
  return _then(_PreTrust(
setupToken: null == setupToken ? _self.setupToken : setupToken // ignore: cast_nullable_to_non_nullable
as String,challenge: null == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class _FullSuccess implements AuthResponse {
  const _FullSuccess({this.accessToken = '', this.refreshToken = '', final  String? $type}): $type = $type ?? 'fullSuccess';
  factory _FullSuccess.fromJson(Map<String, dynamic> json) => _$FullSuccessFromJson(json);

@JsonKey() final  String accessToken;
@JsonKey() final  String refreshToken;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FullSuccessCopyWith<_FullSuccess> get copyWith => __$FullSuccessCopyWithImpl<_FullSuccess>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FullSuccessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FullSuccess&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken);

@override
String toString() {
  return 'AuthResponse.fullSuccess(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$FullSuccessCopyWith<$Res> implements $AuthResponseCopyWith<$Res> {
  factory _$FullSuccessCopyWith(_FullSuccess value, $Res Function(_FullSuccess) _then) = __$FullSuccessCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken
});




}
/// @nodoc
class __$FullSuccessCopyWithImpl<$Res>
    implements _$FullSuccessCopyWith<$Res> {
  __$FullSuccessCopyWithImpl(this._self, this._then);

  final _FullSuccess _self;
  final $Res Function(_FullSuccess) _then;

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_FullSuccess(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
