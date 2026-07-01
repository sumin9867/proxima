// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallState {

 CallMode get mode; List<LiveParticipant> get participants; int get elapsedSeconds; bool get isMuted; bool get isCameraOn; bool get isSpeakerOn;
/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStateCopyWith<CallState> get copyWith => _$CallStateCopyWithImpl<CallState>(this as CallState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallState&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isCameraOn, isCameraOn) || other.isCameraOn == isCameraOn)&&(identical(other.isSpeakerOn, isSpeakerOn) || other.isSpeakerOn == isSpeakerOn));
}


@override
int get hashCode => Object.hash(runtimeType,mode,const DeepCollectionEquality().hash(participants),elapsedSeconds,isMuted,isCameraOn,isSpeakerOn);

@override
String toString() {
  return 'CallState(mode: $mode, participants: $participants, elapsedSeconds: $elapsedSeconds, isMuted: $isMuted, isCameraOn: $isCameraOn, isSpeakerOn: $isSpeakerOn)';
}


}

/// @nodoc
abstract mixin class $CallStateCopyWith<$Res>  {
  factory $CallStateCopyWith(CallState value, $Res Function(CallState) _then) = _$CallStateCopyWithImpl;
@useResult
$Res call({
 CallMode mode, List<LiveParticipant> participants, int elapsedSeconds, bool isMuted, bool isCameraOn, bool isSpeakerOn
});




}
/// @nodoc
class _$CallStateCopyWithImpl<$Res>
    implements $CallStateCopyWith<$Res> {
  _$CallStateCopyWithImpl(this._self, this._then);

  final CallState _self;
  final $Res Function(CallState) _then;

/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? participants = null,Object? elapsedSeconds = null,Object? isMuted = null,Object? isCameraOn = null,Object? isSpeakerOn = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as CallMode,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<LiveParticipant>,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isCameraOn: null == isCameraOn ? _self.isCameraOn : isCameraOn // ignore: cast_nullable_to_non_nullable
as bool,isSpeakerOn: null == isSpeakerOn ? _self.isSpeakerOn : isSpeakerOn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CallState].
extension CallStatePatterns on CallState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallState value)  $default,){
final _that = this;
switch (_that) {
case _CallState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallState value)?  $default,){
final _that = this;
switch (_that) {
case _CallState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CallMode mode,  List<LiveParticipant> participants,  int elapsedSeconds,  bool isMuted,  bool isCameraOn,  bool isSpeakerOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallState() when $default != null:
return $default(_that.mode,_that.participants,_that.elapsedSeconds,_that.isMuted,_that.isCameraOn,_that.isSpeakerOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CallMode mode,  List<LiveParticipant> participants,  int elapsedSeconds,  bool isMuted,  bool isCameraOn,  bool isSpeakerOn)  $default,) {final _that = this;
switch (_that) {
case _CallState():
return $default(_that.mode,_that.participants,_that.elapsedSeconds,_that.isMuted,_that.isCameraOn,_that.isSpeakerOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CallMode mode,  List<LiveParticipant> participants,  int elapsedSeconds,  bool isMuted,  bool isCameraOn,  bool isSpeakerOn)?  $default,) {final _that = this;
switch (_that) {
case _CallState() when $default != null:
return $default(_that.mode,_that.participants,_that.elapsedSeconds,_that.isMuted,_that.isCameraOn,_that.isSpeakerOn);case _:
  return null;

}
}

}

/// @nodoc


class _CallState extends CallState {
  const _CallState({required this.mode, final  List<LiveParticipant> participants = const <LiveParticipant>[], this.elapsedSeconds = 0, this.isMuted = false, this.isCameraOn = false, this.isSpeakerOn = false}): _participants = participants,super._();
  

@override final  CallMode mode;
 final  List<LiveParticipant> _participants;
@override@JsonKey() List<LiveParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override@JsonKey() final  int elapsedSeconds;
@override@JsonKey() final  bool isMuted;
@override@JsonKey() final  bool isCameraOn;
@override@JsonKey() final  bool isSpeakerOn;

/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallStateCopyWith<_CallState> get copyWith => __$CallStateCopyWithImpl<_CallState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallState&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isCameraOn, isCameraOn) || other.isCameraOn == isCameraOn)&&(identical(other.isSpeakerOn, isSpeakerOn) || other.isSpeakerOn == isSpeakerOn));
}


@override
int get hashCode => Object.hash(runtimeType,mode,const DeepCollectionEquality().hash(_participants),elapsedSeconds,isMuted,isCameraOn,isSpeakerOn);

@override
String toString() {
  return 'CallState(mode: $mode, participants: $participants, elapsedSeconds: $elapsedSeconds, isMuted: $isMuted, isCameraOn: $isCameraOn, isSpeakerOn: $isSpeakerOn)';
}


}

/// @nodoc
abstract mixin class _$CallStateCopyWith<$Res> implements $CallStateCopyWith<$Res> {
  factory _$CallStateCopyWith(_CallState value, $Res Function(_CallState) _then) = __$CallStateCopyWithImpl;
@override @useResult
$Res call({
 CallMode mode, List<LiveParticipant> participants, int elapsedSeconds, bool isMuted, bool isCameraOn, bool isSpeakerOn
});




}
/// @nodoc
class __$CallStateCopyWithImpl<$Res>
    implements _$CallStateCopyWith<$Res> {
  __$CallStateCopyWithImpl(this._self, this._then);

  final _CallState _self;
  final $Res Function(_CallState) _then;

/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? participants = null,Object? elapsedSeconds = null,Object? isMuted = null,Object? isCameraOn = null,Object? isSpeakerOn = null,}) {
  return _then(_CallState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as CallMode,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<LiveParticipant>,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isCameraOn: null == isCameraOn ? _self.isCameraOn : isCameraOn // ignore: cast_nullable_to_non_nullable
as bool,isSpeakerOn: null == isSpeakerOn ? _self.isSpeakerOn : isSpeakerOn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
