import 'package:flutter/material.dart';

import '../constants.dart';
import '../models.dart';

class UpdateButtonTheme {
  final Color? backgroundColor;
  final Color? textColor;

  const UpdateButtonTheme({this.backgroundColor, this.textColor});
}

class AppUpdateScreen extends StatelessWidget {
  final VersionResponse versionInfo;
  final String? languageKey;
  final UpdateButtonTheme? buttonTheme;
  final VoidCallback onUpdate;
  final VoidCallback onClose;

  const AppUpdateScreen({
    super.key,
    required this.versionInfo,
    required this.onUpdate,
    required this.onClose,
    this.languageKey,
    this.buttonTheme,
  });

  @override
  Widget build(BuildContext context) {
    final activeKey = languageKey ?? 'en';
    final strings = localizedStrings[activeKey] ?? localizedStrings['en']!;

    final title = versionInfo.forceUpdate
        ? strings.updateRequired
        : strings.updateAvailable;

    final defaultDescription = versionInfo.forceUpdate
        ? strings.forceUpdateDescription
        : strings.updateDescription;

    final String updateMessage;
    if (versionInfo.updateMessages != null && languageKey != null) {
      updateMessage = versionInfo.updateMessages![languageKey!] ??
          versionInfo.defaultUpdateMessage ??
          defaultDescription;
    } else {
      updateMessage = versionInfo.defaultUpdateMessage ?? defaultDescription;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      updateMessage,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF666666),
                        height: 1.44,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonTheme?.backgroundColor ??
                            const Color(0xFF007AFF),
                        foregroundColor:
                            buttonTheme?.textColor ?? Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        strings.updateNow,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (!versionInfo.forceUpdate) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: onClose,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          strings.later,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
