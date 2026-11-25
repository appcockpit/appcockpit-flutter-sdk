import 'package:flutter/material.dart';

import 'models.dart';

/// How often to re-check while the maintenance screen is shown.
const activePollInterval = Duration(seconds: 30);

/// How often to re-check while a window is announced (it may be moved or
/// cancelled).
const upcomingPollInterval = Duration(minutes: 5);

enum MaintenanceStateKind { none, active, upcoming }

/// What the app should show for a /maintenance response at [now].
MaintenanceStateKind maintenanceStateFrom(
  MaintenanceResponse? response,
  DateTime now,
) {
  if (response == null) return MaintenanceStateKind.none;
  final endsAt = response.endsAt;
  if (response.active) {
    // Don't keep blocking past the end if the next check hasn't come back yet.
    if (endsAt != null && !now.isBefore(endsAt)) {
      return MaintenanceStateKind.none;
    }
    return MaintenanceStateKind.active;
  }
  final startsAt = response.startsAt;
  if (response.upcoming && startsAt != null && startsAt.isAfter(now)) {
    return MaintenanceStateKind.upcoming;
  }
  return MaintenanceStateKind.none;
}

/// When to check again, or null to wait for the app to come back to the
/// foreground. Checks right after a window starts or ends so the screen
/// switches on time.
Duration? nextCheckDelay(MaintenanceResponse? response, DateTime now) {
  Duration until(DateTime? d, Duration max) {
    if (d == null) return max;
    final left = d.difference(now) + const Duration(seconds: 1);
    if (left < const Duration(seconds: 1)) return const Duration(seconds: 1);
    return left < max ? left : max;
  }

  switch (maintenanceStateFrom(response, now)) {
    case MaintenanceStateKind.active:
      return until(response!.endsAt, activePollInterval);
    case MaintenanceStateKind.upcoming:
      return until(response!.startsAt, upcomingPollInterval);
    case MaintenanceStateKind.none:
      return null;
  }
}

/// "Sat, Dec 5 · 02:00 – 04:00" in the user's locale and time zone.
String formatMaintenanceWindow(
  DateTime startsAt,
  DateTime? endsAt,
  MaterialLocalizations l10n, {
  bool alwaysUse24HourFormat = false,
}) {
  String date(DateTime d) => l10n.formatMediumDate(d);
  String time(DateTime d) => l10n.formatTimeOfDay(
        TimeOfDay.fromDateTime(d),
        alwaysUse24HourFormat: alwaysUse24HourFormat,
      );
  final start = startsAt.toLocal();
  final text = '${date(start)} · ${time(start)}';
  if (endsAt == null) return text;
  final end = endsAt.toLocal();
  final sameDay = start.year == end.year &&
      start.month == end.month &&
      start.day == end.day;
  return sameDay
      ? '$text – ${time(end)}'
      : '$text – ${date(end)} · ${time(end)}';
}
