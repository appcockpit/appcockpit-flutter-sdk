import 'package:appcockpit/appcockpit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 12, 1, 12);
  DateTime at(int minutes) => now.add(Duration(minutes: minutes));

  group('MaintenanceResponse.fromJson', () {
    test('parses the schedule', () {
      final r = MaintenanceResponse.fromJson({
        'active': false,
        'upcoming': true,
        'title': 'DB upgrade',
        'description': null,
        'starts_at': '2026-12-05T02:00:00Z',
        'ends_at': '2026-12-05T04:00:00Z',
        'links': [
          {'title': 'Status', 'url': 'https://status.example.com'}
        ],
      });
      expect(r.upcoming, isTrue);
      expect(r.startsAt, DateTime.utc(2026, 12, 5, 2));
      expect(r.endsAt, DateTime.utc(2026, 12, 5, 4));
      expect(r.links!.single.title, 'Status');
    });

    test('accepts responses from older API versions', () {
      final r = MaintenanceResponse.fromJson(
          {'active': true, 'title': null, 'description': null});
      expect(r.active, isTrue);
      expect(r.upcoming, isFalse);
      expect(r.startsAt, isNull);
    });
  });

  group('maintenanceStateFrom', () {
    test('none without a response or when off', () {
      expect(maintenanceStateFrom(null, now), MaintenanceStateKind.none);
      expect(maintenanceStateFrom(const MaintenanceResponse(active: false), now),
          MaintenanceStateKind.none);
    });

    test('active, until ends_at passes', () {
      expect(maintenanceStateFrom(const MaintenanceResponse(active: true), now),
          MaintenanceStateKind.active);
      expect(
          maintenanceStateFrom(
              MaintenanceResponse(active: true, endsAt: at(-1)), now),
          MaintenanceStateKind.none);
    });

    test('upcoming only with a future start', () {
      expect(
          maintenanceStateFrom(
              MaintenanceResponse(active: false, upcoming: true, startsAt: at(60)),
              now),
          MaintenanceStateKind.upcoming);
      expect(
          maintenanceStateFrom(
              MaintenanceResponse(active: false, upcoming: true, startsAt: at(-1)),
              now),
          MaintenanceStateKind.none);
      expect(
          maintenanceStateFrom(
              const MaintenanceResponse(active: false, upcoming: true), now),
          MaintenanceStateKind.none);
    });
  });

  group('nextCheckDelay', () {
    test('no polling when nothing is going on', () {
      expect(nextCheckDelay(null, now), isNull);
    });

    test('polls while active, and right after the end', () {
      expect(nextCheckDelay(const MaintenanceResponse(active: true), now),
          activePollInterval);
      expect(
          nextCheckDelay(
              MaintenanceResponse(active: true, endsAt: now.add(const Duration(seconds: 5))),
              now),
          const Duration(seconds: 6));
    });

    test('polls slowly while upcoming, and right after the start', () {
      expect(
          nextCheckDelay(
              MaintenanceResponse(active: false, upcoming: true, startsAt: at(600)),
              now),
          upcomingPollInterval);
      expect(
          nextCheckDelay(
              MaintenanceResponse(active: false, upcoming: true, startsAt: at(2)),
              now),
          const Duration(minutes: 2, seconds: 1));
    });
  });

  test('formatMaintenanceWindow', () {
    const l10n = DefaultMaterialLocalizations();
    final start = DateTime(2026, 12, 5, 2);
    expect(formatMaintenanceWindow(start, DateTime(2026, 12, 5, 4), l10n,
            alwaysUse24HourFormat: true),
        'Sat, Dec 5 · 02:00 – 04:00');
    expect(formatMaintenanceWindow(start, DateTime(2026, 12, 6, 4), l10n,
            alwaysUse24HourFormat: true),
        'Sat, Dec 5 · 02:00 – Sun, Dec 6 · 04:00');
    expect(formatMaintenanceWindow(start, null, l10n), 'Sat, Dec 5 · 2:00 AM');
  });
}
