import 'package:flutter/material.dart';
import 'package:responsive_flutter_ui/responsive_flutter_ui.dart';
import '../../core/state/app_state.dart';
import '../widgets/tenant_badge.dart';

/// Feature B: In-App Billing & Enterprise Subscriptions.
class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final tenant = appState.config.tenant;
    final env = appState.config.environment;
    final theme = Theme.of(context);

    // Route guard safety check:
    if (!tenant.featureFlags.inAppPurchases) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Restricted')),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_clock, size: 48.r, color: Colors.orange),
                SizedBox(height: 12.h),
                Text(
                  'Feature B Unavailable for ${tenant.displayName}',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6.h),
                Text(
                  'In-App Billing is not configured for tenant ${tenant.displayName}. Only FGK and GKF provide in-app purchase capabilities.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Return to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('In-App Purchases & Billing', style: TextStyle(fontSize: 15.sp)),
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
            maxWidth: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Subscription Tiers',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Feature B is enabled for ${tenant.displayName}. Select a package to upgrade your tenant capacity.',
                  style: TextStyle(fontSize: 11.5.sp, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
                SizedBox(height: 14.h),

                ResponsiveBuilder(
                  builder: (context, info) {
                    final plan1 = _buildPlanCard(
                      context,
                      planName: 'Starter Pro',
                      price: r'$49',
                      cadence: '/month',
                      isCurrent: true,
                      features: [
                        'Up to 2,500 active API calls',
                        'Standard SLA support',
                        'Single region deployment',
                      ],
                      buttonText: 'Current Plan',
                      color: tenant.primaryColor,
                    );

                    final plan2 = _buildPlanCard(
                      context,
                      planName: 'Enterprise Unlimited',
                      price: r'$199',
                      cadence: '/month',
                      isCurrent: false,
                      features: [
                        'Unlimited multi-tenant calls',
                        'Dedicated account manager',
                        'Multi-cloud automatic failover',
                        'Custom SSO & SAML 2.0',
                      ],
                      buttonText: 'Upgrade Now',
                      color: tenant.secondaryColor,
                    );

                    if (info.isDesktop) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: plan1),
                          SizedBox(width: 12.w),
                          Expanded(child: plan2),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        plan1,
                        SizedBox(height: 10.h),
                        plan2,
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String planName,
    required String price,
    required String cadence,
    required bool isCurrent,
    required List<String> features,
    required String buttonText,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  planName,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                if (isCurrent)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  price,
                  style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w900),
                ),
                Text(
                  cadence,
                  style: TextStyle(fontSize: 11.sp, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            const Divider(height: 1),
            SizedBox(height: 8.h),
            ...features.map(
              (f) => Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 13.r, color: color),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        f,
                        style: TextStyle(fontSize: 11.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 32.h),
              child: SizedBox(
                width: double.infinity,
                child: isCurrent
                    ? OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                        ),
                        child: Text(buttonText, style: TextStyle(fontSize: 11.5.sp)),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Simulated upgrade for $planName processed!'),
                              backgroundColor: color,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                        ),
                        child: Text(buttonText, style: TextStyle(fontSize: 11.5.sp)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
