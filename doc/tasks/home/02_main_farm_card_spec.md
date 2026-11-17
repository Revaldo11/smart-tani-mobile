# T2 — Sawah Utama Card

## Design
White card, two columns.
- Left: chip-icon + "Sawah Utama ›" (title, tappable) → divider → leaf + "Padi Ciherang"
  → two stats side by side ("Umur tanaman / 42 hari", "Luas lahan / 1,2 ha") separated by a vertical
  divider → status pill "● Kondisi Baik" (light green bg, dark-green text).
- Right: rounded photo (~45% width) with edit icon button (white circle, top-right) and
  bottom-right dark pill "Lihat Detail ›".

## Data mapping
| UI | Field (confirm) |
|----|-----------------|
| Title "Sawah Utama" | farm `name` (design text is the farm's name, not a literal label) |
| Crop "Padi Ciherang" | active planting season → crop + variety |
| Umur tanaman | days since season `planting_date` (client calc) → "{n} hari" |
| Luas lahan | farm `area` + unit (ha). Format with `,` decimal (id-ID) |
| Status | `TBD` (see open Q4). Map enum → label + color (success/warning/error tokens) |
| Photo | farm `photo_url` nullable → placeholder asset |

Depends on `farm` + `planting_season` repositories (not yet built). Create the minimal
`FarmModel`/`SeasonModel` in their own features; home consumes via `HomeFarmProvider`.

## Files
```
presentation/widgets/main_farm_card.dart     # stateless, takes MainFarmCardData
presentation/widgets/farm_status_chip.dart
presentation/providers/home_farm_provider.dart   # isLoading, error, farm, season
```
`MainFarmCardData` = small plain class (view model) only if props exceed ~6; else pass fields.

## Tasks
- [ ] Confirm endpoint (`GET /farms` exists; primary-farm + active-season rule?).
- [ ] Models (hand-written `fromJson`, preserve nullability).
- [ ] Repository + datasource methods; provider with 4 states.
- [ ] Card widget + status chip; `cached_network_image` w/ placeholder+error.
- [ ] Taps: title/"Lihat Detail" → farm detail route; edit icon → edit farm (or info snackbar if route absent).
- [ ] **Empty state**: no farm yet → CTA card "Tambah lahan pertama" → farm create.
- [ ] No active season: hide crop/age, show "Belum ada musim tanam".

## Acceptance
Long farm/crop names ellipsize; stats don't overflow at 1.3× font scale; photo keeps radius 16–20, cover fit.
