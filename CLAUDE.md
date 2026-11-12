# CLAUDE.md — Smart Tani Mobile

Flutter app for farmers (Laravel Sanctum REST backend, `/api/v1`).
UI copy and error messages are **Bahasa Indonesia**. Code, identifiers, comments are English.

@AGENTS.md

`AGENTS.md` holds the general engineering rules. This file records what the
code **actually does today** and the workflows to follow. When they disagree,
**the existing source code wins** (AGENTS.md §2) — and report the conflict.

## Known doc conflicts (read before trusting other docs)

- State management is **`provider` + `ChangeNotifier`** (decided, final). Do NOT
  introduce Riverpod. `.ai/**`, `doc/architecture/**` and `doc/templates/**` still
  contain stale Riverpod wording (`ref.watch`, `ConsumerWidget`, `AsyncValue`, ...):
  translate it to Provider (`context.watch/read`, `ChangeNotifier`) and never copy it.
- AGENTS.md lists Freezed / json_serializable / firebase_messaging. They are
  **not in `pubspec.yaml`**. Models are hand-written (`fromJson` factory).
  Don't add packages or codegen unless asked; follow the hand-written pattern
  until the team decides to migrate.
- AGENTS.md proposes `lib/app/{app,bootstrap,router,environment}.dart`. Real
  layout is below. Don't restructure.

## Commands

```bash
flutter pub get
flutter run
dart format .          # formatter page_width is 60 (analysis_options.yaml)
flutter analyze        # flutter_lints; android/ ios/ build/ excluded
flutter test           # only test/widget_test.dart exists (likely stale)
```

Never claim validation passed unless you ran it and saw it pass.
Full-reformat (`dart format .`) touches many files — format only files you changed.

## Real project layout

```
lib/
├── main.dart                 # manual DI wiring + MultiProvider (composition root)
├── app.dart                  # SmartTaniApp (MaterialApp.router, AppTheme.light)
├── app/
│   ├── pages/main_navigation_page.dart   # bottom nav shell (IndexedStack)
│   └── routes/{app_router,route_names}.dart
├── core/
│   ├── constant/             # api_constant.dart (ApiConstants), const.dart
│   ├── error/                # AppException(+type enum), ErrorHandler.handle()
│   ├── network/              # DioClient, interceptors/auth.dart (Bearer)
│   ├── storage/              # SecureStorageService (token), PreferenceService
│   ├── theme/                # AppColors, AppSpacing, AppTypography, AppTheme
│   ├── validators/           # auth_validators.dart
│   └── widget/               # shared widgets (NOTE: singular `widget`)
└── features/<feature>/
    ├── data/{datasources,repositories,model}/   # NOTE: `model` singular
    └── presentation/{pages,providers,widgets}/
```

Features present: `auth` (complete), `splash`, and placeholder pages for
`home`, `farm`, `activity`, `profile`. Planned (AGENTS.md §5): `planting_season`,
`plant_scan`, `assistant`, `harvest`, `notification`.
Naming follows the existing files: `*_page.dart`, `*_view.dart`,
`*_provider.dart`, `*_repository.dart`, `*_remote_datasource.dart`.

## Architecture (as implemented — copy `features/auth`)

```
Page ──► Provider (ChangeNotifier) ──► Repository ──► RemoteDataSource ──► Dio ──► Laravel
```

- **RemoteDataSource**: takes `Dio` in ctor, calls an endpoint, unwraps
  `response.data['data']`, returns a Model. No error mapping, no token handling.
- **Repository**: wraps data source in `try/catch (e) { throw ErrorHandler.handle(e); }`.
  Only layer that touches `SecureStorageService`. Throws only `AppException`.
- **Provider**: `extends ChangeNotifier`. Holds `isLoading`, `errorMessage`,
  data. `catch on AppException` → store `error.message`. Exposes validators and
  form controllers for form providers (`LoginFormProvider` pattern).
- **Page**: thin. `context.watch<XProvider>()`, calls provider actions, shows
  `showGlobalSnackbar` for errors, navigates with GoRouter. Passes plain values
  and callbacks down to a stateless **`*_View`** widget (see `LoginPage`→`LoginView`).
- **View/widgets**: stateless, no Provider, no Dio, no business logic. Receive
  everything via constructor. This is what makes Figma→code safe to iterate.
- Simple CRUD features: **no** domain layer, no interfaces, no use cases, no
  entities/DTOs/mappers (AGENTS.md §7). Add `domain/` only for genuinely
  complex flows (e.g. `plant_scan`), and say why.

### Adding a feature — checklist

1. Check PRD / API contract / `doc/architecture/*` for the endpoint + fields. Don't invent fields.
2. Add endpoint paths in one place (currently strings inside the data source,
   base URL in `ApiConstants`). Keep `/api/v1` only in `ApiConstants.baseUrl`.
3. `data/model/x_model.dart` (hand-written `fromJson`, `snake_case` JSON → `camelCase` fields).
4. `data/datasources/x_remote_datasource.dart` → `data/repositories/x_repository.dart`.
5. `presentation/providers/x_provider.dart` with loading / empty / error / success.
6. Pages + `*_view.dart` + feature widgets.
7. **Register**: construct in `main.dart` (DataSource → Repository → Provider using `dioClient.dio`)
   and add to `MultiProvider`. Providers that are only needed by one screen may
   instead use a scoped `ChangeNotifierProvider` on the route — prefer that for
   new feature providers to avoid bloating `main.dart`.
8. **Route**: add a name in `RouteNames`, a `GoRoute` in `app_router.dart`
   (auth redirect logic lives there — don't duplicate it).
9. Run format + analyze (+ tests you add).

## Hard rules (project-specific)

- Never `Dio()` outside `DioClient`. Never attach `Authorization` manually —
  `AuthInterceptor` does it. Token lives only in `SecureStorageService`.
- Never show `DioException`/raw errors. Repository converts via `ErrorHandler`;
  UI shows `AppException.message` (already Indonesian). Add new error cases to
  `ErrorHandler`, not in providers.
- `ApiConstants.baseUrl` is currently hardcoded to `http://0.0.0.0:8000/api/v1`
  (no dev/stg/prod split yet). Don't add more hardcoded URLs; if env work is
  requested, centralize there (AGENTS.md §13).
- No `BuildContext` in repositories/data sources. Providers should not navigate
  or show UI — pages do (check `mounted` after `await`).
- `setState` only for ephemeral UI state (like the current tab index).
- Don't leave demo code: `LoginFormProvider.submit(addDemoDelay: true)` has a
  5-second `Future.delayed` — flag it, don't copy it into new providers.
- Don't edit generated files, `pubspec.lock` by hand, `android/`, `ios/` unless the task requires it.
- Don't commit unless asked. Don't push.

## Design system (use tokens, never raw values)

| Need | Use |
|---|---|
| Color | `AppColors` (`primary #2E7D32`, `primaryDark`, `primaryLight`, `background`, `surface`, `textPrimary/Secondary`, `border`, `success/warning/error`) |
| Spacing | `AppSpacing` (`xs4 sm8 md16 lg24 xl32 xxl48`) |
| Text | `AppTypography` (`headingLarge/Medium/Small`, `bodyLarge/Medium/Small`, `button`); font is **Poppins** via `google_fonts` in `AppTheme` |
| Inputs / buttons | `AppTextField`, `PrimaryButton` (height 52, full-width, built-in loading) — theme already styles `InputDecoration` (radius 12) |
| Feedback | `showGlobalSnackbar(context, title:, subtitle:, mode: SnackBarMode.*)`, `AppCustomDialog` |
| Icons | `eva_icons_flutter`, `Icons.*`, SVG via `flutter_svg` from `assets/icons/`, PNG in `assets/images/` |

Add a new token only if it is reused across screens; one-off values stay local
(`const` in the widget). If Figma introduces a recurring value (new color, radius,
shadow), add it to the matching `core/theme` file and mention it in the report.

## Figma / screenshot → Flutter workflow

Figma is the source of truth for **presentation only**; PRD/API win on behavior.
Detailed checklist: `.ai/commands/implement_figma.md` (read "Riverpod" as Provider).

### With a Figma link (Figma MCP is available)

1. `create_session` for the file (per the Figma MCP instructions), then
   `get_design_context` (structure, tokens, code hints), `get_screenshot`
   (visual reference), `get_variable_defs` (tokens), `get_metadata` for large frames.
   Treat generated React/Tailwind output as a **reference only** — translate, don't paste.
2. `download_assets` for icons/images missing in `assets/`; check `assets/` first.

### With a screenshot only

1. Read the image (Read tool). List: layout regions, components, text (exact copy),
   colors (estimate nearest `AppColors`), spacing rhythm (snap to `AppSpacing`),
   states shown.
2. State assumptions you had to make (fonts, radius, hidden states) — don't present guesses as spec.

### Implementation steps (both cases)

1. **Map** the screen to a feature (`farm`, `plant_scan`, …). Don't create a feature per screen.
2. **Reuse first**: grep `lib/core/widget` and sibling features for an equivalent
   widget before creating one. Shared across features → `core/widget/`; else `features/<f>/presentation/widgets/`.
3. **Structure**: `*_page.dart` (provider wiring) → `*_view.dart` (pure UI) → small widgets.
   Extract widgets into classes (not `_buildX()` methods) when reused or > ~60 lines.
4. **Layout**: `Column/Row/Expanded/Wrap/ListView`, `SafeArea`, scrollable body for
   forms (keyboard). No `Positioned` pixel-copying except true overlays/decoration.
   Must not overflow on small (360×640) and large phones; test long text and large font scale.
5. **Data**: every dynamic string/number in the design maps to a model field or
   provider state. Hardcoded Figma sample text must not ship.
6. **Actions**: every tappable element maps to a provider method or `context.push/go`.
   If behavior is undefined, wire a `showGlobalSnackbar(... SnackBarMode.info ...)`
   "coming soon" (existing pattern in `LoginPage`) and report it.
7. **States**: loading, empty, error, success, disabled, plus form focus/invalid.
   If the design omits them, reuse existing patterns and report the gap.
8. **Images**: `cached_network_image` for remote, with placeholder + error widget.
9. **Verify visually**: run the app (iOS simulator / browser pane / `flutter run`),
   screenshot, compare to the design (spacing, type, color, radius, icons).
   Do not claim pixel-perfect unless actually compared.
10. `dart format <files>`, `flutter analyze`, `flutter test`.

### Report (keep short)

Changed · Architecture decisions · Reused vs new components · Data mapping ·
Design differences/assumptions · Validation actually run · Open items.

## Code style quick reference

- `const` constructors and `const` widgets wherever possible; `super.key` last in params, `required` first (match existing).
- Imports: `package:smart_tani_mobile/...` for cross-folder; relative imports already
  appear inside features — prefer package imports in new code.
- Trailing commas; single quotes; formatter width 60 → wrap long expressions.
- Boolean names: `isLoading`, `hasToken`, `canSubmit`. Avoid `data`, `temp`, `helper`, `manager`.
- Dispose controllers/listeners in `dispose()`.
- Comments only for non-obvious *why*. No dead code, no leftover `print`.

## Before saying "done"

- [ ] Follows `features/auth` structure; no new layers/packages without reason
- [ ] No API call or `Dio` in widgets/pages; no raw errors in UI
- [ ] Tokens used; no stray hex colors / magic spacing
- [ ] Loading / empty / error / success handled
- [ ] Route + provider registered
- [ ] `dart format`, `flutter analyze`, `flutter test` run and results reported honestly
