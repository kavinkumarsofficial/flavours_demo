import 'package:flutter/material.dart';
import '../features/feature_flags.dart';

enum TenantType {
  kgf,
  fgk,
  gkf;

  static TenantType fromString(String? value) {
    if (value == null || value.isEmpty) {
      return TenantType.kgf;
    }
    final lower = value.toLowerCase();
    if (lower.contains('fgk')) {
      return TenantType.fgk;
    }
    if (lower.contains('gkf')) {
      return TenantType.gkf;
    }
    return TenantType.kgf;
  }
}

class TenantConfig {
  final TenantType type;
  final String id;
  final String displayName;
  final String applicationId;
  final String logoPath;
  final String tagline;
  final String supportEmail;

  // Tenant-specific Palette
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color lightBackgroundColor;
  final Color darkBackgroundColor;
  final Color lightSurfaceColor;
  final Color darkSurfaceColor;

  final FeatureFlags featureFlags;

  const TenantConfig({
    required this.type,
    required this.id,
    required this.displayName,
    required this.applicationId,
    required this.logoPath,
    required this.tagline,
    required this.supportEmail,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.lightBackgroundColor,
    required this.darkBackgroundColor,
    required this.lightSurfaceColor,
    required this.darkSurfaceColor,
    required this.featureFlags,
  });

  /// Tenant KGF
  /// Application ID: com.company.kgf
  /// Display name: KGF
  /// Palette: Amber Gold & Deep Onyx
  factory TenantConfig.kgf() {
    return TenantConfig(
      type: TenantType.kgf,
      id: 'kgf',
      displayName: 'KGF',
      applicationId: 'com.company.kgf',
      logoPath: 'assets/tenants/kgf/logo.png',
      tagline: 'Empowering Gold Standard Enterprise Operations',
      supportEmail: 'support@kgf.company.com',
      primaryColor: const Color(0xFFD97706), // Warm Amber Gold
      secondaryColor: const Color(0xFFB45309), // Bronze
      accentColor: const Color(0xFFF59E0B),
      lightBackgroundColor: const Color(0xFFFAF9F6),
      darkBackgroundColor: const Color(0xFF14120E),
      lightSurfaceColor: Colors.white,
      darkSurfaceColor: const Color(0xFF1F1C17),
      featureFlags: FeatureFlags.kgfDefaults(),
    );
  }

  /// Tenant FGK
  /// Application ID: com.company.fgk
  /// Display name: FGK
  /// Palette: Electric Cyan & Slate Navy
  factory TenantConfig.fgk() {
    return TenantConfig(
      type: TenantType.fgk,
      id: 'fgk',
      displayName: 'FGK',
      applicationId: 'com.company.fgk',
      logoPath: 'assets/tenants/fgk/logo.png',
      tagline: 'Next-Gen Financial Intelligence & Global Logistics',
      supportEmail: 'help@fgk.company.com',
      primaryColor: const Color(0xFF0EA5E9), // Modern Electric Cyan
      secondaryColor: const Color(0xFF0284C7), // Cobalt Deep
      accentColor: const Color(0xFF38BDF8),
      lightBackgroundColor: const Color(0xFFF8FAFC),
      darkBackgroundColor: const Color(0xFF0B1329),
      lightSurfaceColor: Colors.white,
      darkSurfaceColor: const Color(0xFF131F3F),
      featureFlags: FeatureFlags.fgkDefaults(),
    );
  }

  /// Tenant GKF
  /// Application ID: com.cpompany.gkf (Preserved exact typo per specification)
  /// Display name: GKF
  /// Palette: Vibrant Emerald & Forest Green
  factory TenantConfig.gkf() {
    return TenantConfig(
      type: TenantType.gkf,
      id: 'gkf',
      displayName: 'GKF',
      // DO NOT silently correct this package ID; exact required ID is com.cpompany.gkf
      applicationId: 'com.cpompany.gkf',
      logoPath: 'assets/tenants/gkf/logo.png',
      tagline: 'Sustainable Global Ecosystems & Cloud Innovation',
      supportEmail: 'care@gkf.cpompany.com',
      primaryColor: const Color(0xFF10B981), // Emerald
      secondaryColor: const Color(0xFF059669), // Forest
      accentColor: const Color(0xFF34D399),
      lightBackgroundColor: const Color(0xFFF0FDF4),
      darkBackgroundColor: const Color(0xFF062319),
      lightSurfaceColor: Colors.white,
      darkSurfaceColor: const Color(0xFF0D382A),
      featureFlags: FeatureFlags.gkfDefaults(),
    );
  }

  /// Resolve TenantConfig by TenantType.
  static TenantConfig fromType(TenantType type) {
    switch (type) {
      case TenantType.kgf:
        return TenantConfig.kgf();
      case TenantType.fgk:
        return TenantConfig.fgk();
      case TenantType.gkf:
        return TenantConfig.gkf();
    }
  }

  /// Resolve TenantConfig by string identifier or flavor.
  static TenantConfig fromIdentifier(String? value) {
    return fromType(TenantType.fromString(value));
  }
}
