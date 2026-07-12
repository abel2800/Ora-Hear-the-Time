import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

abstract final class AppTheme {
  static ThemeData dark({ColorScheme? dynamicScheme}) {
    final scheme = (dynamicScheme ?? _darkScheme()).copyWith(
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
    );
    return _buildTheme(scheme, isDark: true);
  }

  static ThemeData light({ColorScheme? dynamicScheme}) {
    final scheme = (dynamicScheme ?? _lightScheme()).copyWith(
      brightness: Brightness.light,
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
    );
    return _buildTheme(scheme, isDark: false);
  }

  static ColorScheme _darkScheme() => const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        tertiary: AppColors.warning,
        surface: AppColors.darkSurface,
        onSurface: Color(0xFFFAFAFA),
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.darkBorder,
      );

  static ColorScheme _lightScheme() => const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        tertiary: AppColors.warning,
        surface: AppColors.lightSurface,
        onSurface: Color(0xFF18181B),
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.lightSurfaceVariant,
      );

  static ThemeData _buildTheme(ColorScheme scheme, {required bool isDark}) {
    final textTheme = GoogleFonts.interTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface.withValues(alpha: isDark ? 0.85 : 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          side: BorderSide(
            color: scheme.outline.withValues(alpha: isDark ? 0.3 : 0.2),
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.secondary,
        inactiveTrackColor: scheme.outline.withValues(alpha: 0.4),
        thumbColor: scheme.secondary,
        overlayColor: scheme.secondary.withValues(alpha: 0.15),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.secondary;
          return scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.secondary.withValues(alpha: 0.4);
          }
          return scheme.outline.withValues(alpha: 0.3);
        }),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
      ),
    );
  }
}
