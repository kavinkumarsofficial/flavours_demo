import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'app_environment.dart';
import 'tenant_config.dart';
import '../features/feature_flags.dart';

/// Combined, centralized application configuration.
///
/// Automatically determines the active environment and tenant from:
/// 1. Flutter's [appFlavor] (provided automatically by Gradle when using --flavor)
/// 2. Optional compile-time defines (`ENVIRONMENT`, `TENANT`)
/// 3. Safe defaults (Development + KGF) for unflavored execution/tests.
class AppConfig {
  final AppEnvironment environment;
  final TenantConfig tenant;
  final String activeFlavorRaw;
  final String apiBaseUrl;

  // Private constructor
  AppConfig._({
    required this.environment,
    required this.tenant,
    required this.activeFlavorRaw,
    required this.apiBaseUrl,
  });

  static AppConfig? _instance;

  /// Singleton access to the active application configuration.
  static AppConfig get instance {
    _instance ??= AppConfig.resolve(flavor: appFlavor);
    return _instance!;
  }

  /// Active tenant shortcut.
  static TenantConfig get currentTenant => instance.tenant;

  /// Active environment shortcut.
  static AppEnvironment get currentEnvironment => instance.environment;

  /// Active feature flags shortcut.
  static FeatureFlags get features => instance.tenant.featureFlags;

  /// Resolved application ID matching Android variant package ID.
  String get effectiveApplicationId {
    final baseId = tenant.applicationId;
    switch (environment) {
      case AppEnvironment.dev:
        return '$baseId.dev';
      case AppEnvironment.staging:
        return '$baseId.staging';
      case AppEnvironment.prod:
        return baseId; // No suffix in production
    }
  }

  /// Current build variant name (e.g., "devKgf", "stagingFgk", "prodGkf").
  String get variantName {
    final envCode = environment.code;
    final tenantCapitalized = tenant.id[0].toUpperCase() + tenant.id.substring(1);
    return '$envCode$tenantCapitalized';
  }

  /// Initialize application configuration at startup.
  static Future<AppConfig> initialize({String? overrideFlavor}) async {
    final rawFlavor = overrideFlavor ??
        appFlavor ??
        const String.fromEnvironment('FLAVOR', defaultValue: '');

    final resolved = resolve(flavor: rawFlavor);
    _instance = resolved;

    if (kDebugMode && resolved.environment.enableLogging) {
      debugPrint('====================================================');
      debugPrint('[AppConfig] Initialized Multi-Tenant Flutter Architecture');
      debugPrint('[AppConfig] Flavor Raw: "$rawFlavor" -> Variant: ${resolved.variantName}');
      debugPrint('[AppConfig] Environment: ${resolved.environment.displayName} (${resolved.environment.code})');
      debugPrint('[AppConfig] Tenant: ${resolved.tenant.displayName} (${resolved.tenant.id})');
      debugPrint('[AppConfig] App ID: ${resolved.effectiveApplicationId}');
      debugPrint('[AppConfig] API Base URL: ${resolved.apiBaseUrl}');
      debugPrint('[AppConfig] Logging Enabled: ${resolved.environment.enableLogging}');
      debugPrint('[AppConfig] Feature A (Analytics): ${resolved.tenant.featureFlags.analyticsDashboard}');
      debugPrint('[AppConfig] Feature B (In-App Purchases): ${resolved.tenant.featureFlags.inAppPurchases}');
      debugPrint('====================================================');
    }

    return _instance!;
  }

  /// Resolve configuration based on flavor string and/or compile-time environment flags.
  static AppConfig resolve({String? flavor}) {
    final normalized = (flavor ?? '').toLowerCase().trim();

    // 1. Check dart-define overrides first if available
    const envDefine = String.fromEnvironment('ENVIRONMENT');
    const tenantDefine = String.fromEnvironment('TENANT');

    AppEnvironment env;
    if (envDefine.isNotEmpty) {
      env = AppEnvironment.fromString(envDefine);
    } else {
      env = AppEnvironment.fromString(normalized);
    }

    TenantType tenantType;
    if (tenantDefine.isNotEmpty) {
      tenantType = TenantType.fromString(tenantDefine);
    } else {
      tenantType = TenantType.fromString(normalized);
    }

    final tenantConfig = TenantConfig.fromType(tenantType);

    return AppConfig._(
      environment: env,
      tenant: tenantConfig,
      activeFlavorRaw: flavor ?? 'default',
      apiBaseUrl: env.defaultApiBaseUrl,
    );
  }

  /// Allows dynamic switching for in-app developer inspection / demoing all 9 variants.
  static void switchVariant(AppEnvironment newEnv, TenantType newTenant) {
    final newTenantConfig = TenantConfig.fromType(newTenant);
    _instance = AppConfig._(
      environment: newEnv,
      tenant: newTenantConfig,
      activeFlavorRaw: '${newEnv.code}${newTenantConfig.id}',
      apiBaseUrl: newEnv.defaultApiBaseUrl,
    );
  }
}
