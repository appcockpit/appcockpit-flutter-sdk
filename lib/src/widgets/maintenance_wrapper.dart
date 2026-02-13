import 'dart:async';

import 'package:flutter/material.dart';

import '../api/maintenance_api.dart';
import '../models.dart';
import 'maintenance_screen.dart';

const _pollingIntervalMs = 30000;

typedef CustomMaintenanceScreenBuilder = Widget Function(
  BuildContext context,
  MaintenanceResponse maintenanceInfo,
);

class MaintenanceWrapper extends StatefulWidget {
  final MaintenanceInfo info;
  final String apiToken;
  final MaintenanceTheme? theme;
  final CustomMaintenanceScreenBuilder? customMaintenanceScreen;
  final Widget child;

  const MaintenanceWrapper({
    super.key,
    required this.info,
    required this.apiToken,
    required this.child,
    this.theme,
    this.customMaintenanceScreen,
  });

  @override
  State<MaintenanceWrapper> createState() => _MaintenanceWrapperState();
}

class _MaintenanceWrapperState extends State<MaintenanceWrapper> {
  MaintenanceResponse? _maintenanceInfo;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _checkMaintenanceMode();
  }

  @override
  void didUpdateWidget(MaintenanceWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info || oldWidget.apiToken != widget.apiToken) {
      _stopPolling();
      _checkMaintenanceMode();
    }
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  Future<void> _checkMaintenanceMode() async {
    final response = await getMaintenanceMode(widget.info, widget.apiToken);
    if (!mounted) return;

    if (response == null || !response.active) {
      setState(() => _maintenanceInfo = null);
      _stopPolling();
      return;
    }

    setState(() => _maintenanceInfo = response);
    _startPolling();
  }

  void _startPolling() {
    _stopPolling();
    _pollingTimer = Timer.periodic(
      const Duration(milliseconds: _pollingIntervalMs),
      (_) => _checkMaintenanceMode(),
    );
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    if (_maintenanceInfo == null || !_maintenanceInfo!.active) {
      return widget.child;
    }

    if (widget.customMaintenanceScreen != null) {
      return widget.customMaintenanceScreen!(context, _maintenanceInfo!);
    }

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: MaintenanceScreen(
            maintenanceInfo: _maintenanceInfo!,
            theme: widget.theme,
          ),
        ),
      ],
    );
  }
}
