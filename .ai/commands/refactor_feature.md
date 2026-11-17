# Smart Tani — Refactor Feature Command

## Purpose

Use this command when refactoring existing Smart Tani Flutter code.

Examples:

- clean up a Provider / Notifier
- remove duplicate logic
- simplify a large Page
- separate API access from state management
- improve naming
- extract meaningful widgets
- reorganize a feature
- improve error handling
- reduce coupling
- improve maintainability
- align an existing feature with Smart Tani architecture

The primary goal of refactoring is:

Improve internal code quality without unintentionally changing
observable application behavior.

Read before refactoring:

1. `AGENTS.md`
2. `.ai/rules/architecture.md`
3. `.ai/rules/flutter.md`
4. `.ai/rules/provider.md`
5. relevant existing source code
6. relevant tests
7. relevant PRD / API documentation when behavior is involved

Do not begin by rewriting the feature.

Inspect and understand it first.

---

# 1. Preserve Behavior

Refactoring MUST preserve existing behavior unless the task explicitly
requests a behavior change.

Preserve:

- API contract
- request payload
- response handling
- navigation behavior
- validation behavior
- loading behavior
- user-visible behavior
- business rules
- state transitions

Do not silently combine:

refactor

with:

feature change.

If behavior must change, identify that part separately.

---

# 2. Understand the Refactor Scope

Before modifying code, determine exactly what the user asked to improve.

Possible scopes:

- one method
- one Provider
- one Page
- one Repository
- one Data Source
- one complete feature
- duplicate logic across several files

Do not expand a local refactor into a project-wide architectural
migration.

Example:

Requested:

"Refactor FarmProvider"

Do NOT automatically refactor:

- Router
- Dio configuration
- authentication
- unrelated Activity feature
- project-wide Riverpod architecture

unless they are directly required.

---

# 3. Inspect Current Implementation

Read all relevant files before proposing structural changes.

For a Provider refactor, inspect at minimum:

- provider/notifier
- state class
- repository used by provider
- relevant models
- pages consuming the provider
- widgets consuming the provider

For a Page refactor, inspect:

- page
- provider
- child widgets
- navigation
- forms/controllers
- relevant state

For Repository/DataSource refactor, inspect:

- repository
- data source
- shared Dio infrastructure
- models
- provider callers

Do not refactor a file in isolation when its public behavior is consumed
elsewhere.

---

# 4. Trace Current Data Flow

Before changing architecture, trace the current flow.

Expected Smart Tani flow:

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

Document deviations if they exist.

Example:

Current:

Page
↓
Provider
↓
Dio

Target:

Page
↓
Provider
↓
Repository
↓
RemoteDataSource
↓
Shared Dio

Do not introduce additional layers unless they solve an actual
responsibility problem.

---

# 5. Identify Problems Before Solutions

First classify actual problems.

Possible categories:

## Duplicate Logic

Examples:

- repeated API calls
- repeated response parsing
- repeated loading-state updates
- repeated error handling
- repeated request construction

## Responsibility Problem

Examples:

- API code inside Page
- Dio inside Provider
- navigation inside Repository
- business logic inside Widget

## State Problem

Examples:

- inconsistent loading flags
- stale error state
- duplicate requests
- state mutated directly
- unrelated feature states mixed together

## Maintainability Problem

Examples:

- very large methods
- deeply nested conditions
- unclear naming
- hidden side effects
- repeated magic values

## Architecture Problem

Examples:

- new Dio instance per feature
- manually attaching auth token
- feature-specific code inside core
- direct external provider access

Do not create abstractions before identifying which problem they solve.

---

# 6. Prioritize Refactoring

When multiple problems exist, use this default priority:

1. correctness risks
2. duplicate logic
3. responsibility violations
4. state inconsistencies
5. coupling
6. large methods/classes
7. naming/readability
8. cosmetic organization

Do not start with cosmetic file movement when behavior/state problems
remain.

---

# 7. Use Incremental Refactoring

Prefer small safe steps.

Example:

Step 1
Extract duplicated fetch logic.

Step 2
Centralize error handling.

Step 3
Simplify provider state transitions.

Step 4
Extract meaningful widgets.

Step 5
Rename unclear methods.

Avoid replacing the entire feature in one step when smaller changes can
achieve the goal safely.

---

# 8. Do Not Overengineer

Refactoring should usually reduce conceptual complexity.

Do NOT automatically introduce:

- Repository interface
- RepositoryImpl
- UseCase
- Entity
- DTO
- Mapper
- Service
- Manager
- Coordinator

for every operation.

Before adding an abstraction ask:

1. What duplicated responsibility does this remove?
2. What coupling does this reduce?
3. What testing problem does this solve?
4. Does the project already use this pattern?
5. Is the resulting code easier to understand?

If there is no clear benefit, do not add it.

---

# 9. Preserve Public Interfaces When Possible

Prefer preserving existing public method signatures during internal
refactoring when practical.

Example:

Existing:

Future<void> fetchFarms()

Prefer keeping the method available while improving its internals.

Changing public interfaces increases the refactor scope because every
caller must also change.

Change them only when the current interface itself is part of the
problem.

---

# 10. Refactoring Provider / Notifier

When refactoring Riverpod state:

Check for:

- duplicate loading handling
- duplicate try/catch
- direct Dio usage
- repository construction inside methods
- BuildContext usage
- navigation
- snackbar/dialog calls
- mutable list state
- unrelated responsibilities
- repeated refresh logic
- stale state
- unnecessary notify/invalidation patterns

Provider should primarily own:

- state
- feature orchestration
- refresh
- mutation orchestration

Provider should NOT own:

- raw HTTP implementation
- UI rendering
- navigation
- BuildContext
- token retrieval
- endpoint strings

---

# 11. Consolidate Duplicate Provider Logic

If several methods follow:

set loading
↓
call operation
↓
handle error
↓
update state
↓
clear loading

determine whether a small focused helper can safely reduce duplication.

Do not create a generic abstraction that hides meaningful differences
between operations.

Good extraction:

_refreshFarms()

when several actions need the same farm refresh.

Potential overengineering:

_executeAsyncOperation<T>(
  operation,
  loadingSetter,
  errorSetter,
  successHandler,
  refreshStrategy,
  mapper,
)

when used only twice and makes the flow harder to follow.

Prefer explicit readable code.

---

# 12. Refactoring Repository

Repository should expose feature-oriented operations.

Check for:

- UI dependencies
- BuildContext
- navigation
- duplicate HTTP logic
- token handling
- response presentation formatting
- unrelated domain operations

Repository should not become a generic utility class.

Prefer:

getFarms()
createFarm()
archiveFarm()

Avoid:

request()
execute()
processData()

when domain-specific naming is available.

---

# 13. Refactoring Remote Data Source

Remote Data Source should contain HTTP-specific feature behavior.

Check for:

- duplicated endpoint strings
- manually constructed Dio instances
- duplicate response extraction
- repeated query construction
- raw API behavior leaking upward

It should use shared networking infrastructure.

Do not move business/UI state into the data source.

---

# 14. Refactoring Pages

Check Pages for:

- large build methods
- API calls
- business logic
- complex transformations
- repeated widgets
- repeated conditional rendering
- unnecessary StatefulWidget usage

Page should remain primarily composition.

Extract meaningful widgets.

Do not split the Page into dozens of trivial one-line widgets.

---

# 15. Refactoring Widgets

Extract widgets based on responsibility, not arbitrary line count.

Good candidates:

FarmCard
FarmEmptyState
PlantingSeasonSummary
ActivityTimeline
PlantScanResultCard

Poor candidates:

TopRow
SecondContainer
TextOne
CustomBox3

Names should describe domain/presentation responsibility.

---

# 16. Refactoring Forms

Check forms for:

- repeated controller extraction
- duplicate validation
- API maps built inside UI
- duplicated submission handling
- controllers not disposed
- stale submission errors

Prefer:

UI Input
↓
Request Model / Input Object
↓
Provider Action
↓
Repository

Do not move simple field validation into unnecessary service classes.

---

# 17. Refactoring Error Handling

Identify repeated error handling.

Avoid every method implementing different interpretations of:

- timeout
- no connection
- unauthorized
- validation error
- server error

Reuse existing Smart Tani error infrastructure.

Do not expose raw `DioException` to UI.

Do not swallow exceptions silently.

---

# 18. Refactoring Loading State

Inspect whether loading state represents the correct operation.

Potential problem:

isLoading

is used for:

- initial fetch
- refresh
- create
- update
- archive

and causes the entire screen to reload for every mutation.

Only separate states when the UI needs the distinction.

Possible:

isLoading
isSubmitting

Do not create:

isCreating
isUpdating
isDeleting
isArchiving
isRefreshing
isFetching

unless the actual UI behavior requires all of them.

---

# 19. Refactoring Refresh Logic

Centralize refresh behavior when multiple successful operations require
the same data reload.

Example:

createFarm()
updateFarm()
archiveFarm()

may all eventually require:

_refreshFarms()

Do not duplicate the full fetch implementation in every mutation.

However, do not refetch unnecessarily if a safe local state update is
simpler and already established by the project.

---

# 20. Refactoring Authentication Handling

Remove feature-level token handling when shared authentication
infrastructure already exists.

Avoid:

final token = await secureStorage.read(...);

inside every repository/provider.

Expected:

Feature
↓
Shared Dio
↓
AuthInterceptor
↓
SecureStorage

Do not change authentication architecture during an unrelated feature
refactor unless the existing implementation violates project rules and
the change is explicitly in scope.

---

# 21. Refactoring Networking

Remove local Dio construction.

Avoid:

Dio()

inside:

- Provider
- Repository
- RemoteDataSource
- Page

Reuse the shared configured Dio client.

Do not change timeout/interceptor behavior as a side effect of a
feature refactor.

---

# 22. Refactoring Models

Do not change API model semantics merely to make code visually cleaner.

Preserve:

- JSON field mapping
- nullability
- enum semantics
- serialization behavior

If model structure must change, verify every consumer.

Generated Freezed/json_serializable files must not be manually edited.

---

# 23. Refactoring Navigation

Navigation should remain in presentation.

Remove navigation from:

- Repository
- DataSource
- domain layer

Provider should expose meaningful state rather than directly performing
UI navigation unless an established project mechanism explicitly
requires otherwise.

---

# 24. Refactoring Cross-Feature Dependencies

Check whether one feature directly depends on another feature's
presentation layer.

Avoid:

activity/
→ farm/presentation/providers/

Prefer explicit shared/domain/data dependencies when genuinely needed.

Do not solve cross-feature coupling by moving all code into `core`.

---

# 25. Refactoring Core

Do not use `core` as a destination for code that is difficult to place.

A component belongs in core only when it is genuinely shared
infrastructure or reusable UI.

Before moving something to core ask:

"Which other features currently need this?"

If there is no concrete answer, keep it feature-local.

---

# 26. Remove Dead Code Carefully

Remove:

- unused imports
- unreachable branches
- obsolete private helpers
- duplicated methods
- unused fields

only after verifying they are truly unused.

Be cautious with:

- public APIs
- reflection/code generation
- routes
- serialization
- callbacks referenced indirectly

Do not delete code merely because it appears unused in one file.

---

# 27. Avoid Premature Generic Helpers

Do not create generic helpers such as:

ApiHelper
DataManager
CommonService
UtilsManager
ProviderHelper

unless they have a single clear responsibility.

Generic names often hide mixed responsibilities.

Prefer domain-specific components.

---

# 28. Preserve Domain Semantics

Refactoring must preserve Smart Tani business meaning.

Examples:

Farm archive must not accidentally become hard delete.

Planting Season remains separate from Farm.

Plant Scan AI result remains an indication/preliminary result according
to product requirements.

Do not alter product terminology as part of code cleanup.

---

# 29. Preserve API Semantics

Do not change:

POST → PUT

PATCH → POST

archive → DELETE

nullable → required

or request/response fields

without an API requirement.

Refactoring code is not permission to redesign the backend contract.

---

# 30. Plant Scan Refactoring

Plant Scan is an asynchronous workflow.

When refactoring, preserve the conceptual flow:

select/capture image
↓
upload
↓
processing
↓
poll result
↓
completed / failed

Check specifically for:

- duplicate polling
- polling continuing after completion
- polling after provider disposal
- duplicate uploads
- stale scan result
- timers/resources not cancelled

Do not move external AI calls into Flutter.

---

# 31. Assistant Refactoring

Assistant should preserve backend-controlled context.

Flutter should not take over:

- AI prompt construction
- provider API credentials
- farm-context orchestration
- weather-context orchestration

Refactor Flutter around:

- messages
- conversation state
- sending state
- response handling

without moving backend responsibilities to mobile.

---

# 32. Validate Each Refactor Stage

After meaningful refactoring steps, verify that the affected code still
works before continuing when practical.

This reduces the size of the debugging surface.

Prefer:

Refactor A
→ analyze/test

Refactor B
→ analyze/test

over:

Rewrite everything
→ discover many unrelated failures

---

# 33. Test Preservation

Existing passing tests should remain passing unless behavior is
explicitly changed.

If refactoring reveals missing tests around risky behavior, add focused
regression tests where valuable.

Do not rewrite unrelated tests simply to match a new internal structure.

---

# 34. Formatting

After refactoring run:

dart format .

Do not manually fight Dart formatter output.

---

# 35. Static Analysis

Run:

flutter analyze

Fix issues introduced by the refactor.

Distinguish:

- pre-existing issues
- newly introduced issues

Do not claim the project is clean if unrelated pre-existing analyzer
issues remain.

---

# 36. Tests

Run the most relevant tests first.

Then, when practical:

flutter test

Report actual results.

Do not claim tests passed when they were not executed.

---

# 37. Compare Before and After

Before finishing, verify:

BEFORE behavior
=
AFTER behavior

unless an explicit behavior change was requested.

Compare:

- user flow
- API request
- response handling
- provider state
- navigation
- validation
- errors
- loading
- persistence effects

---

# 38. Refactor Report

After completion return:

## Problems Found

Only list concrete problems observed in the original implementation.

Example:

- duplicated refresh logic
- repository instantiated repeatedly
- API error handling duplicated
- provider owns UI side effects

## Changes

List what was actually changed.

## Why

Explain the architectural reason briefly.

## Behavior

State whether user-visible/API behavior was preserved.

If behavior changed, identify the change explicitly.

## Files

List modified/created/deleted files.

## Validation

Report actual commands and results.

Example:

dart format .
✓ passed

flutter analyze
✓ passed

flutter test
✓ passed

## Remaining

List real remaining issues only.

---

# 39. Priority-Based Refactoring

If the requested feature has many problems, do not force all changes
into one refactor.

Propose or execute them by priority.

Example:

P1
Remove duplicate API/state logic.

P2
Correct responsibility boundaries.

P3
Extract large UI components.

P4
Improve naming and minor cleanup.

Each priority should leave the feature in a valid state.

---

# 40. Refactor Decision Rule

For every proposed change ask:

Does this change:

1. remove duplication?
2. clarify responsibility?
3. reduce coupling?
4. improve state predictability?
5. improve testability?
6. make the code easier to understand?

If the answer is no to all of them, the change probably does not belong
in the refactor.

---

# 41. Stop Conditions

Stop and report before proceeding when the refactor requires:

- changing an undocumented API contract
- changing database/domain semantics
- replacing Riverpod
- replacing Dio
- changing authentication architecture
- changing routing architecture
- introducing a project-wide layer
- changing user-visible business behavior outside the request

Do not hide architectural migrations inside a refactor.

---

# 42. Prohibited Refactor Patterns

Avoid:

"Refactor" → rewrite entire feature

"Clean Code" → create many tiny classes

"Clean Architecture" → add layers everywhere

"Reusable" → move everything to core

"Generic" → remove meaningful domain names

"Optimization" → add complexity without measurement

"Consistency" → change unrelated features

"Cleanup" → alter API/business behavior

A refactor should leave the code simpler to reason about.

---

# 43. Final Refactoring Principle

Smart Tani refactoring follows:

Understand
↓
Identify concrete problems
↓
Prioritize
↓
Make the smallest useful change
↓
Preserve behavior
↓
Validate
↓
Continue only when necessary

The goal is not to produce the most architecturally sophisticated code.

The goal is to make Smart Tani easier and safer to maintain.