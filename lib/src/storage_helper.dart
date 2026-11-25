import 'package:shared_preferences/shared_preferences.dart';

String _getDismissedVersionKey(String appId, String version) =>
    'ac_dismissed_version_${appId}_$version';

Future<void> storeDismissedVersion(String appId, String version) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_getDismissedVersionKey(appId, version), true);
  } catch (e) {
    // Silently fail
  }
}

Future<bool> isVersionDismissed(String appId, String version) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_getDismissedVersionKey(appId, version)) ?? false;
  } catch (e) {
    return false;
  }
}

// A dismissed maintenance banner stays hidden for that window only: a new or
// moved window (different start time) is announced again.
String _getDismissedMaintenanceKey(String appId, DateTime startsAt) =>
    'ac_dismissed_maintenance_${appId}_${startsAt.toUtc().toIso8601String()}';

Future<void> storeDismissedMaintenance(String appId, DateTime startsAt) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_getDismissedMaintenanceKey(appId, startsAt), true);
  } catch (e) {
    // Silently fail
  }
}

Future<bool> isMaintenanceDismissed(String appId, DateTime startsAt) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_getDismissedMaintenanceKey(appId, startsAt)) ??
        false;
  } catch (e) {
    return false;
  }
}
