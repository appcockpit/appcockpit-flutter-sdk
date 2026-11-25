import 'dart:convert';

import 'package:appcockpit/appcockpit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

const info = MaintenanceInfo(appId: 'app1', environment: 'production');

Widget app(http.Client client) => MaterialApp(
      home: MaintenanceWrapper(
        info: info,
        apiToken: 'tok',
        httpClient: client,
        child: const Scaffold(body: Center(child: Text('My app'))),
      ),
    );

MockClient respond(Map<String, dynamic> body, {List<Uri>? calls}) =>
    MockClient((req) async {
      calls?.add(req.url);
      return http.Response(jsonEncode(body), 200);
    });

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows the app when there is no maintenance', (tester) async {
    final calls = <Uri>[];
    await tester.pumpWidget(app(respond({'active': false}, calls: calls)));
    await tester.pumpAndSettle();
    expect(find.text('My app'), findsOneWidget);
    expect(find.byType(MaintenanceBanner), findsNothing);
    expect(calls.single.path, '/v2/maintenance');
    expect(calls.single.queryParameters,
        {'app_id': 'app1', 'environment': 'production'});
  });

  testWidgets('shows the maintenance screen while active', (tester) async {
    await tester.pumpWidget(app(respond(
        {'active': true, 'title': 'Down for upgrades', 'description': null})));
    await tester.pump();
    await tester.pump();
    expect(find.text('Down for upgrades'), findsOneWidget);
    await tester.pumpWidget(const SizedBox()); // dispose timers
  });

  testWidgets('announces upcoming maintenance and remembers dismissal',
      (tester) async {
    final starts = DateTime.now().toUtc().add(const Duration(hours: 3));
    final body = {
      'active': false,
      'upcoming': true,
      'title': 'DB upgrade',
      'description': 'About 2 hours',
      'starts_at': starts.toIso8601String(),
      'ends_at': starts.add(const Duration(hours: 2)).toIso8601String(),
    };
    await tester.pumpWidget(app(respond(body)));
    await tester.pump();
    await tester.pump();
    expect(find.text('DB upgrade'), findsOneWidget);
    expect(find.textContaining('About 2 hours'), findsOneWidget);
    expect(find.text('My app'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(find.byType(MaintenanceBanner), findsNothing);

    // Still dismissed after a restart.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(app(respond(body)));
    await tester.pump();
    await tester.pump();
    expect(find.byType(MaintenanceBanner), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('showBanner: false hides the banner', (tester) async {
    final starts = DateTime.now().toUtc().add(const Duration(hours: 3));
    await tester.pumpWidget(MaterialApp(
      home: MaintenanceWrapper(
        info: info,
        apiToken: 'tok',
        showBanner: false,
        httpClient: respond({
          'active': false,
          'upcoming': true,
          'starts_at': starts.toIso8601String(),
        }),
        child: const Text('My app'),
      ),
    ));
    await tester.pump();
    await tester.pump();
    expect(find.byType(MaintenanceBanner), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
