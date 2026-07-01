// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JoinState {

 bool get isScanning; List<DiscoveredHost> get hosts; JoinStatus get status; JoinResult? get failure; SessionService? get joinedSession;
/// Create a copy of JoinState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinStateCopyWith<JoinState> get copyWith => _$JoinStateCopyWithImpl<JoinState>(this as JoinState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinState&&(identical(other.isScanning, isScanning) || other.isScanning == isScanning)&&const DeepCollectionEquality().equals(other.hosts, hosts)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.joinedSession, joinedSession) || other.joinedSession == joinedSession));
}


@override
int get hashCode => Object.hash(runtimeType,isScanning,const DeepCollectionEquality().hash(hosts),status,failure,joinedSession);

@override
String toString() {
  return 'JoinState(isScanning: $isScanning, hosts: $hosts, status: $status, failure: $failure, joinedSession: $joinedSession)';
}


}

/// @nodoc
abstract mixin class $JoinStateCopyWith<$Res>  {
  factory $JoinStateCopyWith(JoinState value, $Res Function(JoinState) _then) = _$JoinStateCopyWithImpl;
@useResult
$Res call({
 bool isScanning, List<DiscoveredHost> hosts, JoinStatus status, JoinResult? failure, SessionService? joinedSession
});




}
/// @nodoc
class _$JoinStateCopyWithImpl<$Res>
    implements $JoinStateCopyWith<$Res> {
  _$JoinStateCopyWithImpl(this._self, this._then);

  final JoinState _self;
  final $Res Function(JoinState) _then;

/// Create a copy of JoinState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isScanning = null,Object? hosts = null,Object? status = null,Object? failure = freezed,Object? joinedSession = freezed,}) {
  return _then(_self.copyWith(
isScanning: null == isScanning ? _self.isScanning : isScanning // ignore: cast_nullable_to_non_nullable
as bool,hosts: null == hosts ? _self.hosts : hosts // ignore: cast_nullable_to_non_nullable
as List<DiscoveredHost>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JoinStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as JoinResult?,joinedSession: freezed == joinedSession ? _self.joinedSession : joinedSession // ignore: cast_nullable_to_non_nullable
as SessionService?,
  ));
}

}


/// Adds pattern-matching-related methods to [JoinState].
extension JoinStatePatterns on JoinState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JoinState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JoinState value)  $default,){
final _that = this;
switch (_that) {
case _JoinState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JoinState value)?  $default,){
final _that = this;
switch (_that) {
case _JoinState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isScanning,  List<DiscoveredHost> hosts,  JoinStatus status,  JoinResult? failure,  SessionService? joinedSession)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinState() when $default != null:
return $default(_that.isScanning,_that.hosts,_that.status,_that.failure,_that.joinedSession);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isScanning,  List<DiscoveredHost> hosts,  JoinStatus status,  JoinResult? failure,  SessionService? joinedSession)  $default,) {final _that = this;
switch (_that) {
case _JoinState():
return $default(_that.isScanning,_that.hosts,_that.status,_that.failure,_that.joinedSession);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isScanning,  List<DiscoveredHost> hosts,  JoinStatus status,  JoinResult? failure,  SessionService? joinedSession)?  $default,) {final _that = this;
switch (_that) {
case _JoinState() when $default != null:
return $default(_that.isScanning,_that.hosts,_that.status,_that.failure,_that.joinedSession);case _:
  return null;

}
}

}

/// @nodoc


class _JoinState implements JoinState {
  const _JoinState({this.isScanning = true, final  List<DiscoveredHost> hosts = const <DiscoveredHost>[], this.status = JoinStatus.idle, this.failure, this.joinedSession}): _hosts = hosts;
  

@override@JsonKey() final  bool isScanning;
 final  List<DiscoveredHost> _hosts;
@override@JsonKey() List<DiscoveredHost> get hosts {
  if (_hosts is EqualUnmodifiableListView) return _hosts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hosts);
}

@override@JsonKey() final  JoinStatus status;
@override final  JoinResult? failure;
@override final  SessionService? joinedSession;

/// Create a copy of JoinState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinStateCopyWith<_JoinState> get copyWith => __$JoinStateCopyWithImpl<_JoinState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinState&&(identical(other.isScanning, isScanning) || other.isScanning == isScanning)&&const DeepCollectionEquality().equals(other._hosts, _hosts)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.joinedSession, joinedSession) || other.joinedSession == joinedSession));
}


@override
int get hashCode => Object.hash(runtimeType,isScanning,const DeepCollectionEquality().hash(_hosts),status,failure,joinedSession);

@override
String toString() {
  return 'JoinState(isScanning: $isScanning, hosts: $hosts, status: $status, failure: $failure, joinedSession: $joinedSession)';
}


}

/// @nodoc
abstract mixin class _$JoinStateCopyWith<$Res> implements $JoinStateCopyWith<$Res> {
  factory _$JoinStateCopyWith(_JoinState value, $Res Function(_JoinState) _then) = __$JoinStateCopyWithImpl;
@override @useResult
$Res call({
 bool isScanning, List<DiscoveredHost> hosts, JoinStatus status, JoinResult? failure, SessionService? joinedSession
});




}
/// @nodoc
class __$JoinStateCopyWithImpl<$Res>
    implements _$JoinStateCopyWith<$Res> {
  __$JoinStateCopyWithImpl(this._self, this._then);

  final _JoinState _self;
  final $Res Function(_JoinState) _then;

/// Create a copy of JoinState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isScanning = null,Object? hosts = null,Object? status = null,Object? failure = freezed,Object? joinedSession = freezed,}) {
  return _then(_JoinState(
isScanning: null == isScanning ? _self.isScanning : isScanning // ignore: cast_nullable_to_non_nullable
as bool,hosts: null == hosts ? _self._hosts : hosts // ignore: cast_nullable_to_non_nullable
as List<DiscoveredHost>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JoinStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as JoinResult?,joinedSession: freezed == joinedSession ? _self.joinedSession : joinedSession // ignore: cast_nullable_to_non_nullable
as SessionService?,
  ));
}


}

// dart format on
