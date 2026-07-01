import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:local_voice_call/core/session/session_service.dart';
import 'package:local_voice_call/models/session_code.dart';

part 'host_cubit.freezed.dart';
part 'host_state.dart';

/// Drives the host screen: starts a real LAN session and tracks the live
/// participant roster as joiners connect.
class HostCubit extends Cubit<HostState> {
  HostCubit({required SessionService session})
      : _session = session,
        super( HostState.starting());

  final SessionService _session;

  /// The underlying service, handed to the call screen when the host proceeds.
  SessionService get session => _session;

  Future<void> start() async {
    try {
      final code = await _session.startHosting();
      _session.participants.listen((people) {
        emit(HostState.hosting(code: code, participants: people));
      });
      emit(HostState.hosting(code: code, participants: const []));
    } catch (e) {
      emit(HostState.failed(e.toString()));
    }
  }
}
