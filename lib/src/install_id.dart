import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

const _installIdKey = 'ac_install_id';

Future<String?>? _cached;

/// Random UUID v4. Not security-sensitive: it only tells installs apart.
String randomUuid([Random? random]) {
  final r = random ?? Random.secure();
  final bytes = List<int>.generate(16, (_) => r.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-${hex.substring(20)}';
}

/// An anonymous ID for this app install, created on first use and kept in
/// SharedPreferences. Appcockpit uses it only to count monthly active
/// devices; it isn't derived from the device or linked to your users.
Future<String?> getInstallId() => _cached ??= _loadInstallId();

Future<String?> _loadInstallId() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_installIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = randomUuid();
    await prefs.setString(_installIdKey, id);
    return id;
  } catch (e) {
    return null;
  }
}

/// Headers sent with every Appcockpit request.
Future<Map<String, String>> sdkHeaders(String apiToken, String clientVersion) async {
  final installId = await getInstallId();
  return {
    'x-api-token': apiToken,
    'x-client-version': clientVersion,
    'Content-Type': 'application/json',
    if (installId != null) 'x-install-id': installId,
  };
}

/// For tests.
void resetInstallIdCache() => _cached = null;
