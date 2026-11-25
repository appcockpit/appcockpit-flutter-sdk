import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api/maintenance_api.dart';
import '../maintenance_schedule.dart';
import '../models.dart';
import '../storage_helper.dart';
import 'maintenance_banner.dart';
import 'maintenance_screen.dart';

typedef CustomMaintenanceScreenBuilder = Widget Function(
  BuildContext context,
  MaintenanceResponse maintenanceInfo,
);

/// Builds a replacement for the upcoming-maintenance banner. Call [onDismiss]
/// to hide it for this window.
typedef CustomMaintenanceBannerBuilder = Widget Function(
  BuildContext context,
  MaintenanceResponse maintenanceInfo,
  VoidCallback onDismiss,
);

class MaintenanceWrapper extends StatefulWidget {
  final MaintenanceInfo info;
  final String apiToken;
  final MaintenanceTheme? theme;
  final CustomMaintenanceScreenBuilder? customMaintenanceScreen;

  /// Show a banner before a scheduled maintenance window. Default true.
  final bool showBanner;
  final MaintenanceBannerTheme? bannerTheme;
  final CustomMaintenanceBannerBuilder? customMaintenanceBanner;

  /// HTTP client for the API calls (mainly for tests).
  final http.Client? httpClient;
  final Widget child;

  const MaintenanceWrapper({
    super.key,
    required this.info,
    required this.apiToken,
    required this.child,
    this.theme,
    this.customMaintenanceScreen,
    this.showBanner = true,
    this.bannerTheme,
    this.customMaintenanceBanner,
    this.httpClient,
  });

  @override
  State<MaintenanceWrapper> createState() => _MaintenanceWrapperState();
}

class _MaintenanceWrapperState extends State<MaintenanceWrapper>
    with WidgetsBindingObserver {
  MaintenanceResponse? _response;
  DateTime? _dismissedStart;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void didUpdateWidget(MaintenanceWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info || oldWidget.apiToken != widget.apiToken) {
      _check();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Coming back to the app picks up maintenance scheduled in the meantime.
    if (state == AppLifecycleState.resumed) _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _check() async {
    _timer?.cancel();
    _timer = null;

    final response = await getMaintenanceMode(
      widget.info,
      widget.apiToken,
      client: widget.httpClient,
    );
    if (!mounted) return;

    DateTime? dismissed = _dismissedStart;
    final startsAt = response?.startsAt;
    if (response != null && response.upcoming && startsAt != null &&
        await isMaintenanceDismissed(widget.info.appId, startsAt)) {
      dismissed = startsAt;
    }
    if (!mounted) return;
    setState(() {
      _response = response;
      _dismissedStart = dismissed;
    });

    final delay = nextCheckDelay(response, DateTime.now());
    if (delay != null) _timer = Timer(delay, _check);
  }

  void _dismissBanner() {
    final startsAt = _response?.startsAt;
    if (startsAt == null) return;
    setState(() => _dismissedStart = startsAt);
    storeDismissedMaintenance(widget.info.appId, startsAt);
  }

  @override
  Widget build(BuildContext context) {
    final response = _response;
    switch (maintenanceStateFrom(response, DateTime.now())) {
      case MaintenanceStateKind.active:
        if (widget.customMaintenanceScreen != null) {
          return widget.customMaintenanceScreen!(context, response!);
        }
        return Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: MaintenanceScreen(
                maintenanceInfo: response!,
                theme: widget.theme,
              ),
            ),
          ],
        );
      case MaintenanceStateKind.upcoming:
        if (!widget.showBanner || _dismissedStart == response!.startsAt) {
          return widget.child;
        }
        return Stack(
          children: [
            widget.child,
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: widget.customMaintenanceBanner != null
                  ? widget.customMaintenanceBanner!(
                      context, response, _dismissBanner)
                  : MaintenanceBanner(
                      maintenanceInfo: response,
                      onDismiss: _dismissBanner,
                      theme: widget.bannerTheme,
                    ),
            ),
          ],
        );
      case MaintenanceStateKind.none:
        return widget.child;
    }
  }
}
