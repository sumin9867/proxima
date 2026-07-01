part of 'call_cubit.dart';

@freezed
abstract class CallState with _$CallState {
  const CallState._();

  const factory CallState({
    required CallMode mode,
    @Default(<LiveParticipant>[]) List<LiveParticipant> participants,
    @Default(0) int elapsedSeconds,
    @Default(false) bool isMuted,
    @Default(false) bool isCameraOn,
    @Default(false) bool isSpeakerOn,
  }) = _CallState;

  /// Elapsed call time formatted as HH:MM:SS.
  String get elapsedLabel {
    final h = elapsedSeconds ~/ 3600;
    final m = (elapsedSeconds % 3600) ~/ 60;
    final s = elapsedSeconds % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(h)}:${two(m)}:${two(s)}';
  }

  /// Remote participants (everyone but the local user).
  List<LiveParticipant> get remotes =>
      participants.where((p) => !p.isSelf).toList();

  /// The local user, if present in the roster.
  LiveParticipant? get self =>
      participants.where((p) => p.isSelf).firstOrNull;
}
