import 'package:flutter/material.dart';

import 'package:local_voice_call/core/theme/app_colors.dart';

/// A circular in-call control (mute, camera, speaker, end).
///
/// [size] distinguishes the larger end-call button from the standard controls;
/// [background] and [iconRotation] let a single widget cover every control in
/// the call bar. Pass a [customIcon] when a Material icon doesn't match the
/// reference glyph.
class CallControlButton extends StatelessWidget {
  const CallControlButton({
    super.key,
    this.icon,
    this.customIcon,
    required this.onTap,
    this.size = 56,
    this.background = AppColors.controlSurface,
    this.iconColor = Colors.white,
    this.iconSize = 22,
    this.glow,
  });

  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback onTap;
  final double size;
  final Color background;
  final Color iconColor;
  final double iconSize;
  final Color? glow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: background,
            boxShadow: glow == null
                ? null
                : [
                    BoxShadow(
                      color: glow!.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Center(
            child: customIcon ?? Icon(icon, color: iconColor, size: iconSize),
          ),
        ),
      ),
    );
  }
}

/// The red "end call" button — a rotated handset in a danger-filled circle.
class EndCallButton extends StatelessWidget {
  const EndCallButton({super.key, required this.onTap, this.size = 64});

  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CallControlButton(
      onTap: onTap,
      size: size,
      background: AppColors.danger,
      glow: AppColors.danger,
      customIcon: Transform.rotate(
        angle: 135 * 3.1415926535 / 180,
        child: const Icon(Icons.call_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}
