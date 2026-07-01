import 'dart:convert';

/// Wire protocol for Proxima's LAN signaling.
///
/// Every frame is a JSON object with a [type]. Control frames (`welcome`,
/// `peer-joined`, `peer-left`) manage the roster; `relay` frames carry opaque
/// WebRTC payloads (offer/answer/ice) between two peers, routed by the host.
abstract final class SignalType {
  /// Client → server, first frame: announces the joiner's display name + code.
  static const hello = 'hello';

  /// Server → client: assigns the client its peer id and current roster.
  static const welcome = 'welcome';

  /// Server → clients: a new peer joined (broadcast).
  static const peerJoined = 'peer-joined';

  /// Server → clients: a peer left (broadcast).
  static const peerLeft = 'peer-left';

  /// Either direction: a WebRTC payload addressed to another peer, routed by id.
  static const relay = 'relay';

  /// Server → client: the session is full or the code was wrong.
  static const rejected = 'rejected';
}

/// A parsed signaling frame with convenient accessors.
extension SignalFrame on Map<String, dynamic> {
  String? get type => this['type'] as String?;

  static Map<String, dynamic> decode(String raw) =>
      jsonDecode(raw) as Map<String, dynamic>;

  String encode() => jsonEncode(this);
}
