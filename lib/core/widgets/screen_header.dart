import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The compact back-button + title header used on the host and join screens.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      child: Row(
        children: [
          Material(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(10),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(Icons.chevron_left_rounded,
                    size: 24, color: AppColors.textPrimary),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
