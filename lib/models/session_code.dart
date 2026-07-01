import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_code.freezed.dart';

/// A joinable session's connection details: the short human code plus the host
/// device's LAN address for signaling.
@freezed
abstract class SessionCode with _$SessionCode {
  const SessionCode._();

  const factory SessionCode({
    required String code,
    required String host,
    required int port,
  }) = _SessionCode;

  /// The token without its middot separator (`XK4729`).
  String get normalized => code.replaceAll('·', '').toUpperCase();

  /// Deep link encoding the full connection info for the QR graphic.
  String get qrPayload => 'proxima://join?c=$normalized&h=$host&p=$port';

  /// Parses a scanned QR payload back into a [SessionCode], or null if invalid.
  static SessionCode? tryParseQr(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || uri.scheme != 'proxima' || uri.host != 'join') {
      return null;
    }
    final code = uri.queryParameters['c'];
    final host = uri.queryParameters['h'];
    final port = int.tryParse(uri.queryParameters['p'] ?? '');
    if (code == null || host == null || port == null) return null;
    return SessionCode(code: _format(code), host: host, port: port);
  }

  /// Generates a fresh random code for a host at [host]:[port].
  factory SessionCode.generate({
    required String host,
    required int port,
    Random? random,
  }) {
    final rng = random ?? Random.secure();
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    final l1 = letters[rng.nextInt(letters.length)];
    final l2 = letters[rng.nextInt(letters.length)];
    final digits = (rng.nextInt(9000) + 1000).toString();
    return SessionCode(code: '$l1$l2·$digits', host: host, port: port);
  }

  static String _format(String raw) {
    final t = raw.toUpperCase().replaceAll('·', '');
    if (t.length <= 2) return t;
    return '${t.substring(0, 2)}·${t.substring(2)}';
  }
}
