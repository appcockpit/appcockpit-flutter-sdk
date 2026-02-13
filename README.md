# AppCockpit Flutter SDK

A Flutter SDK for managing app version updates, maintenance mode, and user authentication tracking.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  appcockpit: ^1.0.0
```

## Quick Start

```dart
import 'package:appcockpit/appcockpit.dart';

const appInfo = AppInfo(
  platform: 'ios',
  appId: 'com.example.myapp',
  appstoreId: '123456789',
  appVersion: '2.5.0',
  environment: 'production',
  userId: 'user_12345', // optional
);

const maintenanceInfo = MaintenanceInfo(
  appId: 'com.example.myapp',
  environment: 'production',
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MaintenanceWrapper(
        info: maintenanceInfo,
        apiToken: 'your-api-token',
        child: AppUpdateWrapper(
          info: appInfo,
          apiToken: 'your-api-token',
          languageKey: 'en',
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
```

## Features

### App Version Updates

The `AppUpdateWrapper` widget checks for new app versions on mount and displays a full-screen update prompt when one is available.

- **Force updates** show a non-dismissible screen requiring the user to update.
- **Optional updates** can be dismissed. Once dismissed, the same version won't be shown again.

```dart
AppUpdateWrapper(
  info: appInfo,
  apiToken: 'your-api-token',
  languageKey: 'de', // optional, defaults to English
  buttonTheme: const UpdateButtonTheme(
    backgroundColor: Color(0xFFFF6600),
    textColor: Colors.white,
  ),
  customUpdateScreen: (context, versionInfo, appInfo, onUpdate, onClose) {
    // Return your custom update widget
  },
  child: const MyApp(),
)
```

### Standalone Version Check

For cases where you don't want to use `AppUpdateWrapper`, use `checkVersionUpdate` to show a native alert dialog instead.

```dart
await checkVersionUpdate(
  context,
  appInfo,
  'your-api-token',
  languageKey: 'en',
);
```

- Force updates show a non-dismissible alert that reopens after pressing "Update Now".
- Optional updates can be dismissed. Dismissed versions are persisted.

### Maintenance Mode

The `MaintenanceWrapper` widget checks if the app is in maintenance mode. When active, it displays a full-screen overlay and polls every 30 seconds until maintenance ends.

```dart
MaintenanceWrapper(
  info: maintenanceInfo,
  apiToken: 'your-api-token',
  theme: const MaintenanceTheme(
    backgroundColor: Color(0xFF1a1a2e),
    titleColor: Colors.white,
    messageColor: Color(0xFFCCCCCC),
    linkColor: Color(0xFF4ea8de),
  ),
  customMaintenanceScreen: (context, maintenanceInfo) {
    // Return your custom maintenance widget
  },
  child: const MyApp(),
)
```

### User Authentication Tracking

When `userId` is provided in `AppInfo`, the SDK automatically calls the authenticate endpoint on mount. This is a fire-and-forget operation that does not affect the UI.

## Localization

The SDK supports 20 languages for built-in update prompts. Pass a language key to `AppUpdateWrapper` or `checkVersionUpdate`:

`en`, `es`, `fr`, `de`, `it`, `pt`, `ru`, `ja`, `ko`, `zh`, `ar`, `hi`, `nl`, `sv`, `da`, `no`, `fi`, `pl`, `tr`, `he`

## Learn More

Visit [appcockpit.dev](https://appcockpit.dev) for more information.
