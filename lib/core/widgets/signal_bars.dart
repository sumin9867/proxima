import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Four ascending bars indicating connection strength, tinted by [color].
///
/// [filledBars] controls how many of the four bars are drawn in [color]; the
/// remainder are drawn faint. The reference "Good" state fills three of four.
class SignalBars extends StatelessWidget {
  const SignalBars({
    super.key,
    required this.color,
    this.filledBars = 4,
  });

  final Color color;
  final int filledBars;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 10,
      child: CustomPaint(painter: _SignalBarsPainter(color, filledBars)),
    );
  }
}

class _SignalBarsPainter extends CustomPainter {
  _SignalBarsPainter(this.color, this.filledBars);

  final Color color;
  final int filledBars;

  static const List<({double x, double y, double h})> _bars = [
    (x: 0, y: 7, h: 3),
    (x: 4, y: 5, h: 5),
    (x: 8, y: 2.5, h: 7.5),
    (x: 12, y: 0, h: 10),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < _bars.length; i++) {
      final bar = _bars[i];
      final paint = Paint()
        ..color = i < filledBars ? color : AppColors.textPrimary.withValues(alpha: 0.12);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(bar.x, bar.y, 2.5, bar.h),
          const Radius.circular(0.5),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SignalBarsPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filledBars != filledBars;
}
