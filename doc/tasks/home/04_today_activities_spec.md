# T4 — Aktivitas Hari Ini

## Design
Card: header icon + "Aktivitas Hari Ini" (left), "Lihat Semua ›" (green, right).
List of rows separated by hairline dividers; each row:
- leading rounded-square icon tile (blue 💧 irrigation, green sprout fertilizing),
- title (bold) + description (secondary),
- time ("07:00") and a status chip: **Selesai** (green, check icon) / **Belum dilakukan** (orange, clock icon).

## Data mapping
| UI | Field (confirm) |
|----|-----------------|
| Title / description | activity `title` / `description` |
| Icon + tile color | activity `type` enum → map (irrigation, fertilizing, spraying, …), fallback generic |
| Time | `scheduled_at` → `HH:mm` (device tz; confirm server tz) |
| Status | `status` (done/pending…) → chip. "Overdue" state not in design → decide |

Endpoint: today's activities of active season `TBD`. Limit shown to 2–3 rows; "Lihat Semua" → Aktivitas tab.

## Files
```
features/activity/data/{model,datasources,repositories}/...   # shared with the Aktivitas feature
presentation/widgets/today_activities_card.dart
presentation/widgets/activity_tile.dart
presentation/widgets/activity_status_chip.dart   # promote to core/widget only if activity feature reuses it
presentation/providers/home_activities_provider.dart
```

## Tasks
- [ ] Confirm endpoint + type/status enums.
- [ ] Model/repo in `activity` feature (hand-written `fromJson`).
- [ ] Provider: today list sorted by time, top N.
- [ ] Widgets + status chip (colors from tokens; add `warning` tint if missing).
- [ ] Tap row → activity detail (if route absent → info snackbar). "Lihat Semua" → `go` to Aktivitas tab (needs a way to switch `MainNavigationPage` index; check how the shell exposes it).
- [ ] Optional: toggle done from row — **not in design, don't build**.
- [ ] Empty: "Tidak ada aktivitas hari ini" + illustration/icon. Error: retry.

## Acceptance
Row doesn't overflow when title is long (ellipsis, time + chip stay fixed); both chip variants match design.
