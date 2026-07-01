import 'package:flutter/material.dart';

import 'package:local_voice_call/core/theme/app_colors.dart';
import 'package:local_voice_call/core/widgets/proxima_logo.dart';
import 'package:local_voice_call/core/widgets/pulse_rings.dart';
import 'package:local_voice_call/core/widgets/typing_dots.dart';

/// The scanning card on the join screen: a Proxima signal glyph surrounded by
/// outward-sweeping radar rings, with a "Scanning…" label.
class ScanRadar extends StatelessWidget {
  const ScanRadar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sweep rings, centered behind the glyph.
          PulseRings(
            size: 80,
            color: AppColors.primary.withValues(alpha: 0.45),
            minScale: 0.45,
            maxScale: 2.3,
            startOpacity: 0.85,
            borderWidth: 1.5,
            duration: const Duration(milliseconds: 2400),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: const ProximaLogo(size: 20, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Scanning',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 4),
                  const TypingDots(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
