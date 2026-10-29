import 'package:flutter/material.dart';
import 'package:responsive_flutter_ui/responsive_flutter_ui.dart';
import '../../core/config/app_environment.dart';
import '../../core/config/tenant_config.dart';

/// Visually distinct badge representing the active Environment and Tenant.
class TenantBadge extends StatelessWidget {
  final TenantConfig tenant;
  final AppEnvironment environment;
  final bool compact;

  const TenantBadge({
    super.key,
    required this.tenant,
    required this.environment,
    this.compact = false,
  });

  Color _getEnvColor() {
    switch (environment) {
      case AppEnvironment.dev:
        return const Color(0xFFEAB308); // Yellow/Amber
      case AppEnvironment.staging:
        return const Color(0xFF8B5CF6); // Purple
      case AppEnvironment.prod:
        return const Color(0xFF10B981); // Emerald
    }
  }

  @override
  Widget build(BuildContext context) {
    final envColor = _getEnvColor();

    if (compact) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
        decoration: BoxDecoration(
          color: envColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: envColor.withValues(alpha: 0.6), width: 1.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5.r,
              height: 5.r,
              decoration: BoxDecoration(color: envColor, shape: BoxShape.circle),
            ),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                '${tenant.displayName} • ${environment.code.toUpperCase()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: envColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 9.5.sp,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.35),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tenant Chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: tenant.primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              tenant.displayName,
              style: TextStyle(
                color: tenant.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 10.sp,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          // Environment Pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: envColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: envColor.withValues(alpha: 0.5), width: 1.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5.r,
                  height: 5.r,
                  decoration: BoxDecoration(color: envColor, shape: BoxShape.circle),
                ),
                SizedBox(width: 3.w),
                Text(
                  environment.code.toUpperCase(),
                  style: TextStyle(
                    color: envColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
