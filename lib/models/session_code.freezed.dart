// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionCode {

 String get code; String get host; int get port;
/// Create a copy of SessionCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCodeCopyWith<SessionCode> get copyWith => _$SessionCodeCopyWithImpl<SessionCode>(this as SessionCode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionCode&&(identical(other.code, code) || other.code == code)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port));
}


@override
int get hashCode => Object.hash(runtimeType,code,host,port);

@override
String toString() {
  return 'SessionCode(code: $code, host: $host, port: $port)';
}


}

/// @nodoc
abstract mixin class $SessionCodeCopyWith<$Res>  {
  factory $SessionCodeCopyWith(SessionCode value, $Res Function(SessionCode) _then) = _$SessionCodeCopyWithImpl;
@useResult
$Res call({
 String code, String host, int port
});




}
/// @nodoc
class _$SessionCodeCopyWithImpl<$Res>
    implements $SessionCodeCopyWith<$Res> {
  _$SessionCodeCopyWithImpl(this._self, this._then);

  final SessionCode _self;
  final $Res Function(SessionCode) _then;

/// Create a copy of SessionCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? host = null,Object? port = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionCode].
extension SessionCodePatterns on SessionCode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionCode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionCode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionCode value)  $default,){
final _that = this;
switch (_that) {
case _SessionCode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionCode value)?  $default,){
final _that = this;
switch (_that) {
case _SessionCode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String host,  int port)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionCode() when $default != null:
return $default(_that.code,_that.host,_that.port);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String host,  int port)  $default,) {final _that = this;
switch (_that) {
case _SessionCode():
return $default(_that.code,_that.host,_that.port);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String host,  int port)?  $default,) {final _that = this;
switch (_that) {
case _SessionCode() when $default != null:
return $default(_that.code,_that.host,_that.port);case _:
  return null;

}
}

}

/// @nodoc


class _SessionCode extends SessionCode {
  const _SessionCode({required this.code, required this.host, required this.port}): super._();
  

@override final  String code;
@override final  String host;
@override final  int port;

/// Create a copy of SessionCode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCodeCopyWith<_SessionCode> get copyWith => __$SessionCodeCopyWithImpl<_SessionCode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionCode&&(identical(other.code, code) || other.code == code)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port));
}


@override
int get hashCode => Object.hash(runtimeType,code,host,port);

@override
String toString() {
  return 'SessionCode(code: $code, host: $host, port: $port)';
}


}

/// @nodoc
abstract mixin class _$SessionCodeCopyWith<$Res> implements $SessionCodeCopyWith<$Res> {
  factory _$SessionCodeCopyWith(_SessionCode value, $Res Function(_SessionCode) _then) = __$SessionCodeCopyWithImpl;
@override @useResult
$Res call({
 String code, String host, int port
});




}
/// @nodoc
class __$SessionCodeCopyWithImpl<$Res>
    implements _$SessionCodeCopyWith<$Res> {
  __$SessionCodeCopyWithImpl(this._self, this._then);

  final _SessionCode _self;
  final $Res Function(_SessionCode) _then;

/// Create a copy of SessionCode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? host = null,Object? port = null,}) {
  return _then(_SessionCode(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
