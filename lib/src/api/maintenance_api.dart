import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models.dart';

Future<MaintenanceResponse?> getMaintenanceMode(
  MaintenanceInfo info,
  String apiToken,
) async {
  try {
    final uri = Uri.parse('$apiBaseUrl/v2/maintenance').replace(
      queryParameters: {
        'app_id': info.appId,
        'environment': info.environment,
      },
    );

    final response = await http.get(uri, headers: {
      'x-api-token': apiToken,
      'x-client-version': clientVersion,
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      return null;
    }

    return MaintenanceResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  } catch (e) {
    return null;
  }
}
