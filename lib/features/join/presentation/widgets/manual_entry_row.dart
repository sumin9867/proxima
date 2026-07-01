import 'package:flutter/material.dart';

import 'package:local_voice_call/core/theme/app_colors.dart';

/// The "Enter code manually" fallback row beneath the scan results.
class ManualEntryRow extends StatelessWidget {
  const ManualEntryRow({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceSubtle,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.textPrimary.withValues(alpha: 0.06),
                ),
                child: Icon(Icons.grid_view_rounded,
                    size: 18, color: AppColors.textPrimary.withValues(alpha: 0.35)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Enter code manually',
                  style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppColors.textPrimary.withValues(alpha: 0.18)),
            ],
          ),
        ),
      ),
    );
  }
}
