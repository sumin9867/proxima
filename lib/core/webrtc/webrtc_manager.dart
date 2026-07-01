import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// A remote peer's media, surfaced to the UI.
@immutable
class RemotePeerStream {
  const RemotePeerStream({required this.peerId, required this.stream});

  final String peerId;
  final MediaStream stream;
}

/// Signaling messages this manager needs relayed to a specific peer. The
/// signaling layer (server or client) is responsible for delivery; the manager
/// stays transport-agnostic.
typedef SignalSink = void Function(String peerId, Map<String, dynamic> message);

/// Owns the WebRTC media pipeline for a call: one local [MediaStream] shared to
/// every peer, and one [RTCPeerConnection] per remote participant.
///
/// It does not know how signaling is delivered — it calls [onSignal] to emit
/// offers/answers/ICE for a peer and expects [handleSignal] to be called with
/// the peer's replies.
class WebRtcManager {
  WebRtcManager({required this.onSignal, this.iceServers = const []});

  /// Called when this manager produces a signaling message for [peerId].
  final SignalSink onSignal;

  /// STUN/TURN servers. Empty for pure-LAN calls (host candidates only).
  final List<Map<String, dynamic>> iceServers;

  final Map<String, RTCPeerConnection> _peers = {};
  // ICE candidates that arrived before the peer's remote description was set.
  // Adding a candidate before setRemoteDescription throws / is dropped, so we
  // queue them and flush once the remote description is applied.
  final Map<String, List<RTCIceCandidate>> _pendingCandidates = {};
  final Set<String> _remoteDescriptionSet = {};
  MediaStream? _localStream;

  final _remoteStreamsController =
      StreamController<RemotePeerStream>.broadcast();
  final _peerLeftController = StreamController<String>.broadcast();

  /// Emits each remote peer's media as it arrives.
  Stream<RemotePeerStream> get onRemoteStream =>
      _remoteStreamsController.stream;

  /// Emits a peer id whenever that peer disconnects.
  Stream<String> get onPeerLeft => _peerLeftController.stream;

  MediaStream? get localStream => _localStream;

  Map<String, dynamic> get _config => {
        'iceServers': iceServers,
        'sdpSemantics': 'unified-plan',
      };

  /// Acquires mic (+ camera when [video]) and returns the local stream.
  Future<MediaStream> initLocalMedia({required bool video}) async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': video
          ? {
              'facingMode': 'user',
              // Prefer a small, widely supported capture format to keep video
              // bandwidth and processing cost down on mobile devices.
              'width': {'ideal': 640},
              'height': {'ideal': 480},
              'frameRate': {'ideal': 15},
            }
          : false,
    });
    return _localStream!;
  }

  /// Creates a peer connection for [peerId]. When [initiator] is true this side
  /// creates and sends the offer; otherwise it waits for one.
  Future<void> connectPeer(String peerId, {required bool initiator}) async {
    if (_peers.containsKey(peerId)) return;

    final pc = await createPeerConnection(_config);
    _peers[peerId] = pc;

    // Publish local tracks.
    final local = _localStream;
    if (local != null) {
      for (final track in local.getTracks()) {
        await pc.addTrack(track, local);
      }
    }

    pc.onIceCandidate = (candidate) {
      onSignal(peerId, {
        'type': 'ice',
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    pc.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        _remoteStreamsController
            .add(RemotePeerStream(peerId: peerId, stream: event.streams.first));
      }
    };

    pc.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateClosed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        _peerLeftController.add(peerId);
      }
    };

    if (initiator) {
      final offer = await pc.createOffer();
      await pc.setLocalDescription(offer); 
      onSignal(peerId, {'type': 'offer', 'sdp': offer.sdp});
    }
  }

  /// Feeds a signaling message received from [peerId] into its connection.
  Future<void> handleSignal(String peerId, Map<String, dynamic> message) async {
    final pc = _peers[peerId];
    switch (message['type']) {
      case 'offer':
        final peer = pc ?? await _lazyPeer(peerId);
        await peer.setRemoteDescription(
          RTCSessionDescription(message['sdp'] as String, 'offer'),
        );
        await _onRemoteDescriptionSet(peerId, peer);
        final answer = await peer.createAnswer();
        await peer.setLocalDescription(answer);
        onSignal(peerId, {'type': 'answer', 'sdp': answer.sdp});
      case 'answer':
        if (pc == null) return;
        await pc.setRemoteDescription(
          RTCSessionDescription(message['sdp'] as String, 'answer'),
        );
        await _onRemoteDescriptionSet(peerId, pc);
      case 'ice':
        final candidate = RTCIceCandidate(
          message['candidate'] as String?,
          message['sdpMid'] as String?,
          message['sdpMLineIndex'] as int?,
        );
        // If the remote description isn't in place yet, the candidate would be
        // dropped — buffer it and flush after setRemoteDescription.
        if (pc == null || !_remoteDescriptionSet.contains(peerId)) {
          (_pendingCandidates[peerId] ??= []).add(candidate);
        } else {
          await pc.addCandidate(candidate);
        }
    }
  }

  /// Marks the peer's remote description as applied and drains any ICE
  /// candidates that arrived early.
  Future<void> _onRemoteDescriptionSet(
    String peerId,
    RTCPeerConnection pc,
  ) async {
    _remoteDescriptionSet.add(peerId);
    final pending = _pendingCandidates.remove(peerId);
    if (pending != null) {
      for (final candidate in pending) {
        await pc.addCandidate(candidate);
      }
    }
  }

  Future<RTCPeerConnection> _lazyPeer(String peerId) async {
    await connectPeer(peerId, initiator: false);
    return _peers[peerId]!;
  }

  /// Toggles the local microphone track. Returns the new enabled state.
  bool setMicEnabled(bool enabled) {
    for (final track in _localStream?.getAudioTracks() ?? const []) {
      track.enabled = enabled;
    }
    return enabled;
  }

  /// Toggles the local camera track. Returns the new enabled state.
  bool setCameraEnabled(bool enabled) {
    for (final track in _localStream?.getVideoTracks() ?? const []) {
      track.enabled = enabled;
    }
    return enabled;
  }

  /// Switches between front and rear cameras.
  Future<void> switchCamera() async {
    final videoTrack = _localStream?.getVideoTracks().firstOrNull;
    if (videoTrack != null) {
      await Helper.switchCamera(videoTrack);
    }
  }

  /// Tears down a single peer (e.g. when it leaves the session).
  Future<void> removePeer(String peerId) async {
    final pc = _peers.remove(peerId);
    _pendingCandidates.remove(peerId);
    _remoteDescriptionSet.remove(peerId);
    await pc?.close();
  }

  /// Closes every connection and releases the local media.
  Future<void> dispose() async {
    for (final pc in _peers.values) {
      await pc.close();
    }
    _peers.clear();
    _pendingCandidates.clear();
    _remoteDescriptionSet.clear();
    for (final track in _localStream?.getTracks() ?? const []) {
      await track.stop();
    }
    await _localStream?.dispose();
    _localStream = null;
    await _remoteStreamsController.close();
    await _peerLeftController.close();
  }
}
