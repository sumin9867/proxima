import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:local_voice_call/core/discovery/discovery_service.dart';
import 'package:local_voice_call/core/session/session_service.dart';
import 'package:local_voice_call/core/signaling/signaling_client.dart';
import 'package:local_voice_call/models/session_code.dart';

part 'join_cubit.freezed.dart';
part 'join_state.dart';

/// Drives the join screen: scans the LAN for hosts and performs the join
/// handshake for a chosen host, a typed code, or a scanned QR.
class JoinCubit extends Cubit<JoinState> {
  JoinCubit({
    required String displayName,
    required bool video,
    DiscoveryService? discovery,
  })  : _displayName = displayName,
        _video = video,
        _discovery = discovery ?? DiscoveryService(),
        super(const JoinState()) {
    _startDiscovery();
  }

  final String _displayName;
  final bool _video;
  final DiscoveryService _discovery;

  Future<void> _startDiscovery() async {
    _discovery.onHosts.listen((hosts) {
      emit(state.copyWith(hosts: hosts, isScanning: true));
    });
    await _discovery.discover();
  }

  /// Attempts to join [target]. On success, emits [JoinStatus.joined] carrying a
  /// connected [SessionService] for the call screen to adopt.
  Future<void> joinTarget(SessionCode target) async {
    emit(state.copyWith(status: JoinStatus.joining));
    final service = SessionService(displayName: _displayName, video: _video);
    final result = await service.join(target);
    if (result == JoinResult.connected) {
      emit(state.copyWith(status: JoinStatus.joined, joinedSession: service));
    } else {
      await service.dispose();
      emit(state.copyWith(status: JoinStatus.failed, failure: result));
    }
  }

  /// Joins a host discovered on the network.
  Future<void> joinDiscovered(DiscoveredHost host) {
    return joinTarget(
      SessionCode(code: host.code, host: host.host, port: host.port),
    );
  }

  /// Joins by a typed code, resolving its address via discovery.
  Future<void> joinByCode(String rawCode) async {
    final normalized = rawCode.replaceAll('·', '').toUpperCase();
    final resolved = _discovery.resolve(normalized);
    if (resolved == null) {
      emit(state.copyWith(status: JoinStatus.notFound));
      return;
    }
    await joinDiscovered(resolved);
  }

  /// Joins from a scanned QR payload.
  Future<void> joinByQr(String payload) async {
    final code = SessionCode.tryParseQr(payload);
    if (code == null) {
      emit(state.copyWith(status: JoinStatus.notFound));
      return;
    }
    await joinTarget(code);
  }

  void resetStatus() => emit(state.copyWith(status: JoinStatus.idle));

  @override
  Future<void> close() {
    _discovery.dispose();
    return super.close();
  }
}
