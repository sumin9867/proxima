import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A host beacon seen on the local network.
@immutable
class DiscoveredHost {
  const DiscoveredHost({
    required this.code,
    required this.host,
    required this.port,
    required this.hostName,
    required this.seenAt,
  });

  final String code;
  final String host;
  final int port;
  final String hostName;
  final DateTime seenAt;

  DiscoveredHost copyWith({DateTime? seenAt}) => DiscoveredHost(
        code: code,
        host: host,
        port: port,
        hostName: hostName,
        seenAt: seenAt ?? this.seenAt,
      );
}

/// UDP-multicast presence for Proxima sessions.
///
/// A host calls [advertise] to broadcast a beacon every second so nearby
/// devices can discover it without any typing. A joiner calls [discover] to
/// listen; the [onHosts] stream emits the current set of live hosts, pruned
/// when a host stops beaconing.
class DiscoveryService {
  DiscoveryService();

  static final InternetAddress _group = InternetAddress('239.72.114.120'); // 239.P.r.x
  static final InternetAddress _broadcast = InternetAddress('255.255.255.255');
  static const int _multicastPort = 47120;
  static const Duration _beaconInterval = Duration(seconds: 1);
  static const Duration _staleAfter = Duration(seconds: 4);

  /// Native channel to hold a Wi-Fi MulticastLock while advertising/discovering.
  /// Without it Android silently drops incoming multicast/broadcast datagrams.
  static const _lockChannel = MethodChannel('proxima/multicast');

  static Future<void> _acquireLock() async {
    try {
      await _lockChannel.invokeMethod<bool>('acquire');
    } on PlatformException {
      // Non-Android platforms have no channel handler; ignore.
    } on MissingPluginException {
      // Ignore.
    }
  }

  static Future<void> _releaseLock() async {
    try {
      await _lockChannel.invokeMethod<bool>('release');
    } on PlatformException {
      // Ignore.
    } on MissingPluginException {
      // Ignore.
    }
  }

  RawDatagramSocket? _advertiseSocket;
  RawDatagramSocket? _discoverSocket;
  Timer? _beaconTimer;
  Timer? _pruneTimer;

  final Map<String, DiscoveredHost> _hosts = {};
  final _hostsController = StreamController<List<DiscoveredHost>>.broadcast();

  /// Emits the live set of discovered hosts whenever it changes.
  Stream<List<DiscoveredHost>> get onHosts => _hostsController.stream;

  /// Starts broadcasting a beacon for this host.
  Future<void> advertise({
    required String code,
    required String host,
    required int port,
    required String hostName,
  }) async {
    await _acquireLock();
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true;
    _advertiseSocket = socket;
    final payload = utf8.encode(jsonEncode({
      'code': code,
      'host': host,
      'port': port,
      'name': hostName,
    }));

    void send() {
      // Send to both the multicast group and the subnet broadcast address.
      // Multicast is cleaner on infrastructure Wi-Fi, but many phone hotspots
      // don't forward it between clients — broadcast usually still works there.
      try {
        socket.send(payload, _group, _multicastPort);
      } catch (_) {
        // A transient send failure (e.g. interface change) is non-fatal.
      }
      try {
        socket.send(payload, _broadcast, _multicastPort);
      } catch (_) {
        // Ignore; multicast may still have gone through.
      }
    }

    send();
    _beaconTimer = Timer.periodic(_beaconInterval, (_) => send());
  }

  /// Starts listening for host beacons.
  Future<void> discover() async {
    await _acquireLock();
    final socket =
        await RawDatagramSocket.bind(InternetAddress.anyIPv4, _multicastPort, reuseAddress: true);
    socket.broadcastEnabled = true;
    _discoverSocket = socket;
    try {
      socket.joinMulticast(_group);
    } catch (_) {
      // Some networks/emulators disallow multicast; broadcast beacons still work.
    }

    socket.listen((event) {
      if (event != RawSocketEvent.read) return;
      final datagram = socket.receive();
      if (datagram == null) return;
      _onBeacon(datagram.data);
    });

    _pruneTimer = Timer.periodic(const Duration(seconds: 1), (_) => _prune());
  }

  void _onBeacon(List<int> data) {
    try {
      final map = jsonDecode(utf8.decode(data)) as Map<String, dynamic>;
      final code = map['code'] as String;
      final host = DiscoveredHost(
        code: code,
        host: map['host'] as String,
        port: map['port'] as int,
        hostName: (map['name'] as String?) ?? 'Host',
        seenAt: DateTime.now(),
      );
      _hosts[code] = host;
      _emit();
    } catch (_) {
      // Ignore malformed beacons.
    }
  }

  void _prune() {
    final now = DateTime.now();
    final before = _hosts.length;
    _hosts.removeWhere((_, h) => now.difference(h.seenAt) > _staleAfter);
    if (_hosts.length != before) _emit();
  }

  /// Resolves a typed session code to a discovered host, if one is beaconing.
  DiscoveredHost? resolve(String normalizedCode) {
    for (final host in _hosts.values) {
      if (host.code.replaceAll('·', '').toUpperCase() == normalizedCode) {
        return host;
      }
    }
    return null;
  }

  void _emit() {
    final list = _hosts.values.toList()
      ..sort((a, b) => a.hostName.compareTo(b.hostName));
    _hostsController.add(list);
  }

  Future<void> stopAdvertising() async {
    _beaconTimer?.cancel();
    _beaconTimer = null;
    _advertiseSocket?.close();
    _advertiseSocket = null;
    await _releaseLockIfIdle();
  }

  Future<void> stopDiscovery() async {
    _pruneTimer?.cancel();
    _pruneTimer = null;
    _discoverSocket?.close();
    _discoverSocket = null;
    _hosts.clear();
    await _releaseLockIfIdle();
  }

  /// Releases the multicast lock only once neither socket is active.
  Future<void> _releaseLockIfIdle() async {
    if (_advertiseSocket == null && _discoverSocket == null) {
      await _releaseLock();
    }
  }

  Future<void> dispose() async {
    await stopAdvertising();
    await stopDiscovery();
    await _hostsController.close();
  }
}
