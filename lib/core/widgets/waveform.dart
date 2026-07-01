import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// An animated voice-activity waveform: a row of vertical bars that scale up and
/// down on staggered loops, mirroring the `wBar` keyframes in the reference.
class Waveform extends StatefulWidget {
  const Waveform({
    super.key,
    this.color = AppColors.primary,
    this.barCount = 7,
    this.height = 36,
  });

  final Color color;
  final int barCount;
  final double height;

  @override
  State<Waveform> createState() => _WaveformState();
}

class _WaveformState extends State<Waveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  // Per-bar period (seconds) and phase offset, matched to the reference design.
  static const List<({double period, double delay})> _bars = [
    (period: 0.60, delay: 0.00),
    (period: 0.85, delay: 0.10),
    (period: 0.50, delay: 0.05),
    (period: 0.95, delay: 0.15),
    (period: 0.70, delay: 0.20),
    (period: 0.60, delay: 0.08),
    (period: 0.80, delay: 0.12),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < widget.barCount; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            _bar(_bars[i % _bars.length]),
          ],
        ],
      ),
    );
  }

  Widget _bar(({double period, double delay}) spec) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // The controller runs a 1s master loop; derive this bar's phase from it.
        final phase = ((_controller.value + spec.delay) / spec.period) % 1.0;
        // Sine ease: 0.15 -> 1.0 -> 0.15 over the period.
        final wave = 0.5 - 0.5 * math.cos(2 * math.pi * phase);
        final scaleY = 0.15 + 0.85 * wave;
        return Align(
          alignment: Alignment.bottomCenter,
          child: Transform.scale(
            scaleY: scaleY,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        );
      },
      child: Container(
        width: 4,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
