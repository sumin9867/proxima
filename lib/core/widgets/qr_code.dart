import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A decorative QR-style graphic for the session code card.
///
/// This is not a functional QR encoder — it reproduces the finder patterns and
/// module layout from the reference artwork so the card reads as a scannable
/// code. [color] tints the modules; the quiet zone stays light.
class QrCodeGraphic extends StatelessWidget {
  const QrCodeGraphic({super.key, this.size = 96, this.color = AppColors.primary});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6 * size / 96),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _QrPainter(color)),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.color);

  final Color color;

  // Fixed data modules (x, y) in the original 96px module grid, taken directly
  // from the reference SVG so the pattern is stable frame-to-frame.
  static const List<(double, double)> _modules = [
    (37, 7), (45, 7), (53, 7), (61, 7),
    (37, 15), (53, 15),
    (45, 23),
    (7, 37), (15, 37), (23, 37),
    (7, 53),
    (37, 37), (53, 37), (61, 37),
    (37, 45),
    (45, 53),
    (67, 37), (75, 37), (83, 37),
    (75, 45),
    (67, 53),
    (37, 67), (53, 67),
    (45, 75), (61, 75),
    (37, 83), (53, 83),
    (67, 67), (75, 67), (83, 67),
    (67, 83), (83, 83),
    (75, 75),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 96;
    canvas.scale(scale);

    final light = Paint()..color = const Color(0xFFF0F0F0);
    final dark = Paint()..color = color;

    // Quiet background.
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, 96, 96), const Radius.circular(5)),
      light,
    );

    // Three finder patterns (top-left, top-right, bottom-left).
    void finder(double x, double y) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 22, 22), const Radius.circular(3)),
        dark,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x + 4, y + 4, 14, 14), const Radius.circular(1.5)),
        light,
      );
      canvas.drawRect(Rect.fromLTWH(x + 7, y + 7, 8, 8), dark);
    }

    finder(7, 7);
    finder(67, 7);
    finder(7, 67);

    // Data modules.
    for (final (x, y) in _modules) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 5, 5), const Radius.circular(1)),
        dark,
      );
    }
  }

  @override
  bool shouldRepaint(_QrPainter oldDelegate) => oldDelegate.color != color;
}
