import 'package:flutter/material.dart';

import 'api/version_api.dart';
import 'constants.dart';
import 'models.dart';
import 'storage_helper.dart';
import 'utils/store_launcher.dart';

Future<void> checkVersionUpdate(
  BuildContext context,
  AppInfo info,
  String apiToken, {
  String? languageKey,
}) async {
  final response = await fetchVersion(info, apiToken);
  if (response == null) return;

  if (!response.forceUpdate) {
    final wasDismissed = await isVersionDismissed(
      info.appId,
      response.version,
    );
    if (wasDismissed) return;
  }

  if (!context.mounted) return;

  final activeKey = languageKey ?? 'en';
  final strings = localizedStrings[activeKey] ?? localizedStrings['en']!;

  final title = response.forceUpdate
      ? strings.updateRequired
      : strings.updateAvailable;

  final defaultDescription = response.forceUpdate
      ? strings.forceUpdateDescription
      : strings.updateDescription;

  final String updateMessage;
  if (response.updateMessages != null && languageKey != null) {
    updateMessage = response.updateMessages![languageKey] ??
        response.defaultUpdateMessage ??
        defaultDescription;
  } else {
    updateMessage = response.defaultUpdateMessage ?? defaultDescription;
  }

  if (response.forceUpdate) {
    var keepShowing = true;
    while (keepShowing) {
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(title),
            content: Text(updateMessage),
            actions: [
              TextButton(
                onPressed: () {
                  openAppStore(info.platform, info.appstoreId);
                  Navigator.of(dialogContext).pop();
                },
                child: Text(strings.updateNow),
              ),
            ],
          ),
        ),
      );
    }
  } else {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(updateMessage),
        actions: [
          TextButton(
            onPressed: () {
              storeDismissedVersion(info.appId, response.version);
              Navigator.of(dialogContext).pop();
            },
            child: Text(strings.later),
          ),
          TextButton(
            onPressed: () {
              openAppStore(info.platform, info.appstoreId);
              storeDismissedVersion(info.appId, response.version);
              Navigator.of(dialogContext).pop();
            },
            child: Text(strings.updateNow),
          ),
        ],
      ),
    );
  }
}
