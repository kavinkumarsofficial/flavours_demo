/// Centralized feature flags for tenant and environment capabilities.
class FeatureFlags {
  /// Feature A: Advanced Analytics and reporting dashboard.
  final bool analyticsDashboard;

  /// Feature B: In-app billing, paywalls, and subscription upgrades.
  final bool inAppPurchases;

  /// Biometric authentication (Fingerprint / Face ID).
  final bool biometricAuth;

  /// Export data functionality (PDF/CSV generation).
  final bool exportReports;

  /// In-app live chat support.
  final bool liveChatSupport;

  const FeatureFlags({
    required this.analyticsDashboard,
    required this.inAppPurchases,
    required this.biometricAuth,
    required this.exportReports,
    this.liveChatSupport = false,
  });

  /// Default configuration for KGF: Feature A enabled, Feature B disabled.
  factory FeatureFlags.kgfDefaults() {
    return const FeatureFlags(
      analyticsDashboard: true,
      inAppPurchases: false,
      biometricAuth: true,
      exportReports: true,
      liveChatSupport: true,
    );
  }

  /// Default configuration for FGK: Feature A disabled, Feature B enabled.
  factory FeatureFlags.fgkDefaults() {
    return const FeatureFlags(
      analyticsDashboard: false,
      inAppPurchases: true,
      biometricAuth: true,
      exportReports: false,
      liveChatSupport: false,
    );
  }

  /// Default configuration for GKF: Both features enabled.
  factory FeatureFlags.gkfDefaults() {
    return const FeatureFlags(
      analyticsDashboard: true,
      inAppPurchases: true,
      biometricAuth: true,
      exportReports: true,
      liveChatSupport: true,
    );
  }

  /// Safely parse from backend API response or local cache.
  factory FeatureFlags.fromJson(Map<String, dynamic>? json, FeatureFlags fallback) {
    if (json == null) return fallback;
    return FeatureFlags(
      analyticsDashboard: json['analyticsDashboard'] as bool? ?? fallback.analyticsDashboard,
      inAppPurchases: json['inAppPurchases'] as bool? ?? fallback.inAppPurchases,
      biometricAuth: json['biometricAuth'] as bool? ?? fallback.biometricAuth,
      exportReports: json['exportReports'] as bool? ?? fallback.exportReports,
      liveChatSupport: json['liveChatSupport'] as bool? ?? fallback.liveChatSupport,
    );
  }

  Map<String, dynamic> toJson() => {
        'analyticsDashboard': analyticsDashboard,
        'inAppPurchases': inAppPurchases,
        'biometricAuth': biometricAuth,
        'exportReports': exportReports,
        'liveChatSupport': liveChatSupport,
      };

  FeatureFlags copyWith({
    bool? analyticsDashboard,
    bool? inAppPurchases,
    bool? biometricAuth,
    bool? exportReports,
    bool? liveChatSupport,
  }) {
    return FeatureFlags(
      analyticsDashboard: analyticsDashboard ?? this.analyticsDashboard,
      inAppPurchases: inAppPurchases ?? this.inAppPurchases,
      biometricAuth: biometricAuth ?? this.biometricAuth,
      exportReports: exportReports ?? this.exportReports,
      liveChatSupport: liveChatSupport ?? this.liveChatSupport,
    );
  }
}
