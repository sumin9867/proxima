import 'package:flutter/material.dart';

import 'package:local_voice_call/core/theme/app_colors.dart';

/// The large two-line call-to-action tiles on the home screen. A [filled] tile
/// is the solid primary button ("Start Call"); an outlined tile is the tinted
/// secondary ("Join Call").
class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.filled,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool filled;

  /// Builds the leading icon in the correct tint for the tile variant.
  final Widget Function(Color color) icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? Colors.white : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 62,
          decoration: BoxDecoration(
            color: filled ? AppColors.primary : AppColors.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(18),
            border: filled
                ? null
                : Border.all(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    width: 1.5,
                  ),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      blurRadius: 28,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon(foreground),
              const SizedBox(width: 14),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: foreground,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: foreground.withValues(alpha: filled ? 0.65 : 0.55),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
