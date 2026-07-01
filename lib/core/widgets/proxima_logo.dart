import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The Proxima "signal" mark: concentric broadcast arcs radiating from a dot.
///
/// Rendered from the same geometry as the reference SVG so it scales crisply at
/// any [size]. Use [color] to tint the arcs (defaults to white for use on the
/// gradient badge).
class ProximaLogo extends StatelessWidget {
  const ProximaLogo({super.key, this.size = 24, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      // The source artwork has a 24:20 aspect ratio.
      height: size * 20 / 24,
      child: CustomPaint(painter: _ProximaLogoPainter(color)),
    );
  }
}

class _ProximaLogoPainter extends CustomPainter {
  _ProximaLogoPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Work in the original 24x20 coordinate space, then scale to fit.
    final sx = size.width / 24;
    final sy = size.height / 20;
    canvas.scale(sx, sy);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Emitter dot.
    canvas.drawCircle(
      const Offset(12, 16),
      2.4,
      Paint()..color = color,
    );

    // Inner arc.
    stroke.strokeWidth = 2.2;
    stroke.color = color;
    canvas.drawPath(
      Path()
        ..moveTo(7, 12)
        ..relativeCubicTo(1.3, -1.3, 3, -2, 5, -2)
        ..relativeCubicTo(2, 0, 3.7, 0.7, 5, 2),
      stroke,
    );

    // Middle arc (slightly transparent).
    stroke.color = color.withValues(alpha: 0.7);
    canvas.drawPath(
      Path()
        ..moveTo(3, 8)
        ..relativeCubicTo(2.4, -2.4, 5.8, -3.9, 9, -3.9)
        ..relativeCubicTo(3.2, 0, 6.6, 1.5, 9, 3.9),
      stroke,
    );

    // Outer arc (most transparent, thinnest).
    stroke.strokeWidth = 1.8;
    stroke.color = color.withValues(alpha: 0.4);
    canvas.drawPath(
      Path()
        ..moveTo(0, 4)
        ..cubicTo(3, 1.5, 7.3, 0, 12, 0)
        ..relativeCubicTo(4.7, 0, 9, 1.5, 12, 4),
      stroke,
    );
  }

  @override
  bool shouldRepaint(_ProximaLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// The rounded-square gradient badge that houses the [ProximaLogo] on the home
/// and launch surfaces.
class ProximaLogoBadge extends StatelessWidget {
  const ProximaLogoBadge({
    super.key,
    this.size = 88,
    this.borderRadius = 26,
    this.logoSize = 46,
  });

  final double size;
  final double borderRadius;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: ProximaLogo(size: logoSize),
    );
  }
}
