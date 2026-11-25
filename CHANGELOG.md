## 1.1.0

- Scheduled maintenance: `MaintenanceWrapper` shows a dismissible banner before a scheduled window (`showBanner`, `bannerTheme`, `customMaintenanceBanner`), switches to the maintenance screen at the start and back at the end
- Maintenance is re-checked when the app returns to the foreground
- `MaintenanceResponse` has `upcoming`, `startsAt` and `endsAt`
- Optional `httpClient` on `MaintenanceWrapper`
- Sends an anonymous install ID (`x-install-id`, a random UUID kept in SharedPreferences) so Appcockpit can count monthly active devices
- Test suite

## 1.0.0

- Initial release
- App version update checking with full-screen modal (`AppUpdateWrapper`)
- Standalone version check with native alert dialog (`checkVersionUpdate`)
- Maintenance mode with polling (`MaintenanceWrapper`)
- User authentication tracking
- Localization support (20 languages)
- Customizable themes and screens
