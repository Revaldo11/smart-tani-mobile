# T5 — Quick Actions (4 shortcut tiles)

## Design
Row of 4 equal white tiles (radius ~16), each: colored icon, bold label, small gray subtitle.

| Tile | Subtitle | Icon (color) | Target |
|------|----------|--------------|--------|
| Cek Tanaman | Foto & analisis | camera (green) | `plant_scan` |
| Asisten Tani | Tanya apa saja | chat bubble (blue) | `assistant` |
| Catat Panen | Lihat hasil panen | bar chart (green) | `harvest` |
| Edukasi | Tips & artikel | book (blue) | `education`? (open Q5) |

Static content — no API, no provider.

## Files
```
presentation/widgets/quick_actions.dart       # Row of 4 QuickActionTile
presentation/widgets/quick_action_tile.dart   # icon, title, subtitle, onTap
```
Config list lives as a `const` list inside `quick_actions.dart`.

## Tasks
- [ ] Tile + row widgets (`Expanded` ×4, `AspectRatio`/min-height so text never clips).
- [ ] Icons: eva_icons / Material first; add SVG to `assets/icons/` only if no match.
- [ ] Wire `onTap` to routes as features land; until then `showGlobalSnackbar(... SnackBarMode.info ...)` "Fitur segera hadir" (project pattern) and list as open item.
- [ ] Verify "Catat Panen" label vs subtitle "Lihat hasil panen" — design copy mismatch? Ship exact copy, flag to design.

## Acceptance
At 360 px width the 4 tiles fit without horizontal scroll; labels ("Asisten Tani", "Cek Tanaman") may wrap to 2 lines max; text-scale 1.3 ok.
