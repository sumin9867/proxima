import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Builds the [ThemeData] used across the Proxima app.
///
/// The reference design uses the DM Sans typeface. We rely on it being bundled
/// as a font family named `DM Sans`; when it isn't available the platform font
/// is used as a graceful fallback.
abstract final class AppTheme {
  static const String fontFamily = 'DM Sans';

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
