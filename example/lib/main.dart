import 'package:appcockpit/appcockpit.dart';
import 'package:flutter/material.dart';

// TODO: Replace with your API token from https://appcockpit.dev
const apiToken = 'YOUR_API_TOKEN';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with your app configuration
    const appInfo = AppInfo(
      platform: 'ios', // or 'android'
      appId: 'YOUR_APP_ID',
      appstoreId: 'YOUR_APPSTORE_ID',
      appVersion: '1.0.0',
      environment: 'production',
      userId: 'YOUR_USER_ID', // optional
    );

    const maintenanceInfo = MaintenanceInfo(
      appId: 'YOUR_APP_ID',
      environment: 'production',
    );

    return MaterialApp(
      home: MaintenanceWrapper(
        info: maintenanceInfo,
        apiToken: apiToken,
        child: AppUpdateWrapper(
          info: appInfo,
          apiToken: apiToken,
          languageKey: 'en',
          child: const HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hello, World!'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Replace with your app configuration
                const appInfo = AppInfo(
                  platform: 'ios',
                  appId: 'YOUR_APP_ID',
                  appstoreId: 'YOUR_APPSTORE_ID',
                  appVersion: '1.0.0',
                  environment: 'production',
                );
                checkVersionUpdate(
                  context,
                  appInfo,
                  apiToken,
                  languageKey: 'en',
                );
              },
              child: const Text('Check for Updates'),
            ),
          ],
        ),
      ),
    );
  }
}
