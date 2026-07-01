import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:local_voice_call/core/session/session_service.dart';
import 'package:local_voice_call/models/session.dart';

part 'call_cubit.freezed.dart';
part 'call_state.dart';

/// Drives an active call — voice or video — over a live [SessionService].
///
/// Tracks the call duration, the local device controls (mute, camera, speaker),
/// and mirrors the service's live participant roster into state.
class CallCubit extends Cubit<CallState> {
  CallCubit({required SessionService session, required CallMode mode})
    : _session = session,
      super(CallState(mode: mode, isCameraOn: mode == CallMode.video)) {
    if (mode == CallMode.voice) {
      _session.setCamera(false);
    }
    _participantsSub = _session.participants.listen((people) {
      emit(state.copyWith(participants: people));
    });
    _startTimer();
  }

  final SessionService _session;
  Timer? _timer;
  StreamSubscription<List<LiveParticipant>>? _participantsSub;

  SessionService get session => _session;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(state.copyWith(elapsedSeconds: state.elapsedSeconds + 1));
    });
  }

  void toggleMute() {
    final nextMuted = !state.isMuted;
    _session.setMic(!nextMuted); // muting means disabling the mic track
    emit(state.copyWith(isMuted: nextMuted));
  }

  void toggleCamera() {
    final next = !state.isCameraOn;
    _session.setCamera(next);
    emit(
      state.copyWith(
        isCameraOn: next,
        mode: next ? CallMode.video : CallMode.voice,
      ),
    );
  }

  void toggleSpeaker() => emit(state.copyWith(isSpeakerOn: !state.isSpeakerOn));

  Future<void> switchCamera() => _session.switchCamera();

  /// Ends the call and tears down all connections.
  Future<void> hangUp() async {
    _timer?.cancel();
    await _participantsSub?.cancel();
    await _session.dispose();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _participantsSub?.cancel();
    return super.close();
  }
}
