import '../config/app_config.dart';

/// Centralized API configuration that bridges environment base URLs with tenant context.
class ApiConfig {
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Resolved base URL from current environment.
  static String get baseUrl => AppConfig.instance.apiBaseUrl;

  /// Default headers including tenant identifier and environment context.
  static Map<String, String> get defaultHeaders {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Tenant-ID': AppConfig.currentTenant.id,
      'X-Environment': AppConfig.currentEnvironment.code,
      'X-App-Version': '1.0.0+1',
    };
  }

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String userProfileEndpoint = '/user/profile';
  static const String dashboardStatsEndpoint = '/dashboard/stats';
  static const String featureFlagsEndpoint = '/tenant/features';
}
