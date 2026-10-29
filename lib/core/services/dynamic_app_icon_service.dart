import 'package:flutter/foundation.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import '../config/tenant_config.dart';

/// Service managing Duolingo-style runtime app icon & app name changes.
///
/// On Android, this toggles `<activity-alias>` entries (.kgf, .fgk, .gkf, .DEFAULT)
/// defined in AndroidManifest.xml without reinstalling the app.
class DynamicAppIconService {
  DynamicAppIconService._();

  /// Change the launcher icon and label on the mobile device's home screen.
  static Future<bool> setTenantLauncherIcon(TenantType tenant) async {
    try {
      final isSupported = await FlutterDynamicIconPlus.supportsAlternateIcons;
      if (!isSupported) {
        debugPrint('[DynamicAppIcon] Alternate icons not supported on this platform.');
        return false;
      }

      final iconName = tenant.name.toLowerCase();
      debugPrint('[DynamicAppIcon] Switching home screen launcher icon and label to: $iconName');
      await FlutterDynamicIconPlus.setAlternateIconName(
        iconName: iconName,
        blacklistBrands: ['Redmi', 'Xiaomi'],
      );
      return true;
    } catch (e, stack) {
      debugPrint('[DynamicAppIcon] Error switching launcher icon: $e\n$stack');
      return false;
    }
  }

  /// Reset the launcher icon back to the default build flavor launcher.
  static Future<bool> resetToDefault() async {
    try {
      final isSupported = await FlutterDynamicIconPlus.supportsAlternateIcons;
      if (!isSupported) return false;

      debugPrint('[DynamicAppIcon] Resetting home screen launcher icon to DEFAULT');
      await FlutterDynamicIconPlus.setAlternateIconName(
        iconName: null,
        blacklistBrands: ['Redmi', 'Xiaomi'],
      );
      return true;
    } catch (e) {
      debugPrint('[DynamicAppIcon] Error resetting icon: $e');
      return false;
    }
  }

  /// Get the currently active alternate icon name, if any.
  static Future<String?> getCurrentIconName() async {
    try {
      return await FlutterDynamicIconPlus.alternateIconName;
    } catch (e) {
      return null;
    }
  }
}
