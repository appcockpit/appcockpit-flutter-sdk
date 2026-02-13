class AppInfo {
  final String platform;
  final String appId;
  final String appstoreId;
  final String appVersion;
  final String environment;
  final String? userId;

  const AppInfo({
    required this.platform,
    required this.appId,
    required this.appstoreId,
    required this.appVersion,
    required this.environment,
    this.userId,
  });
}

class MaintenanceInfo {
  final String appId;
  final String environment;

  const MaintenanceInfo({
    required this.appId,
    required this.environment,
  });
}

class VersionResponse {
  final String version;
  final String platform;
  final bool forceUpdate;
  final String? defaultUpdateMessage;
  final Map<String, String>? updateMessages;

  const VersionResponse({
    required this.version,
    required this.platform,
    required this.forceUpdate,
    this.defaultUpdateMessage,
    this.updateMessages,
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) {
    return VersionResponse(
      version: json['version'] as String,
      platform: json['platform'] as String,
      forceUpdate: json['force_update'] as bool,
      defaultUpdateMessage: json['default_update_message'] as String?,
      updateMessages: json['update_messages'] != null
          ? Map<String, String>.from(json['update_messages'] as Map)
          : null,
    );
  }
}

class MaintenanceLink {
  final String title;
  final String url;

  const MaintenanceLink({required this.title, required this.url});

  factory MaintenanceLink.fromJson(Map<String, dynamic> json) {
    return MaintenanceLink(
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }
}

class MaintenanceResponse {
  final bool active;
  final String? title;
  final String? description;
  final List<MaintenanceLink>? links;

  const MaintenanceResponse({
    required this.active,
    this.title,
    this.description,
    this.links,
  });

  factory MaintenanceResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceResponse(
      active: json['active'] as bool,
      title: json['title'] as String?,
      description: json['description'] as String?,
      links: json['links'] != null
          ? (json['links'] as List)
              .map((l) =>
                  MaintenanceLink.fromJson(l as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class AuthenticateResponse {
  final bool success;
  final String userId;
  final String platform;
  final String appVersion;

  const AuthenticateResponse({
    required this.success,
    required this.userId,
    required this.platform,
    required this.appVersion,
  });

  factory AuthenticateResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticateResponse(
      success: json['success'] as bool,
      userId: json['user_id'] as String,
      platform: json['platform'] as String,
      appVersion: json['app_version'] as String,
    );
  }
}
