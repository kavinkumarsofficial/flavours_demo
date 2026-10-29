import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../config/app_environment.dart';
import '../config/tenant_config.dart';
import '../api/api_client.dart';
import '../services/dynamic_app_icon_service.dart';

/// Central application state managing user auth, theme mode, and active variant.
class AppState extends ChangeNotifier {
  AppConfig _config = AppConfig.instance;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isAuthenticated = false;
  String _userDisplayName = 'Demo User';
  String _userEmail = 'admin@example.com';
  bool _isBiometricEnrolled = true;

  AppConfig get config => _config;
  ThemeMode get themeMode => _themeMode;
  bool get isAuthenticated => _isAuthenticated;
  String get userDisplayName => _userDisplayName;
  String get userEmail => _userEmail;
  bool get isBiometricEnrolled => _isBiometricEnrolled;

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void login({required String email, required String name}) {
    _isAuthenticated = true;
    _userEmail = email;
    _userDisplayName = name;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    AuthTokenManager.clearTokens();
    notifyListeners();
  }

  void setBiometricEnrolled(bool value) {
    _isBiometricEnrolled = value;
    notifyListeners();
  }

  /// Switch the active variant live (useful for developer inspection and live flavor verification).
  /// Also updates the mobile device home screen icon & label (Duolingo-style).
  void switchVariant(AppEnvironment env, TenantType tenant) {
    AppConfig.switchVariant(env, tenant);
    _config = AppConfig.instance;
    DynamicAppIconService.setTenantLauncherIcon(tenant);
    notifyListeners();
  }
}

/// InheritedWidget providing access to AppState throughout the widget tree.
class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.notifier!;
  }
}
