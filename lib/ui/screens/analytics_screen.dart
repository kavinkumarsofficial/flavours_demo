import 'package:flutter/material.dart';
import 'package:responsive_flutter_ui/responsive_flutter_ui.dart';
import '../../core/state/app_state.dart';
import '../widgets/tenant_badge.dart';

/// Feature A: Advanced Analytics and Enterprise Reporting.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final tenant = appState.config.tenant;
    final env = appState.config.environment;
    final theme = Theme.of(context);

    // Route guard safety check:
    if (!tenant.featureFlags.analyticsDashboard) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_person_outlined, size: 48.r, color: Colors.red),
                SizedBox(height: 12.h),
                Text(
                  'Feature Disabled for ${tenant.displayName}',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6.h),
                Text(
                  'The Advanced Analytics Dashboard feature is not enabled under the ${tenant.displayName} tenant license.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back to Dashboard'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics Dashboard', style: TextStyle(fontSize: 15.sp)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: TenantBadge(tenant: tenant, environment: env, compact: true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Center(
          child: ResponsiveContainer(
            maxWidth: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enterprise Metrics & KPIs',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Feature A is active for ${tenant.displayName}. Real-time telemetry is running.',
                  style: TextStyle(fontSize: 11.5.sp, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
                SizedBox(height: 14.h),

                ResponsiveBuilder(
                  builder: (context, info) {
                    final card1 = _buildMetricCard(
                      context,
                      title: 'Active Sessions',
                      value: '18,492',
                      change: '+14.2%',
                      isPositive: true,
                      icon: Icons.people_outline,
                      color: tenant.primaryColor,
                    );
                    final card2 = _buildMetricCard(
                      context,
                      title: 'Conversion Rate',
                      value: '4.82%',
                      change: '+2.1%',
                      isPositive: true,
                      icon: Icons.trending_up,
                      color: tenant.secondaryColor,
                    );
                    final card3 = _buildMetricCard(
                      context,
                      title: 'API Latency',
                      value: '68 ms',
                      change: '-12 ms',
                      isPositive: true,
                      icon: Icons.speed,
                      color: tenant.accentColor,
                    );

                    if (info.isDesktop) {
                      return Row(
                        children: [
                          Expanded(child: card1),
                          SizedBox(width: 10.w),
                          Expanded(child: card2),
                          SizedBox(width: 10.w),
                          Expanded(child: card3),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        card1,
                        SizedBox(height: 8.h),
                        card2,
                        SizedBox(height: 8.h),
                        card3,
                      ],
                    );
                  },
                ),

                SizedBox(height: 16.h),
                // Visual simulated graph card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Traffic Volume Distribution (7 Days)',
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.bar_chart, color: tenant.primaryColor, size: 17.r),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 100.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildBar(context, 'Mon', 0.45, tenant.primaryColor),
                              _buildBar(context, 'Tue', 0.65, tenant.primaryColor),
                              _buildBar(context, 'Wed', 0.55, tenant.primaryColor),
                              _buildBar(context, 'Thu', 0.85, tenant.primaryColor),
                              _buildBar(context, 'Fri', 0.95, tenant.primaryColor),
                              _buildBar(context, 'Sat', 0.40, tenant.primaryColor),
                              _buildBar(context, 'Sun', 0.35, tenant.primaryColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context, String day, double fraction, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 16.w,
          height: 75.h * fraction,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          day,
          style: TextStyle(fontSize: 9.5.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String change,
    required bool isPositive,
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
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
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 11.r,
                  color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                ),
                SizedBox(width: 3.w),
                Text(
                  change,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  'vs last week',
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
