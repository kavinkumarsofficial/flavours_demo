import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import 'api_config.dart';

/// Secure token storage and session state.
class AuthTokenManager {
  static String? _accessToken;
  static String? _refreshToken;

  static String? get accessToken => _accessToken;
  static bool get isAuthenticated => _accessToken != null && _accessToken!.isNotEmpty;

  static void setTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  static void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  static Future<bool> refresh() async {
    if (_refreshToken == null) return false;
    // Simulate token refresh exchange
    await Future.delayed(const Duration(milliseconds: 300));
    _accessToken = 'jwt_mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
    return true;
  }
}

/// Production-ready Dio HTTP Client with interceptors and tenant routing.
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // 1. Auth & Tenant Context Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Always ensure the latest tenant header is attached
          options.headers['X-Tenant-ID'] = AppConfig.currentTenant.id;
          options.headers['X-Environment'] = AppConfig.currentEnvironment.code;

          if (AuthTokenManager.accessToken != null) {
            options.headers['Authorization'] = 'Bearer ${AuthTokenManager.accessToken}';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Handle 401 Unauthorized with token refresh
          if (error.response?.statusCode == 401 && AuthTokenManager.isAuthenticated) {
            final refreshed = await AuthTokenManager.refresh();
            if (refreshed) {
              // Retry original request
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer ${AuthTokenManager.accessToken}';
              try {
                final response = await _dio.fetch(opts);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            } else {
              AuthTokenManager.clearTokens();
            }
          }
          return handler.next(error);
        },
      ),
    );

    // 2. Logging Interceptor (Enabled only when environment allows logging)
    if (AppConfig.currentEnvironment.enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (log) => debugPrint('[API Log] $log'),
        ),
      );
    }
  }

  Dio get dio => _dio;

  /// Simulated / Mock API Login for demo purposes without external dependency.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Simulate brief network latency
    await Future.delayed(const Duration(milliseconds: 600));

    if (password.length < 4) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiConfig.loginEndpoint),
        response: Response(
          requestOptions: RequestOptions(path: ApiConfig.loginEndpoint),
          statusCode: 400,
          data: {'message': 'Password must be at least 4 characters'},
        ),
        type: DioExceptionType.badResponse,
      );
    }

    final tenant = AppConfig.currentTenant;
    final token = 'jwt_token_${tenant.id}_${DateTime.now().millisecondsSinceEpoch}';
    AuthTokenManager.setTokens(
      accessToken: token,
      refreshToken: 'jwt_refresh_${tenant.id}',
    );

    return {
      'user': {
        'id': 'usr_998',
        'name': '${tenant.displayName} Administrator',
        'email': email,
        'role': 'Enterprise Admin',
        'tenant': tenant.id,
      },
      'token': token,
    };
  }

  /// Simulated dashboard metrics tailored to environment and tenant.
  Future<Map<String, dynamic>> fetchDashboardMetrics() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final tenant = AppConfig.currentTenant;
    final env = AppConfig.currentEnvironment;

    return {
      'tenantId': tenant.id,
      'environment': env.code,
      'apiHost': env.defaultApiBaseUrl,
      'activeUsers': tenant.id == 'kgf' ? 14200 : (tenant.id == 'fgk' ? 9840 : 23150),
      'monthlyRevenue': tenant.id == 'kgf' ? r'$248,000' : (tenant.id == 'fgk' ? r'$174,500' : r'$392,000'),
      'systemHealth': '99.98%',
      'pendingApprovals': 12,
    };
  }
}
