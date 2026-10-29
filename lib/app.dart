import 'package:flutter/material.dart';
import 'package:responsive_flutter_ui/responsive_flutter_ui.dart';
import 'core/state/app_state.dart';
import 'core/theme/tenant_theme.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/login_screen.dart';

/// The root Flutter Application widget with responsive initialization and tenant themes.
class MultiTenantApp extends StatelessWidget {
  const MultiTenantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final tenant = appState.config.tenant;
    final env = appState.config.environment;
    final tenantTheme = TenantTheme(tenant);

    return ResponsiveInit(
      // Calibrated responsive configuration:
      // Prevents oversized typography, oversized inputs, and layout clipping on mobile/desktop.
      config: const ResponsiveConfig(
        referenceWidth: 390,
        referenceHeight: 844,
        widthScaleBounds: ResponsiveScaleBounds(min: 0.85, max: 1.02),
        heightScaleBounds: ResponsiveScaleBounds(min: 0.85, max: 1.02),
        fontScaleBounds: ResponsiveScaleBounds(min: 0.85, max: 1.00),
        radiusScaleBounds: ResponsiveScaleBounds(min: 0.85, max: 1.00),
        iconScaleBounds: ResponsiveScaleBounds(min: 0.85, max: 1.02),
        generalScaleBounds: ResponsiveScaleBounds(min: 0.85, max: 1.00),
        fontSensitivity: 0.30,
        radiusSensitivity: 0.25,
      ),
      child: MaterialApp(
        title: '${tenant.displayName} - ${env.displayName}',
        debugShowCheckedModeBanner: false,
        theme: tenantTheme.lightTheme(),
        darkTheme: tenantTheme.darkTheme(),
        themeMode: appState.themeMode,
        home: appState.isAuthenticated
            ? DashboardScreen(onLogout: () => appState.logout())
            : LoginScreen(onLoginSuccess: () {}),
      ),
    );
  }
}
