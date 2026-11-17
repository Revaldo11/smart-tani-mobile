# Smart Tani — Flutter Engineering Rules

## Purpose

This document defines Flutter-specific implementation rules for
Smart Tani Mobile.

Read these documents first:

1. `AGENTS.md`
2. `.ai/rules/architecture.md`
3. this document

If this document conflicts with established project implementation,
report the conflict before introducing a structural change.

---

# 1. Flutter Principles

Smart Tani Flutter code should prioritize:

- readability
- predictable behavior
- feature isolation
- reusable UI where appropriate
- explicit state flow
- small focused components
- maintainability
- minimal unnecessary abstraction

Prefer simple Flutter code over clever abstractions.

Do not introduce patterns only because they are popular in other
Flutter projects.

---

# 2. Directory Convention

Flutter source code follows:

lib/
├── main.dart
├── app/
├── core/
└── features/

Feature-specific implementation MUST stay inside its owning feature
unless it is genuinely shared.

Example:

features/farm/
├── data/
└── presentation/

---

# 3. File Naming

Use `snake_case`.

Correct:

farm_page.dart
farm_card.dart
farm_provider.dart
farm_repository.dart
farm_remote_data_source.dart
create_farm_request.dart

Avoid:

FarmPage.dart
farmPage.dart
farm-page.dart

---

# 4. Class Naming

Use `PascalCase`.

Examples:

FarmPage
FarmCard
FarmRepository
FarmNotifier
FarmState
FarmModel

---

# 5. Variable and Method Naming

Use `camelCase`.

Examples:

activeFarm
selectedFarm
isLoading
hasActiveSeason

fetchFarms()
createFarm()
archiveFarm()

Names MUST communicate intent.

Avoid vague names such as:

data
result2
temp
obj
manager
helper

when a domain-specific name can be used.

---

# 6. Boolean Naming

Boolean values should read naturally.

Preferred:

isLoading
isSubmitting
isAuthenticated
hasActiveSeason
hasError
canSubmit
shouldRefresh

Avoid:

loading
check
statusBool
flag
isCheck

---

# 7. Page Responsibility

A Page should primarily:

- compose UI
- observe Riverpod state
- dispatch user actions
- handle navigation
- display dialogs/bottom sheets when triggered by UI events

A Page MUST NOT:

- call Dio directly
- parse JSON
- construct API URLs
- store tokens
- contain repository implementation
- contain large business rules

Example:

FarmPage
    ↓
farmProvider
    ↓
FarmRepository

Not:

FarmPage
    ↓
Dio.get()

---

# 8. Widget Extraction

Extract a widget when it:

- represents a meaningful UI component
- is reused
- has independent presentation logic
- makes a large Page easier to understand

Do NOT extract every Container, Row, Column, or Text into separate
classes.

Prefer meaningful components.

Example:

FarmCard
WeatherCard
ActivityCard
PlantScanResultCard

Avoid meaningless abstractions such as:

FarmRowOne
FarmTextWidget
CustomContainer2

---

# 9. Feature Widgets vs Core Widgets

Feature-specific widgets belong in:

features/<feature>/presentation/widgets/

Example:

features/farm/presentation/widgets/farm_card.dart

Shared generic widgets belong in:

core/widgets/

Example:

core/widgets/app_button.dart
core/widgets/app_text_field.dart
core/widgets/app_loading_indicator.dart

A widget should move to `core` only when multiple features genuinely
need it.

Do not prematurely generalize widgets.

---

# 10. Stateless vs Stateful

Prefer stateless widgets when local lifecycle/state is unnecessary.

With Riverpod:

- `ConsumerWidget` for stateless Riverpod UI
- `ConsumerStatefulWidget` only when Flutter lifecycle or local mutable
  UI state is genuinely needed

Examples requiring Stateful behavior may include:

- TextEditingController
- AnimationController
- PageController
- focus management
- local temporary UI state
- lifecycle-dependent operations

Do NOT use StatefulWidget only to perform API state management.

---

# 11. Local UI State

Local state may be used for ephemeral presentation behavior.

Examples:

bool isPasswordVisible
int selectedTab
bool isExpanded

This may use `setState` when appropriate.

Do NOT use local `setState` for:

- API loading state
- farm data
- activity list
- authentication state
- scan result
- persistent application state

Those belong to Riverpod.

---

# 12. Build Method

Keep `build()` focused on rendering.

Avoid:

- API requests
- complex data transformations
- expensive computations
- state mutations
- large business rules

inside `build()`.

The build method may be executed many times.

It MUST remain safe to rebuild.

---

# 13. Side Effects

Do not trigger side effects directly because `build()` executed.

Side effects include:

- navigation
- dialog
- snackbar
- API mutation
- analytics event
- storage write

Use appropriate lifecycle mechanisms or Riverpod listeners.

Example:

ref.listen(...)

for state-driven UI side effects when appropriate.

---

# 14. BuildContext

`BuildContext` belongs to the presentation layer.

Do NOT pass BuildContext into:

- repositories
- remote data sources
- models
- domain services
- use cases

Avoid:

repository.createFarm(context, request)

Prefer:

repository.createFarm(request)

UI decides how success/error should be presented.

---

# 15. Async UI State

Every network-driven screen should account for:

- loading
- success
- empty
- error

Do not assume a successful API response always contains data.

Example conceptual rendering:

state.when(
  loading: ...,
  error: ...,
  data: ...
)

Follow the actual Riverpod state pattern established by the project.

---

# 16. Error Messages

Do not expose technical infrastructure errors directly.

Avoid showing:

DioException [connection timeout]
SocketException
HTTP 500 stack traces

Instead display actionable user-facing messages.

Technical details may be logged separately when appropriate.

---

# 17. Forms

Forms should separate:

- input control
- validation
- submission state
- API submission

Use Flutter form validation for client-side input constraints where
appropriate.

Backend remains authoritative for business validation.

Do not duplicate complex backend business rules unnecessarily in
Flutter.

---

# 18. Controllers

Dispose controllers owned by Stateful widgets.

Examples:

TextEditingController
AnimationController
ScrollController
PageController
FocusNode

Do not create controllers repeatedly inside `build()`.

---

# 19. Lists

For dynamic or potentially large lists prefer:

ListView.builder

or equivalent lazy builders.

Avoid creating unnecessarily large child lists eagerly.

Always provide meaningful empty state handling.

---

# 20. Images

Remote images should use the project's established cached image
solution.

Current Smart Tani recommendation:

cached_network_image

Image loading should consider:

- loading placeholder
- failure state
- fallback image where appropriate

Plant image upload should use the established camera/gallery flow.

---

# 21. Navigation

Use GoRouter.

Do not mix navigation frameworks without architectural approval.

Avoid scattered route strings when centralized routes already exist.

Navigation should remain a presentation responsibility.

---

# 22. Theme

Do not repeatedly hardcode visual design values when an established
theme/design token exists.

Prefer:

Theme.of(context)

or the project's established theme abstraction.

Common typography, spacing, radius, and semantic colors should follow
the Smart Tani design system when available.

Do not create a new design system inside an individual feature.

---

# 23. Constants

Use constants for values that are:

- stable
- reused
- meaningful

Do not create a constants file as a dumping ground.

Feature-specific constants should remain close to their feature when
they are not globally shared.

---

# 24. Extensions

Extensions are appropriate when they provide focused reusable behavior.

Avoid creating large generic extension collections.

An extension should have clear ownership and purpose.

---

# 25. Null Safety

Respect Dart null safety.

Do not use `!` simply to silence nullable errors.

Use force unwrap only when the invariant is genuinely guaranteed and
obvious.

Prefer explicit null handling.

---

# 26. Immutability

Prefer immutable state and model objects.

Use `final` where mutation is unnecessary.

State changes should produce a new state rather than mutate shared
state unpredictably.

---

# 27. Models

Models should represent data, not UI.

Avoid:

class FarmModel {
  Color statusColor;
  IconData icon;
}

Presentation should derive those values.

Models should follow the established Freezed/json_serializable
convention when applicable.

---

# 28. Generated Code

Never manually edit generated files such as:

*.g.dart
*.freezed.dart

Modify the source declaration and regenerate instead.

---

# 29. Logging

Do not use uncontrolled `print()` statements in production code.

Use the project's established logging mechanism.

Never log:

- passwords
- access tokens
- authorization headers
- private API keys
- sensitive user information

---

# 30. Environment

Feature code MUST NOT contain environment-specific base URLs.

Avoid:

const url = 'https://dev-api...';

Use centralized environment configuration.

Supported environments:

dev
stg
prod

---

# 31. API Endpoints

Do not scatter endpoint definitions throughout widgets/providers.

Prefer centralized or feature-owned endpoint definitions according to
the established project pattern.

Pages should never know raw endpoint paths.

---

# 32. API Models vs Form Input

When create/update payload differs significantly from response models,
use focused request models when helpful.

Example:

FarmModel
CreateFarmRequest
UpdateFarmRequest

Do not force one model to represent every API operation when that
reduces clarity.

Conversely, do not create separate DTO classes when they provide no
actual benefit.

---

# 33. Formatting

All Dart code must follow Dart formatting.

Before completion run:

dart format .

Do not manually align code against Dart formatter conventions.

---

# 34. Static Analysis

Run:

flutter analyze

before considering implementation complete when the environment allows
it.

Do not ignore newly introduced analyzer warnings without justification.

---

# 35. Testing

Prioritize tests for:

- business rules
- repository behavior where valuable
- provider/notifier state transitions
- critical user flows
- bug regressions

Do not create low-value tests solely to increase test count.

---

# 36. Performance

Do not optimize without evidence, but avoid obvious problems.

Watch for:

- expensive computation inside build
- unnecessary rebuilds
- oversized provider scope
- eagerly rendered large lists
- repeatedly creating expensive objects
- unnecessarily decoding large data repeatedly

Measure before introducing complex optimization.

---

# 37. Comments

Prefer code that explains itself.

Comments should explain:

WHY

rather than restating:

WHAT

Avoid:

// Set loading true
isLoading = true;

Useful comments describe non-obvious decisions, constraints, or
workarounds.

---

# 38. TODO

TODOs must be actionable.

Preferred:

// TODO: Replace polling with SSE after backend endpoint is available.

Avoid:

// TODO fix
// TODO later

---

# 39. Smart Tani UX Principle

Smart Tani targets users who may not have high technical literacy.

UI wording should therefore remain:

- clear
- practical
- concise
- understandable in Indonesian

Do not expose unnecessary technical terminology to users.

Technical agronomy information should follow the approved product
wording.

---

# 40. Final Flutter Rule

Before adding code, ask:

"Does this belong in UI, state, data, or shared infrastructure?"

Place the responsibility in the smallest correct scope.

Do not move responsibilities upward or globally simply for
convenience.