import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'signaling_message.dart';

/// A peer connected to the host's signaling server.
class ServerPeer {
  ServerPeer({required this.id, required this.name, required this.socket});

  final String id;
  final String name;
  final WebSocket socket;
}

/// Roster change emitted by the [SignalingServer].
@immutable
class RosterEvent {
  const RosterEvent({required this.peerId, required this.name, required this.joined});

  final String peerId;
  final String name;

  /// True when the peer joined, false when it left.
  final bool joined;
}

/// The host-side signaling hub.
///
/// Runs a WebSocket server on the LAN. Joiners connect, send a [SignalType.hello]
/// with the session code, and get a peer id back. The server enforces the
/// session [code] and [capacity], routes `relay` frames between peers by id, and
/// notifies the host of roster changes so it can open WebRTC connections.
class SignalingServer {
  SignalingServer({required this.code, this.capacity = 3});

  /// The session code joiners must present in their `hello`. Mutable so the host
  /// can finalize it once the server's port (and thus the full code) is known.
  String code;

  /// Maximum simultaneous joiners (excludes the host itself).
  final int capacity;

  HttpServer? _http;
  final Map<String, ServerPeer> _peers = {};
  var _nextId = 1;

  final _rosterController = StreamController<RosterEvent>.broadcast();
  final _relayController = StreamController<({String from, Map<String, dynamic> payload})>.broadcast();

  /// Emitted when a joiner connects or disconnects.
  Stream<RosterEvent> get onRoster => _rosterController.stream;

  /// Emitted when a peer relays a WebRTC payload addressed to the host.
  Stream<({String from, Map<String, dynamic> payload})> get onRelayToHost =>
      _relayController.stream;

  /// The port the server bound to, once [start] completes.
  int get port => _http?.port ?? 0;

  /// The host's own peer id (fixed) so WebRTC has a stable identity.
  static const hostId = 'host';

  /// Binds to [port] (0 = OS-assigned) on all interfaces and starts listening.
  Future<int> start({int port = 0}) async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    _http = server;
    server.transform(WebSocketTransformer()).listen(_onSocket);
    return server.port;
  }

  Future<void> _onSocket(WebSocket socket) async {
    String? peerId;
    socket.listen(
      (data) => _onMessage(socket, data as String, assignId: (id) => peerId = id, currentId: () => peerId),
      onDone: () => _dropPeer(peerId),
      onError: (_) => _dropPeer(peerId),
      cancelOnError: true,
    );
  }

  void _onMessage(
    WebSocket socket,
    String raw, {
    required void Function(String) assignId,
    required String? Function() currentId,
  }) {
    final Map<String, dynamic> msg;
    try {
      msg = SignalFrame.decode(raw);
    } catch (_) {
      return;
    }

    switch (msg.type) {
      case SignalType.hello:
        if (msg['code'] != code) {
          socket.add({'type': SignalType.rejected, 'reason': 'bad-code'}.encode());
          socket.close();
          return;
        }
        if (_peers.length >= capacity) {
          socket.add({'type': SignalType.rejected, 'reason': 'full'}.encode());
          socket.close();
          return;
        }
        final id = 'peer-${_nextId++}';
        assignId(id);
        final name = (msg['name'] as String?) ?? 'Guest';
        _peers[id] = ServerPeer(id: id, name: name, socket: socket);

        // Tell the newcomer its id and the existing roster (host + peers).
        socket.add({
          'type': SignalType.welcome,
          'peerId': id,
          'hostId': hostId,
          'roster': [
            {'id': hostId, 'name': 'Host'},
            for (final p in _peers.values)
              if (p.id != id) {'id': p.id, 'name': p.name},
          ],
        }.encode());

        // Announce to everyone else.
        _broadcast(
          {'type': SignalType.peerJoined, 'peerId': id, 'name': name},
          except: id,
        );
        _rosterController.add(RosterEvent(peerId: id, name: name, joined: true));

      case SignalType.relay:
        final to = msg['to'] as String?;
        final payload = msg['payload'] as Map<String, dynamic>?;
        final from = currentId();
        if (to == null || payload == null || from == null) return;
        if (to == hostId) {
          _relayController.add((from: from, payload: payload));
        } else {
          _peers[to]?.socket.add(
                {'type': SignalType.relay, 'from': from, 'payload': payload}.encode(),
              );
        }
    }
  }

  /// Sends a WebRTC payload from the host to [peerId].
  void relayFromHost(String peerId, Map<String, dynamic> payload) {
    _peers[peerId]?.socket.add(
          {'type': SignalType.relay, 'from': hostId, 'payload': payload}.encode(),
        );
  }

  void _dropPeer(String? peerId) {
    if (peerId == null) return;
    final peer = _peers.remove(peerId);
    if (peer == null) return;
    _broadcast({'type': SignalType.peerLeft, 'peerId': peerId});
    _rosterController.add(RosterEvent(peerId: peerId, name: peer.name, joined: false));
  }

  void _broadcast(Map<String, dynamic> msg, {String? except}) {
    final encoded = msg.encode();
    for (final peer in _peers.values) {
      if (peer.id == except) continue;
      peer.socket.add(encoded);
    }
  }

  /// Current joiner count (excludes the host).
  int get peerCount => _peers.length;

  Future<void> stop() async {
    for (final peer in _peers.values) {
      await peer.socket.close();
    }
    _peers.clear();
    await _http?.close(force: true);
    _http = null;
    await _rosterController.close();
    await _relayController.close();
  }
}
