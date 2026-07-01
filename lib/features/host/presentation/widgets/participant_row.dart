import 'package:flutter/material.dart';

import 'package:local_voice_call/core/theme/app_colors.dart';

/// A dashed placeholder row for a not-yet-filled participant slot.
class EmptyParticipantSlot extends StatelessWidget {
  const EmptyParticipantSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.textPrimary.withValues(alpha: 0.04),
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Icon(Icons.add_rounded,
                size: 16, color: AppColors.textPrimary.withValues(alpha: 0.2)),
          ),
          const SizedBox(width: 12),
          const Text(
            'Waiting for someone...',
            style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
