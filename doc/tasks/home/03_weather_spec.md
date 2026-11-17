# T3 — Cuaca Hari Ini

## Design
Card:
- Header: calendar-style icon + "Cuaca Hari Ini" (left); pin + "Sukamaju, Jawa Barat" + `›` (right).
- Main row: weather icon (sun+cloud) · "29°C" large · condition "Cerah Berawan" · three metrics
  separated by dividers: 💧 74% Kelembapan · 🌧 20% Peluang Hujan · 💨 8 km/j Kecepatan Angin.
- Advice banner (light-green, rounded): rain icon, bold line "Hujan diperkirakan pukul 16:00.",
  second line "Sebaiknya lakukan pemupukan sebelum pukul 14:00." + `›`.

## Data mapping
| UI | Source |
|----|--------|
| Location | farm location (kelurahan/kabupaten, province) — from main farm; `TBD` field |
| Temp, condition, humidity, rain chance, wind | Laravel weather snapshot endpoint `TBD` (Flutter never calls weather provider directly — AGENTS §3) |
| Condition → icon | local map `condition code → asset/Icon` with a fallback icon |
| Advice banner | backend-generated text (open Q3). If absent → hide banner |

Format: `29°C`, `74%`, `8 km/j`; numbers locale id-ID.

## Files
```
data/model/weather_snapshot_model.dart   # in features/weather? -> keep under features/home/data unless reused elsewhere
presentation/widgets/weather_card.dart
presentation/widgets/weather_metric.dart       # icon + value + label
presentation/widgets/weather_advice_banner.dart
presentation/providers/home_weather_provider.dart
```
(AGENTS.md: weather stays supporting data unless it gets its own UI — keep inside `home`.)

## Tasks
- [ ] Confirm endpoint, fields, units (km/h → label "km/j").
- [ ] Model + datasource + repository + provider (states: loading/error+retry/empty "Cuaca belum tersedia").
- [ ] Icon mapping util + assets (reuse Material/eva icons where possible; only add assets if design art needed).
- [ ] Widgets; metrics row uses `Expanded` + `IntrinsicHeight` dividers.
- [ ] Location tap → farm location / weather detail (undefined → info snackbar). Banner tap → same.
- [ ] Depends on main farm id (T2): weather loads after farm resolved; handle "no farm" = hide card or prompt.

## Acceptance
Metrics don't wrap at 360 px width ("Kecepatan Angin" may use 2 lines/ellipsis); null metric shows "-" not 0 (api_convention §11).
