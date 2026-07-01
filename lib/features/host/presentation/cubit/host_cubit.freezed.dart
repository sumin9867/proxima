// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'host_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HostState {

 HostStatus get status; SessionCode? get code; List<LiveParticipant> get participants; String? get errorMessage;
/// Create a copy of HostState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HostStateCopyWith<HostState> get copyWith => _$HostStateCopyWithImpl<HostState>(this as HostState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HostState&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,code,const DeepCollectionEquality().hash(participants),errorMessage);

@override
String toString() {
  return 'HostState(status: $status, code: $code, participants: $participants, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $HostStateCopyWith<$Res>  {
  factory $HostStateCopyWith(HostState value, $Res Function(HostState) _then) = _$HostStateCopyWithImpl;
@useResult
$Res call({
 HostStatus status, SessionCode? code, List<LiveParticipant> participants, String? errorMessage
});


$SessionCodeCopyWith<$Res>? get code;

}
/// @nodoc
class _$HostStateCopyWithImpl<$Res>
    implements $HostStateCopyWith<$Res> {
  _$HostStateCopyWithImpl(this._self, this._then);

  final HostState _self;
  final $Res Function(HostState) _then;

/// Create a copy of HostState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? code = freezed,Object? participants = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HostStatus,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as SessionCode?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<LiveParticipant>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of HostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionCodeCopyWith<$Res>? get code {
    if (_self.code == null) {
    return null;
  }

  return $SessionCodeCopyWith<$Res>(_self.code!, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}


/// Adds pattern-matching-related methods to [HostState].
extension HostStatePatterns on HostState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HostState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HostState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HostState value)  $default,){
final _that = this;
switch (_that) {
case _HostState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HostState value)?  $default,){
final _that = this;
switch (_that) {
case _HostState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HostStatus status,  SessionCode? code,  List<LiveParticipant> participants,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HostState() when $default != null:
return $default(_that.status,_that.code,_that.participants,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HostStatus status,  SessionCode? code,  List<LiveParticipant> participants,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _HostState():
return $default(_that.status,_that.code,_that.participants,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HostStatus status,  SessionCode? code,  List<LiveParticipant> participants,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _HostState() when $default != null:
return $default(_that.status,_that.code,_that.participants,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _HostState extends HostState {
  const _HostState({this.status = HostStatus.starting, this.code, final  List<LiveParticipant> participants = const <LiveParticipant>[], this.errorMessage}): _participants = participants,super._();
  

@override@JsonKey() final  HostStatus status;
@override final  SessionCode? code;
 final  List<LiveParticipant> _participants;
@override@JsonKey() List<LiveParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override final  String? errorMessage;

/// Create a copy of HostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HostStateCopyWith<_HostState> get copyWith => __$HostStateCopyWithImpl<_HostState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HostState&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,code,const DeepCollectionEquality().hash(_participants),errorMessage);

@override
String toString() {
  return 'HostState(status: $status, code: $code, participants: $participants, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$HostStateCopyWith<$Res> implements $HostStateCopyWith<$Res> {
  factory _$HostStateCopyWith(_HostState value, $Res Function(_HostState) _then) = __$HostStateCopyWithImpl;
@override @useResult
$Res call({
 HostStatus status, SessionCode? code, List<LiveParticipant> participants, String? errorMessage
});


@override $SessionCodeCopyWith<$Res>? get code;

}
/// @nodoc
class __$HostStateCopyWithImpl<$Res>
    implements _$HostStateCopyWith<$Res> {
  __$HostStateCopyWithImpl(this._self, this._then);

  final _HostState _self;
  final $Res Function(_HostState) _then;

/// Create a copy of HostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? code = freezed,Object? participants = null,Object? errorMessage = freezed,}) {
  return _then(_HostState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HostStatus,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as SessionCode?,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<LiveParticipant>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of HostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionCodeCopyWith<$Res>? get code {
    if (_self.code == null) {
    return null;
  }

  return $SessionCodeCopyWith<$Res>(_self.code!, (value) {
    return _then(_self.copyWith(code: value));
  });
}
}

// dart format on
