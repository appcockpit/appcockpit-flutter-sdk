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
