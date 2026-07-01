part of 'host_cubit.dart';

/// Lifecycle of the host flow.
enum HostStatus { starting, hosting, failed }

@freezed
abstract class HostState with _$HostState {
  const HostState._();

  const factory HostState({
    @Default(HostStatus.starting) HostStatus status,
    SessionCode? code,
    @Default(<LiveParticipant>[]) List<LiveParticipant> participants,
    String? errorMessage,
  }) = _HostState;

  factory HostState.starting() => const HostState();

  factory HostState.hosting({
    required SessionCode code,
    required List<LiveParticipant> participants,
  }) =>
      HostState(
        status: HostStatus.hosting,
        code: code,
        participants: participants,
      );

  factory HostState.failed(String message) =>
      HostState(status: HostStatus.failed, errorMessage: message);
}
