import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';

/// Resolves this device's address on the local network.
abstract final class LocalNetwork {
  /// Returns the device's Wi-Fi IPv4 address (e.g. `192.168.1.42`).
  ///
  /// Falls back to scanning network interfaces if the platform Wi-Fi API is
  /// unavailable (desktop, or when location permission isn't granted).
  static Future<String?> wifiIp() async {
    try {
      final ip = await NetworkInfo().getWifiIP();
      if (ip != null && ip.isNotEmpty && ip != '0.0.0.0') return ip;
    } catch (_) {
      // Fall through to interface scan.
    }
    return _firstPrivateIpv4();
  }

  static Future<String?> _firstPrivateIpv4() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (_isPrivate(addr.address)) return addr.address;
        }
      }
    } catch (_) {
      // No usable interface.
    }
    return null;
  }

  static bool _isPrivate(String ip) =>
      ip.startsWith('192.168.') ||
      ip.startsWith('10.') ||
      RegExp(r'^172\.(1[6-9]|2\d|3[01])\.').hasMatch(ip);
}
