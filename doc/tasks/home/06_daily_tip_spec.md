# T6 — Tips Hari Ini

## Design
Full-width light-green gradient card (radius ~20): sprout icon + "Tips Hari Ini" (bold green),
quoted tip text (2 lines), decorative sprout illustration on the right (partially cropped), chevron `›`.

## Data mapping
| UI | Source |
|----|--------|
| Tip text | `TBD` — backend daily tip, or local const list rotated by day-of-year (open Q6) |
| Illustration | static asset `assets/images/home/tip_sprout.png` (transparent PNG) |
| Tap | → education/tip detail (undefined → info snackbar) |

Recommended minimal path: **local const list** now (no API, no provider); swap to API
only when the contract exists. Do not ship the Figma sample sentence as the only tip
without product approval.

## Files
```
presentation/widgets/daily_tip_card.dart     # stateless, takes String tip
```
If API is chosen: `home_tip_provider.dart` + repo method; fallback to local list on error.

## Tasks
- [ ] Decide source (Q6). Default: local list, `tipFor(DateTime)` pure fn + 1 unit test.
- [ ] Add illustration asset + pubspec entry.
- [ ] Widget: text `maxLines: 3` ellipsis, reserve right padding for the illustration so text never overlaps it.
- [ ] Tap handler (snackbar until Edukasi exists).

## Acceptance
Text never runs under the illustration; card height grows with font scale, no overflow.
