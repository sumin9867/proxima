import 'package:flutter/material.dart';

/// Concentric rings that expand and fade outward from a center point — the
/// "active speaker" halo on the voice call and the radar sweep on the join
/// screen.
///
/// Two rings animate on the same loop, offset in phase, so the effect reads as
/// a continuous pulse. [minScale]/[maxScale] and [duration] map directly to the
/// reference CSS keyframes (`pulseRing` and `scanRing`).
class PulseRings extends StatefulWidget {
  const PulseRings({
    super.key,
    required this.size,
    required this.color,
    this.minScale = 1.0,
    this.maxScale = 1.75,
    this.startOpacity = 0.65,
    this.borderWidth = 2,
    this.duration = const Duration(milliseconds: 1800),
    this.child,
  });

  final double size;
  final Color color;
  final double minScale;
  final double maxScale;
  final double startOpacity;
  final double borderWidth;
  final Duration duration;
  final Widget? child;

  @override
  State<PulseRings> createState() => _PulseRingsState();
}

class _PulseRingsState extends State<PulseRings>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _ring(phase: 0),
          _ring(phase: 0.5),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }

  Widget _ring({required double phase}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = (_controller.value + phase) % 1.0;
        final scale = widget.minScale + (widget.maxScale - widget.minScale) * t;
        final opacity = (widget.startOpacity * (1 - t)).clamp(0.0, 1.0);
        return Transform.scale(
          scale: scale,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: widget.color, width: widget.borderWidth),
        ),
      ),
    );
  }
}
