import 'package:flutter/material.dart';
import 'package:responsive_flutter_ui/responsive_flutter_ui.dart';
import '../../core/config/tenant_config.dart';
import '../../core/state/app_state.dart';
import '../widgets/feature_card.dart';
import '../widgets/tenant_badge.dart';
import '../widgets/tenant_logo.dart';
import '../widgets/variant_switcher_modal.dart';
import 'analytics_screen.dart';
import 'purchases_screen.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const DashboardScreen({super.key, required this.onLogout});

  void _showFeatureDisabledDialog(
      BuildContext context, String featureName, String tenantName, String requiredFlag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.shield_outlined, color: Colors.orange, size: 32),
        title: Text(
          'Feature Guard: $featureName',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$featureName is disabled for $tenantName.',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6.h),
            Text(
              'Under the multi-tenant architecture, feature flags prevent unauthorized access to disabled modules. Route guard has blocked direct navigation.',
              style: TextStyle(fontSize: 11.5.sp, color: Colors.grey[700]),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                'Required Flag: $requiredFlag = true',
                style: TextStyle(fontSize: 10.sp, fontFamily: 'monospace', color: Colors.black87),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Understood', style: TextStyle(fontSize: 12.sp)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final tenant = appState.config.tenant;
    final env = appState.config.environment;
    final theme = Theme.of(context);
    final flags = tenant.featureFlags;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 42.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w, top: 8.h, bottom: 8.h),
          child: TenantLogo(tenant: tenant, showBorder: false, size: 28),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tenant.displayName,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              '${env.displayName} Console',
              style: TextStyle(
                fontSize: 10.sp,
                color: tenant.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TenantBadge(tenant: tenant, environment: env, compact: true),
          IconButton(
            tooltip: 'Switch Theme',
            iconSize: 17.r,
            icon: Icon(
              appState.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => appState.toggleTheme(),
          ),
          IconButton(
            tooltip: 'Matrix Inspector',
            iconSize: 17.r,
            icon: const Icon(Icons.layers_outlined),
            onPressed: () => VariantSwitcherModal.show(context),
          ),
          IconButton(
            tooltip: 'Sign Out',
            iconSize: 17.r,
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Center(
          child: ResponsiveContainer(
            maxWidth: 1100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Welcome Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        tenant.primaryColor.withValues(alpha: 0.12),
                        tenant.secondaryColor.withValues(alpha: 0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: tenant.primaryColor.withValues(alpha: 0.25),
                      width: 1.w,
                    ),
                  ),
                  child: ResponsiveBuilder(
                    builder: (context, info) {
                      final isNarrow = info.isMobile;
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back, ${appState.userDisplayName}',
                                  style: TextStyle(
                                    fontSize: 14.5.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  tenant.tagline,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Wrap(
                                  spacing: 6.w,
                                  runSpacing: 4.h,
                                  children: [
                                    _buildChip(
                                      context,
                                      icon: Icons.fingerprint,
                                      label: appState.config.effectiveApplicationId,
                                    ),
                                    _buildChip(
                                      context,
                                      icon: Icons.link,
                                      label: appState.config.apiBaseUrl,
                                    ),
                                    _buildChip(
                                      context,
                                      icon: Icons.verified_user,
                                      label: 'Build: ${appState.config.variantName}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (!isNarrow) ...[
                            SizedBox(width: 12.w),
                            TenantLogo(tenant: tenant, size: 48),
                          ],
                        ],
                      );
                    },
                  ),
                ),

                SizedBox(height: 16.h),

                // Section 1: KPI Stats Grid
                Text(
                  'Tenant Operational Overview',
                  style: TextStyle(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 8.h),

                // Responsive KPI Layout: auto-sizes cleanly without fixed-aspect-ratio overflows
                ResponsiveBuilder(
                  builder: (context, info) {
                    final kpi1 = _buildKpiCard(
                      context,
                      title: 'Monthly Volume',
                      value: tenant.type == TenantType.kgf
                          ? r'$248,000'
                          : (tenant.type == TenantType.fgk ? r'$174,500' : r'$392,000'),
                      subtitle: '+18.4% quarter',
                      icon: Icons.payments_outlined,
                      color: tenant.primaryColor,
                    );
                    final kpi2 = _buildKpiCard(
                      context,
                      title: 'Active Seats',
                      value: tenant.type == TenantType.kgf
                          ? '14,200'
                          : (tenant.type == TenantType.fgk ? '9,840' : '23,150'),
                      subtitle: '99.4% engagement',
                      icon: Icons.group_outlined,
                      color: tenant.secondaryColor,
                    );
                    final kpi3 = _buildKpiCard(
                      context,
                      title: 'System Uptime',
                      value: '99.98%',
                      subtitle: 'Zero downtime',
                      icon: Icons.cloud_done_outlined,
                      color: const Color(0xFF10B981),
                    );
                    final kpi4 = _buildKpiCard(
                      context,
                      title: 'API Gateway',
                      value: env.code.toUpperCase(),
                      subtitle: env.enableLogging ? 'Debug Logs Active' : 'Prod Optimized',
                      icon: Icons.dns_outlined,
                      color: tenant.accentColor,
                    );

                    if (info.isDesktop) {
                      return Row(
                        children: [
                          Expanded(child: kpi1),
                          SizedBox(width: 10.w),
                          Expanded(child: kpi2),
                          SizedBox(width: 10.w),
                          Expanded(child: kpi3),
                          SizedBox(width: 10.w),
                          Expanded(child: kpi4),
                        ],
                      );
                    }

                    // Mobile & Tablet: Clean 2x2 row layout
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: kpi1),
                            SizedBox(width: 10.w),
                            Expanded(child: kpi2),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(child: kpi3),
                            SizedBox(width: 10.w),
                            Expanded(child: kpi4),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 18.h),

                // Section 2: Tenant-Specific Feature Flags
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tenant Feature Flags Matrix',
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(
                            'Features isolated and dynamically configured per tenant build.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => VariantSwitcherModal.show(context),
                      icon: const Icon(Icons.compare_arrows, size: 14),
                      label: Text('Matrix', style: TextStyle(fontSize: 11.sp)),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Responsive Feature Cards: natural intrinsic height on mobile, 2 columns on desktop
                ResponsiveBuilder(
                  builder: (context, info) {
                    final cardA = FeatureCard(
                      title: 'Feature A: Analytics Dashboard',
                      description:
                          'Enterprise charts, telemetry and KPI trend analysis. Enabled for KGF & GKF; disabled for FGK.',
                      icon: Icons.insights,
                      isEnabled: flags.analyticsDashboard,
                      flagKey: 'analyticsDashboard',
                      accentColor: tenant.primaryColor,
                      onAccess: () {
                        if (flags.analyticsDashboard) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
                          );
                        } else {
                          _showFeatureDisabledDialog(
                            context,
                            'Feature A: Analytics Dashboard',
                            tenant.displayName,
                            'analyticsDashboard',
                          );
                        }
                      },
                    );

                    final cardB = FeatureCard(
                      title: 'Feature B: In-App Purchases',
                      description:
                          'In-app billing, paywalls, and tier upgrades. Enabled for FGK & GKF; disabled for KGF.',
                      icon: Icons.shopping_bag_outlined,
                      isEnabled: flags.inAppPurchases,
                      flagKey: 'inAppPurchases',
                      accentColor: tenant.secondaryColor,
                      onAccess: () {
                        if (flags.inAppPurchases) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const PurchasesScreen()),
                          );
                        } else {
                          _showFeatureDisabledDialog(
                            context,
                            'Feature B: In-App Purchases',
                            tenant.displayName,
                            'inAppPurchases',
                          );
                        }
                      },
                    );

                    final cardBiometric = FeatureCard(
                      title: 'Biometric Fast Sign-In',
                      description:
                          'Device biometric authentication (Fingerprint, TouchID, FaceID) during portal login.',
                      icon: Icons.fingerprint,
                      isEnabled: flags.biometricAuth,
                      flagKey: 'biometricAuth',
                      accentColor: tenant.primaryColor,
                      onAccess: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              flags.biometricAuth
                                  ? 'Biometric hardware verified & active for ${tenant.displayName}'
                                  : 'Biometrics unavailable for ${tenant.displayName}',
                            ),
                          ),
                        );
                      },
                    );

                    final cardReports = FeatureCard(
                      title: 'Enterprise Report Export',
                      description:
                          'Automated PDF summaries, CSV data extraction, and tenant audit compliance logs.',
                      icon: Icons.file_download_outlined,
                      isEnabled: flags.exportReports,
                      flagKey: 'exportReports',
                      accentColor: tenant.accentColor,
                      onAccess: () {
                        if (flags.exportReports) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Exporting report for ${tenant.displayName}...'),
                              backgroundColor: tenant.primaryColor,
                            ),
                          );
                        } else {
                          _showFeatureDisabledDialog(
                            context,
                            'Enterprise Report Export',
                            tenant.displayName,
                            'exportReports',
                          );
                        }
                      },
                    );

                    if (info.isMobile) {
                      return Column(
                        children: [
                          cardA,
                          SizedBox(height: 8.h),
                          cardB,
                          SizedBox(height: 8.h),
                          cardBiometric,
                          SizedBox(height: 8.h),
                          cardReports,
                        ],
                      );
                    }

                    // Tablet & Desktop: 2-column layout with equal heights
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: cardA),
                            SizedBox(width: 10.w),
                            Expanded(child: cardB),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: cardBiometric),
                            SizedBox(width: 10.w),
                            Expanded(child: cardReports),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 18.h),

                // Section 3: Architecture Inspection Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(14.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Active Build & Runtime Architecture',
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings_outlined),
                              iconSize: 18.r,
                              onPressed: () => VariantSwitcherModal.show(context),
                            ),
                          ],
                        ),
                        const Divider(height: 12),
                        _buildArchitectureRow(
                          context,
                          'Active Gradle Variant',
                          appState.config.variantName,
                          highlight: true,
                        ),
                        _buildArchitectureRow(
                          context,
                          'Android Application ID',
                          appState.config.effectiveApplicationId,
                        ),
                        _buildArchitectureRow(
                          context,
                          'Environment Base URL',
                          appState.config.apiBaseUrl,
                        ),
                        _buildArchitectureRow(
                          context,
                          'Logging & Debugging',
                          env.enableLogging ? 'Verbose Logs Active' : 'Production Suppressed',
                        ),
                        _buildArchitectureRow(
                          context,
                          'Responsive Layout Engine',
                          'responsive_flutter_ui (Bounded Scaling)',
                        ),
                        _buildArchitectureRow(
                          context,
                          'Tenant Theme Palette',
                          'Primary: #${tenant.primaryColor.toARGB32().toRadixString(16).substring(2).toUpperCase()} • Secondary: #${tenant.secondaryColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, {required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color?.withValues(alpha: 0.8) ?? Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.r, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5.sp,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Icon(icon, color: color, size: 14.r),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArchitectureRow(BuildContext context, String key, String value, {bool highlight = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: ResponsiveBuilder(
        builder: (context, info) {
          if (info.isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontFamily: 'monospace',
                    fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
                    color: highlight ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130.w,
                child: Text(
                  key,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'monospace',
                    fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
                    color: highlight ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
