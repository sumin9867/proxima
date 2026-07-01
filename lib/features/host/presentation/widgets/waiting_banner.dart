import 'package:flutter/material.dart';

import 'package:local_voice_call/core/theme/app_colors.dart';

/// Pulsing "Waiting for others to join..." banner shown while hosting.
class WaitingBanner extends StatefulWidget {
  const WaitingBanner({super.key});

  @override
  State<WaitingBanner> createState() => _WaitingBannerState();
}

class _WaitingBannerState extends State<WaitingBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  late final Animation<double> _opacity =
      Tween<double>(begin: 1, end: 0.3).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          FadeTransition(
            opacity: _opacity,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Waiting for others to join...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
