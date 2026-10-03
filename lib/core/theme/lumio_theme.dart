import 'package:flutter/material.dart';

import 'lumio_colors.dart';
import 'lumio_palette.dart';
import 'lumio_radius.dart';
import 'lumio_spacing.dart';
import 'lumio_typography.dart';

abstract final class LumioTheme {
  static const childTouchTarget = LumioSpacing.childTouchTarget;
  static const fontFallback = LumioTypography.fallback;

  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: LumioColors.primary,
      onPrimary: LumioColors.onPrimary,
      primaryContainer: LumioColors.primaryContainer,
      onPrimaryContainer: LumioColors.textPrimary,
      secondary: LumioColors.secondary,
      onSecondary: LumioColors.onSecondary,
      secondaryContainer: LumioColors.secondaryContainer,
      onSecondaryContainer: LumioColors.textPrimary,
      tertiary: LumioColors.glow,
      onTertiary: LumioColors.onGlow,
      tertiaryContainer: LumioColors.background,
      onTertiaryContainer: LumioColors.textPrimary,
      error: LumioColors.error,
      onError: LumioColors.onPrimary,
      errorContainer: LumioColors.background,
      onErrorContainer: LumioColors.error,
      surface: LumioColors.surface,
      onSurface: LumioColors.textPrimary,
      onSurfaceVariant: LumioColors.textSecondary,
      outline: LumioColors.outline,
      outlineVariant: LumioColors.outlineSubtle,
      inverseSurface: LumioColors.textPrimary,
      onInverseSurface: LumioColors.onPrimary,
      inversePrimary: LumioPalette.lilac,
      surfaceTint: LumioColors.primary,
      surfaceContainerLowest: LumioColors.surface,
      surfaceContainerLow: LumioColors.surfaceSubtle,
      surfaceContainer: LumioColors.surfaceSubtle,
      surfaceContainerHigh: LumioColors.surfaceSubtle,
      surfaceContainerHighest: LumioColors.primaryContainer,
    );
    final shape = RoundedRectangleBorder(borderRadius: LumioRadius.button);
    final buttons = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(childTouchTarget, childTouchTarget),
      ),
      textStyle: WidgetStatePropertyAll(LumioTypography.labelLarge),
      padding: const WidgetStatePropertyAll(
        EdgeInsetsDirectional.symmetric(
          horizontal: LumioSpacing.lg,
          vertical: LumioSpacing.md,
        ),
      ),
      shape: WidgetStatePropertyAll(shape),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: LumioColors.background,
      fontFamily: 'PlusJakartaSans',
      fontFamilyFallback: fontFallback,
      textTheme: LumioTypography.textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      filledButtonTheme: FilledButtonThemeData(style: buttons),
      outlinedButtonTheme: OutlinedButtonThemeData(style: buttons),
      textButtonTheme: TextButtonThemeData(style: buttons),
      iconButtonTheme: IconButtonThemeData(
        style: buttons.copyWith(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.all(LumioSpacing.md),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: LumioColors.surface,
        surfaceTintColor: LumioColors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: LumioRadius.card),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: LumioColors.primary,
        selectionColor: LumioColors.primary.withValues(alpha: 0.20),
        selectionHandleColor: LumioColors.primary,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: LumioColors.primary,
        linearTrackColor: LumioColors.surfaceSubtle,
        circularTrackColor: LumioColors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LumioColors.surface,
        hintStyle: LumioTypography.bodyMedium.copyWith(
          color: LumioColors.textSecondary,
        ),
        errorStyle: LumioTypography.bodySmall.copyWith(
          color: LumioColors.error,
        ),
        errorMaxLines: 3,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 19,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: LumioColors.controlOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: LumioColors.controlOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: LumioColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: LumioColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: LumioColors.error, width: 2),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? LumioColors.onPrimary
              : LumioColors.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? LumioColors.primary
              : LumioColors.surfaceSubtle,
        ),
      ),
    );
  }
}
