import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_voice_call/models/session_code.dart';

void main() {
  group('SessionCode', () {
    test('normalized strips the middot and upper-cases', () {
      const c = SessionCode(code: 'xk·4729', host: '192.168.1.5', port: 8080);
      expect(c.normalized, 'XK4729');
    });

    test('qrPayload round-trips through tryParseQr', () {
      const original =
          SessionCode(code: 'XK·4729', host: '192.168.1.5', port: 8080);
      final parsed = SessionCode.tryParseQr(original.qrPayload);

      expect(parsed, isNotNull);
      expect(parsed!.normalized, 'XK4729');
      expect(parsed.host, '192.168.1.5');
      expect(parsed.port, 8080);
      // The parsed code is re-formatted with the middot separator.
      expect(parsed.code, 'XK·4729');
    });

    test('tryParseQr rejects non-Proxima links', () {
      expect(SessionCode.tryParseQr('https://example.com'), isNull);
      expect(SessionCode.tryParseQr('proxima://join?c=AB'), isNull); // no host/port
      expect(SessionCode.tryParseQr('not a uri at all !!'), isNull);
    });

    test('generate produces a two-letter · four-digit code', () {
      final c = SessionCode.generate(
        host: '10.0.0.2',
        port: 5000,
        random: Random(42),
      );
      expect(RegExp(r'^[A-Z]{2}·\d{4}$').hasMatch(c.code), isTrue);
      expect(c.host, '10.0.0.2');
      expect(c.port, 5000);
    });
  });
}
