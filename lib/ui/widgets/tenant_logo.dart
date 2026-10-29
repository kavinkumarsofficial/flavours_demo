import 'package:flutter/material.dart';
import 'package:responsive_flutter_ui/responsive_flutter_ui.dart';
import '../../core/config/tenant_config.dart';

/// Reusable tenant logo widget with graceful asset loading and branding frame.
class TenantLogo extends StatelessWidget {
  final TenantConfig tenant;
  final double size;
  final bool showBorder;

  const TenantLogo({
    super.key,
    required this.tenant,
    this.size = 56,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size.r;

    return Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: BoxDecoration(
        color: tenant.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: showBorder
            ? Border.all(
                color: tenant.primaryColor.withValues(alpha: 0.4),
                width: 1.5.w,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: tenant.primaryColor.withValues(alpha: 0.15),
            blurRadius: 8.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(5.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.asset(
          tenant.logoPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Elegant fallback icon with tenant initial
            return Container(
              color: tenant.primaryColor,
              alignment: Alignment.center,
              child: Text(
                tenant.displayName.substring(0, 1),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: effectiveSize * 0.45,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
