# T0 — Page Shell, Background, Refresh

## Goal
Replace placeholder `HomePage` with the real scaffold that hosts all sections.

## Design
- Full-width hero image (sky + rice field) behind the header/greeting, fading to
  `AppColors.background` (white-green) below ~y=300 via gradient.
- Content = scrollable column of cards, horizontal padding `AppSpacing.md`, vertical gap `md`.
- Bottom padding must clear the bottom nav + FAB (nav is in `MainNavigationPage`; add
  extra `SafeArea`/padding so the last card (Tips) isn't hidden).
- Cards: white surface, radius 20, soft shadow (new shared token `AppDecorations`? —
  only if reused; otherwise a local const).

## Files
```
features/home/presentation/pages/home_page.dart     # provider wiring + RefreshIndicator
features/home/presentation/widgets/home_view.dart   # stateless composition
features/home/presentation/widgets/home_card.dart   # shared white card container (radius/shadow/padding)
assets/images/home/home_bg.jpg                       # hero bg (register in pubspec)
```

## Tasks
- [ ] Add hero background asset + pubspec entry (check `assets/images` first; splash images are not suitable).
- [ ] `HomeCard` container reused by sections T2–T4, T6.
- [ ] `HomePage`: `MultiProvider` of section providers (added as T1–T6 land); `RefreshIndicator` calls each provider's `load()`.
- [ ] `HomeView`: `Stack` (bg + gradient) + `CustomScrollView`/`ListView` of sections.
- [ ] Keep `IndexedStack` shell behavior: page must not reload data every tab switch (load once in `initState`/first build, refresh by pull).

## Acceptance
- Scrolls smoothly at 360×640 and tall phones; no overflow; status bar icons legible over the bg.
- Pull-to-refresh triggers all sections.
- No business logic in `HomeView`.
