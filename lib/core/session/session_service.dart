import 'dart:developer' as developer;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:local_voice_call/core/discovery/discovery_service.dart';
import 'package:local_voice_call/core/network/network_info.dart';
import 'package:local_voice_call/core/signaling/signaling_client.dart';
import 'package:local_voice_call/core/signaling/signaling_server.dart';
import 'package:local_voice_call/core/webrtc/webrtc_manager.dart';
import 'package:local_voice_call/models/session_code.dart';

/// A live participant in the current session, as tracked by [SessionService].
@immutable
class LiveParticipant {
  const LiveParticipant({
    required this.id,
    required this.name,
    this.renderer,
    this.isSelf = false,
  });

  final String id;
  final String name;

  /// Renderer holding this peer's remote media (null for self / before media).
  final RTCVideoRenderer? renderer;
  final bool isSelf;

  LiveParticipant copyWith({RTCVideoRenderer? renderer}) => LiveParticipant(
    id: id,
    name: name,
    renderer: renderer ?? this.renderer,
    isSelf: isSelf,
  );
}

/// Orchestrates one Proxima session end-to-end: LAN signaling (as host or
/// joiner), WebRTC media, and — for hosts — multicast advertising.
///
/// The cubits talk only to this service. It surfaces the [sessionCode] to show,
/// a live [participants] stream, and the [localRenderer] for the self view.
class SessionService {
  SessionService({required this.displayName, required this.video});

  final String displayName;
  final bool video;

  final _discovery = DiscoveryService();
  SignalingServer? _server;
  SignalingClient? _client;
  WebRtcManager? _rtc;

  final localRenderer = RTCVideoRenderer();
  // True once localRenderer.initialize() has completed. Disposing a renderer
  // that was never initialized crashes natively (null Surface), which happens
  // when a call is cancelled before it connects.
  bool _localRendererInitialized = false;
  SessionCode? _sessionCode;

  /// The map of peer id → participant. Self is keyed by [_selfId].
  final Map<String, LiveParticipant> _participants = {};
  final _participantsController =
      StreamController<List<LiveParticipant>>.broadcast();

  String _selfId = 'self';

  /// The code to display/share (host only).
  SessionCode? get sessionCode => _sessionCode;

  /// Emits the live roster (self first) whenever it changes.
  Stream<List<LiveParticipant>> get participants =>
      _participantsController.stream;

  void _log(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'SessionService',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // ---- Hosting -------------------------------------------------------------

  /// Starts hosting: acquires media, starts the signaling server, and begins
  /// advertising. Returns the [SessionCode] to display.
  Future<SessionCode> startHosting() async {
    _log('startHosting() starting for $displayName, video=$video');
    await _initLocalRenderer();

    final ip = await LocalNetwork.wifiIp() ?? '127.0.0.1';

    // Bind on an OS-assigned port, then generate the code that embeds it.
    final server = SignalingServer(code: '');
    final port = await server.start();
    final code = SessionCode.generate(host: ip, port: port);
    server.code = code.normalized;
    _server = server;
    _sessionCode = code;

    _selfId = SignalingServer.hostId;
    _addSelf();

    _rtc = WebRtcManager(
      onSignal: (peerId, msg) => server.relayFromHost(peerId, msg),
    );
    await _rtc!.initLocalMedia(video: video);
    _rtc!.setCameraEnabled(false);
    localRenderer.srcObject = _rtc!.localStream;
    _wireRtcStreams();

    // Host reacts to roster + relayed payloads.
    server.onRoster.listen((event) async {
      if (event.joined) {
        _log('host roster joined: peerId=${event.peerId}, name=${event.name}');
        _participants[event.peerId] = LiveParticipant(
          id: event.peerId,
          name: event.name,
        );
        // Host initiates the WebRTC offer toward each new joiner.
        await _rtc!.connectPeer(event.peerId, initiator: true);
      } else {
        _log('host roster left: peerId=${event.peerId}');
        await _rtc!.removePeer(event.peerId);
        _removeParticipant(event.peerId);
      }
      _emit();
    });
    server.onRelayToHost.listen((event) {
      _rtc!.handleSignal(event.from, event.payload);
    });

    await _discovery.advertise(
      code: code.normalized,
      host: ip,
      port: port,
      hostName: displayName,
    );

    _emit();
    return code;
  }

  // ---- Joining -------------------------------------------------------------

  /// Joins a session at [target]. Returns the join outcome.
  Future<JoinResult> join(SessionCode target) async {
    _log('join() starting for ${target.normalized}, video=$video');
    await _initLocalRenderer();

    final client = SignalingClient(
      host: target.host,
      port: target.port,
      displayName: displayName,
    );
    _client = client;

    _rtc = WebRtcManager(onSignal: (peerId, msg) => client.relay(peerId, msg));
    await _rtc!.initLocalMedia(video: video);
    _rtc!.setCameraEnabled(false);
    localRenderer.srcObject = _rtc!.localStream;
    _wireRtcStreams();

    final outcome = await client.join(target.normalized);
    _log(
      'client.join() result=${outcome.result}, roster=${outcome.roster.length}',
    );
    if (outcome.result != JoinResult.connected) {
      return outcome.result;
    }

    _selfId = client.peerId ?? 'self';
    _addSelf();

    // Open a WebRTC connection to every existing member. The host creates the
    // offer for new peers, so the joiner must wait for that offer instead of
    // starting one itself.
    for (final member in outcome.roster) {
      _log('joining existing peer: peerId=${member.id}, name=${member.name}');
      _participants[member.id] = LiveParticipant(
        id: member.id,
        name: member.name,
      );
      await _rtc!.connectPeer(member.id, initiator: false);
    }

    client.onPeerJoined.listen((member) {
      _participants[member.id] = LiveParticipant(
        id: member.id,
        name: member.name,
      );
      // Newcomers offer to us; we answer, so no initiate here.
      _emit();
    });
    client.onPeerLeft.listen((id) async {
      await _rtc!.removePeer(id);
      _removeParticipant(id);
      _emit();
    });
    client.onRelay.listen((event) {
      _rtc!.handleSignal(event.from, event.payload);
    });

    _emit();
    return JoinResult.connected;
  }

  // ---- Shared --------------------------------------------------------------

  void _wireRtcStreams() {
    _rtc!.onRemoteStream.listen((remote) async {
      final existing = _participants[remote.peerId];
      final renderer = existing?.renderer ?? RTCVideoRenderer();
      if (existing?.renderer == null) await renderer.initialize();
      renderer.srcObject = remote.stream;
      _participants[remote.peerId] =
          (existing ?? LiveParticipant(id: remote.peerId, name: 'Guest'))
              .copyWith(renderer: renderer);
      _emit();
    });
    _rtc!.onPeerLeft.listen((id) {
      _removeParticipant(id);
      _emit();
    });
  }

  Future<void> _initLocalRenderer() async {
    if (_localRendererInitialized) return;
    await localRenderer.initialize();
    _localRendererInitialized = true;
  }

  void _addSelf() {
    _participants[_selfId] = LiveParticipant(
      id: _selfId,
      name: 'You',
      renderer: localRenderer,
      isSelf: true,
    );
  }

  void _removeParticipant(String id) {
    final removed = _participants.remove(id);
    if (removed != null && !removed.isSelf) {
      removed.renderer?.dispose();
    }
  }

  void _emit() {
    final list = _participants.values.toList()
      ..sort((a, b) {
        if (a.isSelf) return 1; // self last (matches the design's ordering)
        if (b.isSelf) return -1;
        return a.name.compareTo(b.name);
      });
    _participantsController.add(list);
  }

  // ---- Controls ------------------------------------------------------------

  bool setMic(bool enabled) => _rtc?.setMicEnabled(enabled) ?? enabled;
  bool setCamera(bool enabled) => _rtc?.setCameraEnabled(enabled) ?? enabled;
  Future<void> switchCamera() async => _rtc?.switchCamera();

  Future<void> dispose() async {
    await _discovery.dispose();
    await _server?.stop();
    await _client?.dispose();
    await _rtc?.dispose();
    for (final p in _participants.values) {
      if (!p.isSelf) p.renderer?.dispose();
    }
    _participants.clear();
    // Only dispose the renderer if it was actually initialized; disposing an
    // uninitialized renderer crashes natively (null Surface) when a call is
    // cancelled before connecting.
    if (_localRendererInitialized) {
      await localRenderer.dispose();
      _localRendererInitialized = false;
    }
    await _participantsController.close();
  }
}
