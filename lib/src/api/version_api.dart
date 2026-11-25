import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../install_id.dart';
import '../models.dart';

Future<VersionResponse?> fetchVersion(
  AppInfo info,
  String apiToken, {
  http.Client? client,
}) async {
  try {
    final uri = Uri.parse('$apiBaseUrl/v2/versions').replace(
      queryParameters: {
        'app_id': info.appId,
        'app_version': info.appVersion,
        'platform': info.platform,
        'environment': info.environment,
      },
    );

    final response = await (client?.get ?? http.get)(uri, headers: await sdkHeaders(apiToken, clientVersion));

    if (response.statusCode != 200) {
      return null;
    }

    return VersionResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  } catch (e) {
    return null;
  }
}
