import 'package:flutter/material.dart';

import '../api/authenticate_api.dart';
import '../api/version_api.dart';
import '../models.dart';
import '../storage_helper.dart';
import '../utils/store_launcher.dart';
import 'app_update_screen.dart';

typedef CustomUpdateScreenBuilder = Widget Function(
  BuildContext context,
  VersionResponse versionInfo,
  AppInfo appInfo,
  VoidCallback onUpdate,
  VoidCallback onClose,
);

class AppUpdateWrapper extends StatefulWidget {
  final AppInfo info;
  final String apiToken;
  final String? languageKey;
  final UpdateButtonTheme? buttonTheme;
  final CustomUpdateScreenBuilder? customUpdateScreen;
  final Widget child;

  const AppUpdateWrapper({
    super.key,
    required this.info,
    required this.apiToken,
    required this.child,
    this.languageKey,
    this.buttonTheme,
    this.customUpdateScreen,
  });

  @override
  State<AppUpdateWrapper> createState() => _AppUpdateWrapperState();
}

class _AppUpdateWrapperState extends State<AppUpdateWrapper> {
  VersionResponse? _versionInfo;
  bool _showUpdateScreen = false;

  @override
  void initState() {
    super.initState();
    _fetchVersionInfo();
    _authenticateIfNeeded();
  }

  @override
  void didUpdateWidget(AppUpdateWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info || oldWidget.apiToken != widget.apiToken) {
      _fetchVersionInfo();
      _authenticateIfNeeded();
    }
  }

  Future<void> _fetchVersionInfo() async {
    final response = await fetchVersion(widget.info, widget.apiToken);
    if (response == null || !mounted) return;

    if (!response.forceUpdate) {
      final wasDismissed = await isVersionDismissed(
        widget.info.appId,
        response.version,
      );
      if (wasDismissed) {
        setState(() => _versionInfo = response);
        return;
      }
    }

    setState(() {
      _versionInfo = response;
      _showUpdateScreen = true;
    });
  }

  Future<void> _authenticateIfNeeded() async {
    final userId = widget.info.userId;
    if (userId != null) {
      await authenticate(widget.info, widget.apiToken, userId);
    }
  }

  void _handleUpdate() {
    if (_versionInfo != null && !_versionInfo!.forceUpdate) {
      storeDismissedVersion(widget.info.appId, _versionInfo!.version);
    }

    openAppStore(widget.info.platform, widget.info.appstoreId);

    if (_versionInfo != null && !_versionInfo!.forceUpdate) {
      setState(() => _showUpdateScreen = false);
    }
  }

  void _handleClose() {
    if (_versionInfo != null && !_versionInfo!.forceUpdate) {
      storeDismissedVersion(widget.info.appId, _versionInfo!.version);
      setState(() => _showUpdateScreen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_versionInfo == null || !_showUpdateScreen) {
      return widget.child;
    }

    if (widget.customUpdateScreen != null) {
      return widget.customUpdateScreen!(
        context,
        _versionInfo!,
        widget.info,
        _handleUpdate,
        _handleClose,
      );
    }

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: AppUpdateScreen(
            versionInfo: _versionInfo!,
            languageKey: widget.languageKey,
            buttonTheme: widget.buttonTheme,
            onUpdate: _handleUpdate,
            onClose: _handleClose,
          ),
        ),
      ],
    );
  }
}
