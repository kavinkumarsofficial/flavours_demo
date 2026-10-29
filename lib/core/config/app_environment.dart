enum AppEnvironment {
  dev,
  staging,
  prod;

  /// Resolves the environment from a string identifier (e.g., flavor name or dart-define).
  static AppEnvironment fromString(String? value) {
    if (value == null || value.isEmpty) {
      return AppEnvironment.dev;
    }
    final lower = value.toLowerCase();
    if (lower.contains('prod')) {
      return AppEnvironment.prod;
    }
    if (lower.contains('staging')) {
      return AppEnvironment.staging;
    }
    return AppEnvironment.dev;
  }

  /// User-friendly display name.
  String get displayName {
    switch (this) {
      case AppEnvironment.dev:
        return 'Development';
      case AppEnvironment.staging:
        return 'Staging';
      case AppEnvironment.prod:
        return 'Production';
    }
  }

  /// Short code (dev, staging, prod).
  String get code {
    switch (this) {
      case AppEnvironment.dev:
        return 'dev';
      case AppEnvironment.staging:
        return 'staging';
      case AppEnvironment.prod:
        return 'prod';
    }
  }

  /// Tenant-independent API base URL for this environment.
  String get defaultApiBaseUrl {
    switch (this) {
      case AppEnvironment.dev:
        return 'https://dev-api.example.com';
      case AppEnvironment.staging:
        return 'https://staging-api.example.com';
      case AppEnvironment.prod:
        return 'https://api.example.com';
    }
  }

  /// Whether verbose network and system logs are allowed.
  bool get enableLogging {
    switch (this) {
      case AppEnvironment.dev:
      case AppEnvironment.staging:
        return true;
      case AppEnvironment.prod:
        return false;
    }
  }

  /// Whether to display the environment tag/banner.
  bool get showDebugBanner {
    switch (this) {
      case AppEnvironment.dev:
      case AppEnvironment.staging:
        return true;
      case AppEnvironment.prod:
        return false;
    }
  }

  /// Whether current environment is production.
  bool get isProduction => this == AppEnvironment.prod;
}
