import 'package:flutter/material.dart';

import 'package:local_voice_call/core/theme/app_colors.dart';

/// Three small dots that flash in sequence — the "Scanning..." activity
/// indicator (the `dotFlash` keyframes in the reference).
class TypingDots extends StatefulWidget {
  const TypingDots({super.key, this.color = AppColors.primary, this.dotSize = 4});

  final Color color;
  final double dotSize;

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: 3),
          _dot(i * 0.25),
        ],
      ],
    );
  }

  Widget _dot(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = (_controller.value + delay) % 1.0;
        // Flash bright near the middle of the loop, faint otherwise.
        final opacity = t < 0.4 ? 0.15 + (1 - 0.15) * (t / 0.4) : 0.15;
        return Opacity(opacity: opacity.clamp(0.15, 1.0), child: child);
      },
      child: Container(
        width: widget.dotSize,
        height: widget.dotSize,
        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
      ),
    );
  }
}
