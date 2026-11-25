import 'package:flutter/material.dart';

import '../maintenance_schedule.dart';
import '../models.dart';

class MaintenanceBannerTheme {
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? messageColor;

  const MaintenanceBannerTheme({
    this.backgroundColor,
    this.titleColor,
    this.messageColor,
  });
}

/// Slim banner at the top of the app announcing a scheduled maintenance
/// window.
class MaintenanceBanner extends StatelessWidget {
  final MaintenanceResponse maintenanceInfo;
  final VoidCallback onDismiss;
  final MaintenanceBannerTheme? theme;

  const MaintenanceBanner({
    super.key,
    required this.maintenanceInfo,
    required this.onDismiss,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = Localizations.of<MaterialLocalizations>(
            context, MaterialLocalizations) ??
        const DefaultMaterialLocalizations();
    final use24h = MediaQuery.maybeOf(context)?.alwaysUse24HourFormat ?? false;
    final when = formatMaintenanceWindow(
      maintenanceInfo.startsAt!,
      maintenanceInfo.endsAt,
      l10n,
      alwaysUse24HourFormat: use24h,
    );
    final title = (maintenanceInfo.title?.isNotEmpty ?? false)
        ? maintenanceInfo.title!
        : 'Scheduled maintenance';
    final description = maintenanceInfo.description;
    final messageColor = theme?.messageColor ?? const Color(0xFFD1D5DB);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Material(
          color: theme?.backgroundColor ?? const Color(0xFF1F2937),
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          child: Semantics(
            liveRegion: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme?.titleColor ?? Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description != null && description.isNotEmpty
                              ? '$when · $description'
                              : when,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: messageColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onDismiss,
                    tooltip: l10n.closeButtonTooltip,
                    icon: Icon(Icons.close, size: 18, color: messageColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
