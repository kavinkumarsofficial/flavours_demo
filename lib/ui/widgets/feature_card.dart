import 'package:flutter/material.dart';
import 'package:responsive_flutter_ui/responsive_flutter_ui.dart';

/// Reusable card displaying feature status, description, and navigation trigger.
class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isEnabled;
  final String flagKey;
  final VoidCallback? onAccess;
  final Color? accentColor;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isEnabled,
    required this.flagKey,
    this.onAccess,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = accentColor ?? theme.colorScheme.primary;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(
          color: isEnabled
              ? primary.withValues(alpha: 0.25)
              : theme.colorScheme.outline.withValues(alpha: 0.4),
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(11.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? primary.withValues(alpha: 0.12)
                        : theme.colorScheme.outline.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: Icon(
                    icon,
                    size: 16.r,
                    color: isEnabled ? primary : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          color: isEnabled
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        'Flag: $flagKey',
                        style: TextStyle(
                          fontSize: 9.5.sp,
                          fontFamily: 'monospace',
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6.w),
                // Status pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? const Color(0xFF10B981).withValues(alpha: 0.12)
                        : const Color(0xFFEF4444).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: isEnabled
                          ? const Color(0xFF10B981).withValues(alpha: 0.4)
                          : const Color(0xFFEF4444).withValues(alpha: 0.4),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isEnabled ? Icons.check_circle : Icons.cancel,
                        size: 9.r,
                        color: isEnabled ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        isEnabled ? 'ACTIVE' : 'DISABLED',
                        style: TextStyle(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w700,
                          color: isEnabled ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.h),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.25,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 8.h),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 32.h),
              child: SizedBox(
                width: double.infinity,
                child: isEnabled
                    ? ElevatedButton(
                        onPressed: onAccess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                        ),
                        child: Text(
                          'Launch Feature',
                          style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600),
                        ),
                      )
                    : OutlinedButton(
                        onPressed: onAccess,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                          side: BorderSide(
                            color: theme.colorScheme.outline.withValues(alpha: 0.4),
                            width: 1.w,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock_outline, size: 11.r),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                'Unavailable for Tenant',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
