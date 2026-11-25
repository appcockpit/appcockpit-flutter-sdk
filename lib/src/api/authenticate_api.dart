import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../install_id.dart';
import '../models.dart';

Future<AuthenticateResponse?> authenticate(
  AppInfo info,
  String apiToken,
  String userId, {
  http.Client? client,
}) async {
  try {
    final uri = Uri.parse('$apiBaseUrl/v2/authenticate');

    final response = await (client?.post ?? http.post)(
      uri,
      headers: await sdkHeaders(apiToken, clientVersion),
      body: jsonEncode({
        'user_id': userId,
        'platform': info.platform,
        'app_version': info.appVersion,
        'environment': info.environment,
      }),
    );

    if (response.statusCode != 200) {
      return null;
    }

    return AuthenticateResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  } catch (e) {
    return null;
  }
}
