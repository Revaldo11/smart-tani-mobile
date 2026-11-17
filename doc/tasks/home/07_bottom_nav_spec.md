# T7 — Bottom Navigation (verify only)

`lib/app/pages/main_navigation_page.dart` already implements nav + center FAB
(commit a180bb9). **No new build**; compare against design and fix diffs.

## Design checklist
- Tabs: Beranda · Lahan Saya · [FAB +] · Aktivitas · Profil. Active = green icon+label, inactive = gray.
- Center FAB: green circle (~64), white "+", raised above bar, white ring/notch.
- Bar: white, rounded top corners, soft shadow.

## Tasks
- [ ] Screenshot current nav vs design; list diffs (icon set, label font size, FAB size/ring).
- [ ] FAB action: design shows none → currently? Define with product (Q7: quick-add sheet: catat aktivitas / panen / scan). Until decided: info snackbar.
- [ ] Expose a way for Home to switch tab (T4 "Lihat Semua", T1 avatar → Profil), e.g. callback/`goBranch`; keep `setState`-only tab index per project rules.
- [ ] Ensure Home content has bottom padding above the bar (see T0).

## Acceptance
Visual match within tolerance; tapping tabs preserves Home scroll position (IndexedStack).
