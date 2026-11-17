# Smart Tani — Create Feature Command

## Purpose

Use this command when creating a new Smart Tani Flutter feature or
implementing a substantial new flow inside an existing feature.

Examples:

- Authentication
- Farm
- Planting Season
- Activity
- Plant Scan
- Harvest
- Assistant
- Notification
- Profile

This command is an execution workflow.

Architecture and coding decisions MUST follow:

1. `AGENTS.md`
2. `.ai/rules/architecture.md`
3. `.ai/rules/flutter.md`
4. `.ai/rules/provider.md`
5. existing Smart Tani source code
6. relevant PRD / API / database documentation

Do not start implementation before completing the discovery steps.

---

# 1. Understand the Requirement

Read the complete task.

Identify:

- feature name
- user goal
- expected screens
- user actions
- API dependencies
- domain entities
- validation rules
- loading states
- empty states
- error states
- success behavior
- navigation behavior

Do not infer major product requirements when they are not documented.

If a required business rule is genuinely missing and materially affects
the implementation, report the missing requirement.

---

# 2. Read Relevant Product Documentation

Before coding, inspect relevant Smart Tani documentation.

Determine:

- what the PRD requires
- which database entities are involved
- whether an API contract exists
- whether the feature depends on another Smart Tani feature

Do NOT treat the database schema as the mobile API contract.

Database documentation explains persistence relationships.

API documentation defines what Flutter sends and receives.

---

# 3. Inspect Existing Project

Inspect the current source tree.

At minimum inspect:

lib/
├── app/
├── core/
└── features/

Then inspect the target feature if it already exists.

Do not assume the documented folder structure exactly matches the
current repository.

Existing implementation is the primary reference for implementation
style.

---

# 4. Find the Closest Existing Feature

Before creating files, identify an existing feature with similar
behavior.

Examples:

CRUD feature
→ inspect another CRUD feature

detail screen
→ inspect another detail screen

form submission
→ inspect another form flow

paginated list
→ inspect another paginated list

file upload
→ inspect existing upload implementation

Reuse established conventions for:

- Riverpod style
- repository construction
- data source construction
- API response handling
- error mapping
- navigation
- model serialization
- loading UI
- form validation
- tests

Do not introduce a second convention unnecessarily.

---

# 5. Check Existing Shared Infrastructure

Before creating utilities or abstractions, inspect:

core/network/
core/error/
core/storage/
core/widgets/
app/

Look for existing:

- Dio provider
- interceptors
- API response wrapper
- error mapper
- secure storage
- environment configuration
- reusable buttons
- reusable text fields
- loading components
- error components
- routing utilities

Reuse them where appropriate.

Do NOT duplicate shared infrastructure inside a feature.

---

# 6. Classify Feature Complexity

Classify the feature as:

STANDARD

or

COMPLEX

before deciding its folder structure.

---

## Standard Feature

Use for straightforward CRUD or simple workflows.

Default structure:

features/<feature>/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── providers/
    ├── pages/
    └── widgets/

Typical examples:

- Farm
- Profile
- basic Activity CRUD
- simple Notification list

---

## Complex Feature

Use a domain layer only when justified.

Possible structure:

features/<feature>/
├── data/
├── domain/
└── presentation/

Possible reasons:

- substantial business logic
- asynchronous workflow
- reusable domain operation
- complex transformation
- independently testable business rules

Examples may include:

- Plant Scan
- Assistant workflows

Do not classify a feature as complex merely because it contains several
screens.

---

# 7. Define the Feature Boundary

Before implementation, define what belongs to the feature.

Example:

Farm owns:

- farm list
- farm detail
- create farm
- edit farm
- archive farm

Farm does not automatically own:

- planting season business logic
- activities
- harvest
- weather

Those belong to their respective domains even when displayed from Farm
Detail.

Avoid creating God Features.

---

# 8. Identify Required Files

Create only files required by the current requirement.

Example for a standard feature:

features/farm/
├── data/
│   ├── datasources/
│   │   └── farm_remote_data_source.dart
│   ├── models/
│   │   └── farm_model.dart
│   └── repositories/
│       └── farm_repository.dart
└── presentation/
    ├── providers/
    │   └── farm_provider.dart
    ├── pages/
    │   └── farm_page.dart
    └── widgets/
        └── farm_card.dart

Do not create empty directories or speculative files solely to complete
an architectural template.

---

# 9. Define Data Flow

Before coding, verify the intended flow.

Default:

Page
↓
Riverpod Provider
↓
Repository
↓
Remote Data Source
↓
Shared Dio
↓
Laravel API

Response:

Laravel
↓
JSON
↓
Remote Data Source
↓
Repository
↓
Provider State
↓
Page

Do not bypass layers for convenience.

---

# 10. Implement Models

When API models are required:

- inspect API contract
- inspect existing model convention
- use Freezed/json_serializable when established
- map nullable fields correctly
- preserve backend naming through serialization mapping when necessary

Do not invent API fields.

Do not manually edit generated files.

If create/update payloads differ meaningfully from response models,
consider focused request models.

Example:

FarmModel
CreateFarmRequest

Only introduce them when they improve clarity.

---

# 11. Implement Remote Data Source

Remote Data Source owns HTTP-specific feature behavior.

Responsibilities may include:

- endpoint
- HTTP method
- path parameters
- query parameters
- request payload
- multipart payload
- API response extraction

It MUST use the shared Dio instance.

Never:

final dio = Dio();

inside the data source.

---

# 12. Implement Repository

Repository exposes feature-oriented operations.

Example:

getFarms()
getFarm(id)
createFarm(request)
updateFarm(id, request)
archiveFarm(id)

Repository should hide HTTP-specific details from Riverpod.

Repository MUST NOT:

- use BuildContext
- navigate
- show dialogs
- show snackbars
- contain widgets

---

# 13. Implement Provider

Provider orchestrates feature state.

Determine whether existing project convention uses:

- Provider
- FutureProvider
- Notifier
- AsyncNotifier
- generated Riverpod providers

Follow the existing convention.

Provider should handle relevant states:

- loading
- success
- empty
- error
- refresh
- submission

Provider MUST NOT directly call Dio.

---

# 14. Implement Presentation

Implement pages after data/state responsibilities are understood.

Page responsibilities:

- watch state
- render state
- collect input
- dispatch actions
- navigation
- UI side effects

Handle relevant states explicitly.

Example:

loading
→ Loading UI

error
→ Error UI + Retry

empty
→ Empty State + CTA

success
→ Content

---

# 15. Implement Feature Widgets

Extract meaningful feature components.

Example:

FarmCard
FarmForm
FarmEmptyState

Keep them under:

features/farm/presentation/widgets/

unless genuinely reusable across multiple features.

Do not move feature-specific components into `core/widgets`.

---

# 16. Implement Navigation

Use existing GoRouter conventions.

Check:

- route declaration
- route naming
- parameters
- query parameters
- redirect behavior

Prefer passing stable IDs through navigation rather than placing
temporary selected entities into global state without need.

---

# 17. Implement Forms

For form features:

1. initialize controllers
2. implement local input validation
3. map values into request object
4. dispatch provider action
5. handle submission state
6. respond to success/error

Do not place HTTP calls directly in submit button callbacks.

Example:

Button
↓
provider.createFarm(request)

not:

Button
↓
dio.post(...)

---

# 18. Handle Mutation Consistency

After create/update/archive/delete:

determine which existing state becomes stale.

Example:

Create Farm
↓
Success
↓
Farm List stale
↓
Update or invalidate Farm List

Use targeted refresh/invalidation.

Do not invalidate unrelated features.

---

# 19. Handle Error State

Errors must flow through established project error handling.

Do not expose raw:

DioException
SocketException
stack trace

to users.

Provide retry behavior where appropriate.

---

# 20. Handle Empty State

Empty data is a valid state.

Example:

No farms

should render an appropriate Smart Tani CTA rather than being treated
as an API failure.

---

# 21. Review Against Product Requirement

Before considering implementation complete, compare the result against
the original requirement.

Check:

- required fields
- optional fields
- actions
- validation
- navigation
- wording
- empty state
- loading state
- error state
- success state

Do not consider compilation alone sufficient.

---

# 22. Architecture Review

Verify:

- UI does not call API directly
- Provider does not call Dio directly
- Repository does not depend on UI
- Data Source uses shared Dio
- no unnecessary domain layer
- no duplicated shared infrastructure
- no unnecessary package introduced
- feature boundary remains clear

---

# 23. Code Generation

If Freezed/json_serializable code changed, run the repository's
established build_runner command.

Never manually modify generated files.

---

# 24. Format

Run:

dart format .

---

# 25. Analyze

Run:

flutter analyze

Fix errors introduced by the implementation.

Do not silently ignore warnings introduced by the change.

---

# 26. Test

Run relevant tests.

Then, when practical:

flutter test

Do not claim tests passed unless they were executed successfully.

---

# 27. Final Report

Return a concise implementation report.

Use:

## Implemented

Describe what was implemented.

## Files

List created/modified files.

## Architecture

Explain important architecture decisions.

Example:

- Standard feature architecture used.
- No domain layer introduced because the feature is straightforward
  CRUD.
- Existing Dio and error infrastructure reused.

## Validation

Report actual commands executed.

Example:

- dart format . — passed
- flutter analyze — passed
- flutter test — passed

## Remaining

Mention only real remaining dependencies or TODOs.

Do not invent completed validation.

---

# 28. Stop Conditions

Do not continue implementation blindly when:

- required API contract is missing
- requirement materially contradicts existing architecture
- required backend behavior is undefined
- implementation would require a project-wide architectural change

In those cases:

1. implement unaffected work when safe
2. identify the exact blocker
3. explain what information is required

Do not invent backend contracts.

---

# 29. Final Command Principle

Inspect first.

Reuse second.

Design only what is necessary.

Implement vertically.

Validate before reporting completion.