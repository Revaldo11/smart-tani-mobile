# T1 — Header & Greeting

## Design (top of screen)
- Row: logo (leaf, `assets/icons/Smart Tani.png`) + "Smart Tani" (bold, primary green) + tagline
  "Bersama Petani, Menuju Panen Lebih Baik" (small).
- Right: notification bell in white circle (~48) with red count badge ("3"); user avatar circle (~52).
- Greeting: "Selamat pagi," (bodyLarge) / "Pak Budi 👋" (headingLarge) / subtitle
  "Semoga hari ini sawahnya semakin subur." (bodyMedium).

## Data mapping
| UI | Source |
|----|--------|
| Greeting word | **client**: pagi (<11), siang (11–15), sore (15–18), malam (else) — device time |
| "Pak Budi" | logged-in user name. Prefix "Pak/Bu" **not in API** → decide (gender field? or show plain name). Don't hardcode "Pak" |
| Avatar | user `avatar_url` (nullable) → `cached_network_image`, fallback initials/icon |
| Badge | unread notification count `TBD` (hide badge when 0; show "9+" above 9) |
| Subtitle/tagline | static copy |

Reuse: `AuthSessionProvider` already holds the user (verify fields). Unread count from the
future `notification` repository → `NotificationBadgeProvider` (or `HomeHeaderProvider`).

## Files
```
presentation/widgets/home_header.dart        # logo row + bell + avatar (stateless)
presentation/widgets/home_greeting.dart      # greeting texts (stateless)
presentation/providers/home_header_provider.dart  # unreadCount, load()
core/utils/greeting.dart? -> keep local: features/home/presentation/greeting_period.dart
```

## Tasks
- [ ] Confirm user model fields (name, avatar, gender?) in `auth` feature.
- [ ] `greetingFor(DateTime)` pure function + 1 unit test (boundary hours).
- [ ] `HomeHeader` + `HomeGreeting` widgets, props only.
- [ ] Bell tap → notification route (`RouteNames` add if missing; else `showGlobalSnackbar` info "Segera hadir").
- [ ] Avatar tap → switch to Profile tab / push profile.
- [ ] Badge provider + repository call (blocked until endpoint known; ship with badge hidden).
- [ ] Emoji 👋: render as text; verify font fallback on Android.

## States
Loading: no badge, avatar placeholder. Error: silently hide badge (non-critical). Name missing: "Petani".

## Acceptance
Long names ellipsize (max 1–2 lines) without pushing the bell; text legible over sky bg.
