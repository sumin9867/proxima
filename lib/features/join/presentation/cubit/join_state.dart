part of 'join_cubit.dart';

/// Where the join flow is in its lifecycle.
enum JoinStatus { idle, joining, joined, failed, notFound }

@freezed
abstract class JoinState with _$JoinState {
  const factory JoinState({
    @Default(true) bool isScanning,
    @Default(<DiscoveredHost>[]) List<DiscoveredHost> hosts,
    @Default(JoinStatus.idle) JoinStatus status,
    JoinResult? failure,
    SessionService? joinedSession,
  }) = _JoinState;
}
