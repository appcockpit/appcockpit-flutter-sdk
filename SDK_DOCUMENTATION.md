# AppCockpit React Native SDK

A React Native SDK for managing app version updates, maintenance mode, and user authentication tracking.

## Installation

```bash
npm install appcockpit-react-native-sdk
```

### Peer Dependencies

- `@react-native-async-storage/async-storage` >= 1.0.0
- `react` >= 16.9.0
- `react-native` >= 0.59.9

## Quick Start

```tsx
import {
  AppUpdateProvider,
  MaintenanceProvider,
  type AppInfo,
  type MaintenanceInfo,
} from "appcockpit-react-native-sdk";

const appInfo: AppInfo = {
  platform: "ios",
  appId: "com.example.myapp",
  appstoreId: "123456789",
  appVersion: "2.5.0",
  environment: "production",
  userId: "user_12345", // optional
};

const maintenanceInfo: MaintenanceInfo = {
  appId: "com.example.myapp",
  environment: "production",
};

function App() {
  return (
    <AppUpdateProvider info={appInfo} apiToken="your-api-token">
      <MaintenanceProvider info={maintenanceInfo} apiToken="your-api-token">
        <YourApp />
      </MaintenanceProvider>
    </AppUpdateProvider>
  );
}
```

## Features

### App Version Updates

The `AppUpdateProvider` checks for new app versions on mount and displays an update prompt when one is available.

- **Force updates** show a non-dismissible modal requiring the user to update.
- **Optional updates** can be dismissed. Once dismissed, the same version won't be shown again (persisted via AsyncStorage).

#### Props

| Prop           | Type                                   | Required | Description                                          |
| -------------- | -------------------------------------- | -------- | ---------------------------------------------------- |
| `info`         | `AppInfo`                              | Yes      | App configuration                                    |
| `apiToken`     | `string`                               | Yes      | API authentication token                             |
| `UpdateScreen` | `FC<UpdateScreenProps>`                | No       | Custom update screen component                       |
| `languageKey`  | `LanguageKey`                          | No       | Language for localized strings (defaults to English) |
| `theme`        | `{ updateButton?: UpdateButtonTheme }` | No       | Theme customization                                  |

#### Custom Update Screen

Provide your own update UI by passing an `UpdateScreen` component:

```tsx
import { type UpdateScreenProps } from "appcockpit-react-native-sdk";

const MyUpdateScreen: FC<UpdateScreenProps> = ({
  versionInfo,
  appInfo,
  onClose,
  onUpdate,
  children,
}) => {
  // Your custom UI
};

<AppUpdateProvider
  info={appInfo}
  apiToken={token}
  UpdateScreen={MyUpdateScreen}
>
  <App />
</AppUpdateProvider>;
```

#### Theme

```tsx
<AppUpdateProvider
  info={appInfo}
  apiToken={token}
  theme={{
    updateButton: {
      backgroundColor: "#FF6600",
      textColor: "#FFFFFF",
    },
  }}
>
```

### Maintenance Mode

The `MaintenanceProvider` checks if the app is in maintenance mode. When active, it displays a full-screen overlay blocking access to the app and polls every 30 seconds until maintenance ends.

#### Props

| Prop                | Type                         | Required | Description                         |
| ------------------- | ---------------------------- | -------- | ----------------------------------- |
| `info`              | `MaintenanceInfo`            | Yes      | App ID and environment              |
| `apiToken`          | `string`                     | Yes      | API authentication token            |
| `MaintenanceScreen` | `FC<MaintenanceScreenProps>` | No       | Custom maintenance screen component |
| `theme`             | `MaintenanceTheme`           | No       | Theme customization                 |

#### Custom Maintenance Screen

```tsx
import { type MaintenanceScreenProps } from "appcockpit-react-native-sdk";

const MyMaintenanceScreen: FC<MaintenanceScreenProps> = ({
  maintenanceInfo,
  children,
}) => {
  // Your custom UI
};

<MaintenanceProvider
  info={maintenanceInfo}
  apiToken={token}
  MaintenanceScreen={MyMaintenanceScreen}
>
  <App />
</MaintenanceProvider>;
```

#### Theme

```tsx
<MaintenanceProvider
  info={maintenanceInfo}
  apiToken={token}
  theme={{
    backgroundColor: "#1a1a2e",
    titleColor: "#ffffff",
    messageColor: "#cccccc",
    linkColor: "#4ea8de",
  }}
>
```

The maintenance response may include links (e.g., status page, social media) that are rendered as tappable cards.

### Standalone Version Check

For cases where you don't want to use the `AppUpdateProvider` component (e.g., non-React contexts or custom flows), you can use the `checkVersionUpdate` function directly. It checks for updates and shows a native `Alert` dialog instead of the full-screen modal.

```tsx
import { checkVersionUpdate, LanguageKey } from "appcockpit-react-native-sdk";

await checkVersionUpdate(appInfo, "your-api-token", LanguageKey.EN);
```

- Force updates show a non-dismissible alert that reopens after pressing "Update Now".
- Optional updates can be dismissed. Dismissed versions are persisted via AsyncStorage.

### User Authentication Tracking

When `userId` is provided in `AppInfo`, the SDK automatically calls the `/v2/authenticate` endpoint on mount. This logs the authentication event and tracks the latest app version per user and platform.

```tsx
const appInfo: AppInfo = {
  platform: "ios",
  appId: "com.example.myapp",
  appstoreId: "123456789",
  appVersion: "2.5.0",
  environment: "production",
  userId: currentUser?.id ?? null, // pass null or omit if user is not logged in
};
```

This is a fire-and-forget operation — it does not affect the UI or block rendering.

## Types

### AppInfo

```typescript
type AppInfo = {
  platform: "ios" | "android";
  appId: string; // Your app identifier (e.g., bundle ID)
  appstoreId: string; // App Store ID (iOS) or package name (Android)
  appVersion: string; // Current app version (e.g., "2.5.0")
  environment: string; // Deployment environment (e.g., "production")
  userId?: string | null; // Optional user ID for authentication tracking
};
```

### MaintenanceInfo

```typescript
type MaintenanceInfo = {
  appId: string;
  environment: string;
};
```

### VersionResponse

```typescript
type VersionResponse = {
  version: string;
  platform: "ios" | "android";
  force_update: boolean;
  default_update_message: string | null;
  update_messages?: Record<string, string>;
};
```

### MaintenanceResponse

```typescript
type MaintenanceResponse = {
  active: boolean;
  title: string | null;
  description: string | null;
  links?: Array<{ title: string; url: string }>;
};
```

### AuthenticateResponse

```typescript
type AuthenticateResponse = {
  success: boolean;
  user_id: string;
  platform: string;
  app_version: string;
};
```

## Localization

The SDK supports 20 languages for built-in update prompts. Pass a `LanguageKey` to `AppUpdateProvider`:

```tsx
import { LanguageKey } from "appcockpit-react-native-sdk";

<AppUpdateProvider info={appInfo} apiToken={token} languageKey={LanguageKey.DE}>
```

| Key  | Language   |
| ---- | ---------- |
| `EN` | English    |
| `ES` | Spanish    |
| `FR` | French     |
| `DE` | German     |
| `IT` | Italian    |
| `PT` | Portuguese |
| `RU` | Russian    |
| `JA` | Japanese   |
| `KO` | Korean     |
| `ZH` | Chinese    |
| `AR` | Arabic     |
| `HI` | Hindi      |
| `NL` | Dutch      |
| `SV` | Swedish    |
| `DA` | Danish     |
| `NO` | Norwegian  |
| `FI` | Finnish    |
| `PL` | Polish     |
| `TR` | Turkish    |
| `HE` | Hebrew     |

The API can also return custom `update_messages` per language, which take priority over the built-in defaults.

## API Endpoints

All endpoints use the base URL `https://api.appcockpit.dev` and require the following headers:

| Header             | Description                      |
| ------------------ | -------------------------------- |
| `x-api-token`      | API authentication token         |
| `x-client-version` | SDK version (sent automatically) |
| `Content-Type`     | `application/json`               |

| Endpoint           | Method | Description                   |
| ------------------ | ------ | ----------------------------- |
| `/v2/versions`     | GET    | Check for app version updates |
| `/v2/maintenance`  | GET    | Check maintenance mode status |
| `/v2/authenticate` | POST   | Log user authentication event |
