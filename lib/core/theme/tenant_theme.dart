import 'package:flutter/material.dart';
import '../config/tenant_config.dart';

/// Produces refined Material 3 themes tailored to each tenant's branding and color identity.
class TenantTheme {
  final TenantConfig tenant;

  const TenantTheme(this.tenant);

  /// Builds the light theme for this tenant.
  ThemeData lightTheme() {
    final colorScheme = ColorScheme.light(
      primary: tenant.primaryColor,
      onPrimary: Colors.white,
      primaryContainer: tenant.primaryColor.withValues(alpha: 0.12),
      onPrimaryContainer: tenant.primaryColor,
      secondary: tenant.secondaryColor,
      onSecondary: Colors.white,
      secondaryContainer: tenant.secondaryColor.withValues(alpha: 0.14),
      onSecondaryContainer: tenant.secondaryColor,
      tertiary: tenant.accentColor,
      onTertiary: Colors.white,
      surface: tenant.lightSurfaceColor,
      onSurface: const Color(0xFF1E293B),
      error: const Color(0xFFEF4444),
      onError: Colors.white,
      outline: const Color(0xFFE2E8F0),
      outlineVariant: const Color(0xFFF1F5F9),
    );

    return _buildTheme(colorScheme, isDark: false);
  }

  /// Builds the dark theme for this tenant.
  ThemeData darkTheme() {
    final colorScheme = ColorScheme.dark(
      primary: tenant.accentColor,
      onPrimary: const Color(0xFF0F172A),
      primaryContainer: tenant.primaryColor.withValues(alpha: 0.28),
      onPrimaryContainer: Colors.white,
      secondary: tenant.secondaryColor,
      onSecondary: Colors.white,
      secondaryContainer: tenant.secondaryColor.withValues(alpha: 0.3),
      onSecondaryContainer: Colors.white,
      tertiary: tenant.accentColor,
      onTertiary: Colors.black,
      surface: tenant.darkSurfaceColor,
      onSurface: const Color(0xFFF8FAFC),
      error: const Color(0xFFF87171),
      onError: Colors.black,
      outline: const Color(0xFF334155),
      outlineVariant: const Color(0xFF1E293B),
    );

    return _buildTheme(colorScheme, isDark: true);
  }

  ThemeData _buildTheme(ColorScheme colorScheme, {required bool isDark}) {
    final baseBg = isDark ? tenant.darkBackgroundColor : tenant.lightBackgroundColor;
    final surface = isDark ? tenant.darkSurfaceColor : tenant.lightSurfaceColor;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: baseBg,
      fontFamily: null, // Uses default platform system font
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tenant.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tenant.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          side: BorderSide(color: tenant.primaryColor, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tenant.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? colorScheme.surface.withValues(alpha: 0.5)
            : const Color(0xFFF1F5F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tenant.primaryColor, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 12.5,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.4),
          fontSize: 12.5,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.4),
        thickness: 1,
        space: 16,
      ),
    );
  }
}
