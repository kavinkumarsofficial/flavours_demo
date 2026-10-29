import 'package:flutter/material.dart';
import 'package:responsive_flutter_ui/responsive_flutter_ui.dart';
import '../../core/config/app_environment.dart';
import '../../core/config/tenant_config.dart';
import '../../core/state/app_state.dart';

/// Modal bottom sheet allowing inspection and live-preview of all 9 build variants.
class VariantSwitcherModal extends StatelessWidget {
  const VariantSwitcherModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VariantSwitcherModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final currentConfig = appState.config;
    final theme = Theme.of(context);

    final tenants = [TenantType.kgf, TenantType.fgk, TenantType.gkf];
    final environments = [AppEnvironment.dev, AppEnvironment.staging, AppEnvironment.prod];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 32.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Multi-Tenant Matrix',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    '3 Environments × 3 Tenants = 9 Build Variants',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              IconButton(
                iconSize: 17.r,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          // Active variant card
          Container(
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: currentConfig.tenant.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: currentConfig.tenant.primaryColor.withValues(alpha: 0.3),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: currentConfig.tenant.primaryColor, size: 15.r),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active: ${currentConfig.variantName} (${currentConfig.environment.displayName} • ${currentConfig.tenant.displayName})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5.sp,
                          color: currentConfig.tenant.primaryColor,
                        ),
                      ),
                      Text(
                        'App ID: ${currentConfig.effectiveApplicationId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10.sp,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: ListView.separated(
              itemCount: 9,
              separatorBuilder: (context, index) => SizedBox(height: 5.h),
              itemBuilder: (context, index) {
                final env = environments[index ~/ 3];
                final tType = tenants[index % 3];
                final tConfig = TenantConfig.fromType(tType);

                final variantName =
                    '${env.code}${tConfig.id[0].toUpperCase()}${tConfig.id.substring(1)}';

                String appId = tConfig.applicationId;
                if (env == AppEnvironment.dev) {
                  appId = '$appId.dev';
                } else if (env == AppEnvironment.staging) {
                  appId = '$appId.staging';
                }

                final isSelected = currentConfig.environment == env &&
                    currentConfig.tenant.type == tType;

                return InkWell(
                  onTap: () {
                    appState.switchVariant(env, tType);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Switched to $variantName • Home screen icon & label updated!'),
                        backgroundColor: tConfig.primaryColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? tConfig.primaryColor.withValues(alpha: 0.12)
                          : theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected
                            ? tConfig.primaryColor
                            : theme.colorScheme.outline.withValues(alpha: 0.4),
                        width: isSelected ? 1.5.w : 1.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26.r,
                          height: 26.r,
                          decoration: BoxDecoration(
                            color: tConfig.primaryColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tConfig.displayName.substring(0, 1),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    variantName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5.sp,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: env.isProduction
                                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                                          : (env == AppEnvironment.staging
                                              ? const Color(0xFF8B5CF6).withValues(alpha: 0.2)
                                              : const Color(0xFFEAB308).withValues(alpha: 0.2)),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      env.code.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 8.5.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                appId,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: 'monospace',
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: tConfig.primaryColor, size: 16.r)
                        else
                          Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                            size: 16.r,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
