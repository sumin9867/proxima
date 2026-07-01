import 'package:flutter/material.dart';

/// A circular monogram avatar used throughout the app. Supports a flat fill or,
/// when [gradient] is supplied, the top-left→bottom-right gradient used for the
/// large voice-call avatars.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.initial,
    required this.color,
    this.size = 40,
    this.fontSize,
    this.gradient,
    this.opacity = 1,
    this.boxShadow,
  });

  final String initial;
  final Color color;
  final double size;
  final double? fontSize;
  final Gradient? gradient;
  final double opacity;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: gradient == null ? color : null,
          gradient: gradient,
          boxShadow: boxShadow,
        ),
        alignment: Alignment.center,
        child: Text(
          initial,
          style: TextStyle(
            fontSize: fontSize ?? size * 0.42,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
