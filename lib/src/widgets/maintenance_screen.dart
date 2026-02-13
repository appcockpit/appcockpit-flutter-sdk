import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models.dart';

class MaintenanceTheme {
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? messageColor;
  final Color? linkColor;

  const MaintenanceTheme({
    this.backgroundColor,
    this.titleColor,
    this.messageColor,
    this.linkColor,
  });
}

class MaintenanceScreen extends StatelessWidget {
  final MaintenanceResponse maintenanceInfo;
  final MaintenanceTheme? theme;

  const MaintenanceScreen({
    super.key,
    required this.maintenanceInfo,
    this.theme,
  });

  Future<void> _handleLinkPress(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Widget build(BuildContext context) {
    const defaultTitle = 'Under Maintenance';
    const defaultMessage =
        "We're currently performing scheduled maintenance. Please check back soon.";

    final linkColor = theme?.linkColor ?? const Color(0xFF007AFF);

    return Scaffold(
      backgroundColor: theme?.backgroundColor ?? Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '\u{1F527}',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 32),
                Text(
                  maintenanceInfo.title ?? defaultTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme?.titleColor ?? const Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  maintenanceInfo.description ?? defaultMessage,
                  style: TextStyle(
                    fontSize: 18,
                    color: theme?.messageColor ?? const Color(0xFF666666),
                    height: 1.44,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (maintenanceInfo.links != null &&
                    maintenanceInfo.links!.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  ...maintenanceInfo.links!.map(
                    (link) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () => _handleLinkPress(link.url),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    link.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: linkColor,
                                    ),
                                  ),
                                  Text(
                                    '\u2192',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: linkColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
