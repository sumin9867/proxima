import 'dart:developer' as developer;
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'signaling_message.dart';

/// Outcome of a join attempt.
enum JoinResult { connected, badCode, full, unreachable }

/// A roster entry as seen by a joined client.
@immutable
class RosterMember {
  const RosterMember({required this.id, required this.name});
  final String id;
  final String name;
}

/// The joiner-side signaling connection to a host's [SignalingServer].
///
/// Connects over WebSocket, performs the `hello` handshake with the session
/// code, and then surfaces roster changes and relayed WebRTC payloads. Relay
/// frames are routed to/from other peers (including the host) by id.
class SignalingClient {
  SignalingClient({
    required this.host,
    required this.port,
    required this.displayName,
  });

  final String host;
  final int port;
  final String displayName;

  WebSocket? _socket;
  String? _peerId;
  String? _hostId;

  final _rosterJoined = StreamController<RosterMember>.broadcast();
  final _rosterLeft = StreamController<String>.broadcast();
  final _relay =
      StreamController<
        ({String from, Map<String, dynamic> payload})
      >.broadcast();

  void _log(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'SignalingClient',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// This client's assigned peer id, valid after a successful [join].
  String? get peerId => _peerId;

  /// The host's peer id (relay target for the host).
  String? get hostId => _hostId;

  Stream<RosterMember> get onPeerJoined => _rosterJoined.stream;
  Stream<String> get onPeerLeft => _rosterLeft.stream;
  Stream<({String from, Map<String, dynamic> payload})> get onRelay =>
      _relay.stream;

  /// Connects and completes the handshake. Returns the initial roster (existing
  /// members, so the client can open WebRTC to each) on success.
  Future<({JoinResult result, List<RosterMember> roster})> join(
    String code,
  ) async {
    final completer =
        Completer<({JoinResult result, List<RosterMember> roster})>();
    try {
      _log('join() connecting to ws://$host:$port with code=$code');
      final socket = await WebSocket.connect(
        'ws://$host:$port',
      ).timeout(const Duration(seconds: 6));
      _socket = socket;
      _log('WebSocket connected to ws://$host:$port');

      socket.listen(
        (data) {
          _log('received frame: $data');
          _onMessage(data as String, completer);
        },
        onDone: () {
          _log('socket closed');
          if (!completer.isCompleted) {
            _log(
              'completing join as unreachable because socket closed before welcome',
            );
            completer.complete((
              result: JoinResult.unreachable,
              roster: const <RosterMember>[],
            ));
          }
        },
        onError: (error, stackTrace) {
          _log('socket error', error: error, stackTrace: stackTrace);
          if (!completer.isCompleted) {
            _log('completing join as unreachable because of socket error');
            completer.complete((
              result: JoinResult.unreachable,
              roster: const <RosterMember>[],
            ));
          }
        },
        cancelOnError: true,
      );

      final hello = {
        'type': SignalType.hello,
        'code': code,
        'name': displayName,
      }.encode();
      _log('sending hello frame: $hello');
      socket.add(hello);
    } catch (error, stackTrace) {
      _log(
        'join() failed before socket handshake completed',
        error: error,
        stackTrace: stackTrace,
      );
      return (result: JoinResult.unreachable, roster: const <RosterMember>[]);
    }
    return completer.future;
  }

  void _onMessage(
    String raw,
    Completer<({JoinResult result, List<RosterMember> roster})> completer,
  ) {
    final Map<String, dynamic> msg;
    try {
      msg = SignalFrame.decode(raw);
    } catch (_) {
      return;
    }

    switch (msg.type) {
      case SignalType.welcome:
        _log(
          'welcome received: peerId=${msg['peerId']}, hostId=${msg['hostId']}, rosterSize=${(msg['roster'] as List? ?? const []).length}',
        );
        _peerId = msg['peerId'] as String?;
        _hostId = msg['hostId'] as String?;
        final roster = [
          for (final m in (msg['roster'] as List? ?? const []))
            RosterMember(id: m['id'] as String, name: m['name'] as String),
        ];
        if (!completer.isCompleted) {
          completer.complete((result: JoinResult.connected, roster: roster));
        }

      case SignalType.rejected:
        final reason = msg['reason'] as String?;
        _log('join rejected: reason=$reason');
        if (!completer.isCompleted) {
          completer.complete((
            result: reason == 'full' ? JoinResult.full : JoinResult.badCode,
            roster: const <RosterMember>[],
          ));
        }

      case SignalType.peerJoined:
        _log('peerJoined: peerId=${msg['peerId']}, name=${msg['name']}');
        _rosterJoined.add(
          RosterMember(
            id: msg['peerId'] as String,
            name: msg['name'] as String,
          ),
        );

      case SignalType.peerLeft:
        _log('peerLeft: peerId=${msg['peerId']}');
        _rosterLeft.add(msg['peerId'] as String);

      case SignalType.relay:
        final from = msg['from'] as String?;
        final payload = msg['payload'] as Map<String, dynamic>?;
        if (from != null && payload != null) {
          _log('relay received from=$from, type=${payload['type']}');
          _relay.add((from: from, payload: payload));
        }
    }
  }

  /// Sends a WebRTC payload to another peer (or the host) by id.
  void relay(String to, Map<String, dynamic> payload) {
    _socket?.add(
      {'type': SignalType.relay, 'to': to, 'payload': payload}.encode(),
    );
  }

  Future<void> dispose() async {
    await _socket?.close();
    _socket = null;
    await _rosterJoined.close();
    await _rosterLeft.close();
    await _relay.close();
  }
}
