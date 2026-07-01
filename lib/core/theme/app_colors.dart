import 'package:flutter/material.dart';

/// Color palette for the Proxima design system.
///
/// Values mirror the "Proxima UI" reference design: a deep-blue accent on
/// light surfaces for the setup flows and near-black surfaces for the in-call
/// experience.
abstract final class AppColors {
  // Brand accent.
  static const Color primary = Color(0xFF000099);
  static const Color primaryDark = Color(0xFF000077);

  // Light surfaces.
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color surfaceSubtle = Color(0x05000000); // rgba(0,0,0,.02)

  // Text on light surfaces.
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textMuted = Color(0xFF888888);

  // Dividers / hairlines on light surfaces.
  static const Color border = Color(0x14000000); // rgba(0,0,0,.08)

  // Dark (in-call) surfaces.
  static const Color callBackground = Color(0xFF0A0B11);
  static const Color videoBackground = Color(0xFF090A12);
  static const Color controlSurface = Color(0xFF1E2030);
  static const Color controlBar = Color(0xFF13141C);
  static const Color textOnDark = Color(0xFFF0F1F7);
  static const Color textOnDarkMuted = Color(0xFF6B6C7E);
  static const Color textOnDarkFaint = Color(0xFF3B3C4A);

  // Status colors.
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFA500);
  static const Color danger = Color(0xFFFF4B55);

  // Participant avatar accents.
  static const Color avatarPurple = Color(0xFF7C5CFC);
  static const Color avatarBlue = Color(0xFF2B6CB0);
  static const Color avatarTeal = Color(0xFF1E9A91);
}
