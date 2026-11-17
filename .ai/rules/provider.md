# Smart Tani — Riverpod Provider Rules

## Purpose

This document defines Riverpod state-management rules for Smart Tani.

The word "Provider" in this document refers to Riverpod providers and
not the Flutter `provider` package.

Read:

1. `AGENTS.md`
2. `.ai/rules/architecture.md`
3. `.ai/rules/flutter.md`
4. this document

before introducing or modifying feature state.

---

# 1. State Management

Smart Tani uses Riverpod.

Do NOT introduce:

- Provider package
- Bloc
- Cubit
- GetX
- MobX

unless a project-wide architectural decision explicitly changes the
state-management strategy.

---

# 2. Provider Responsibility

Provider/Notifier is responsible for coordinating presentation state
with feature operations.

Typical flow:

Page
↓
Provider / Notifier
↓
Repository
↓
Remote Data Source
↓
Dio

Provider may handle:

- loading
- success
- empty
- error
- refresh
- create/update/delete orchestration
- selected feature state when appropriate

Provider MUST NOT become an alternative repository.

---

# 3. Provider Must Not Perform HTTP

Prohibited:

final response = await dio.get('/farms');

inside a feature provider.

Expected:

final farms = await repository.getFarms();

Networking implementation belongs below the provider layer.

---

# 4. Provider Must Not Know HTTP Details

Provider should not need to know:

- endpoint URL
- Authorization header
- HTTP client configuration
- JSON response extraction
- Dio interceptors

Avoid:

if (response.statusCode == 200) ...

inside provider.

That belongs to the data/network layer.

---

# 5. Provider Must Not Depend on BuildContext

Never:

Future<void> createFarm(BuildContext context)

Provider MUST NOT:

- show dialogs
- show snackbars
- navigate
- access Navigator
- access GoRouter through BuildContext

Instead expose state/result.

Presentation decides how that state affects UI.

---

# 6. Provider Scope

Create providers at the smallest useful scope.

Do not create global providers for state that belongs to a single
feature.

Examples:

farmProvider
activityProvider
plantScanProvider

Application-wide providers are appropriate for genuinely global
concerns such as:

- authentication
- environment
- application session

---

# 7. Provider Naming

Use domain-specific names.

Examples:

farmRepositoryProvider
farmListProvider
farmDetailProvider
createFarmProvider

or:

farmNotifierProvider

depending on the project's established Riverpod style.

Avoid:

dataProvider
mainProvider
globalProvider
managerProvider

---

# 8. Riverpod Style Consistency

Before creating a new provider, inspect existing Smart Tani providers.

Determine whether the project currently uses:

- manual providers
- Notifier
- AsyncNotifier
- Riverpod code generation

Follow the existing project convention.

Do NOT mix multiple Riverpod styles without a reason.

For example, if the project uses:

@riverpod
class FarmNotifier extends _$FarmNotifier

do not introduce a manual `StateNotifierProvider` for a similar feature
without justification.

---

# 9. Prefer Async State for Async Data

Network-driven state should clearly represent asynchronous lifecycle.

Conceptually:

loading
↓
data
or
error

Use the established Riverpod async-state pattern.

`AsyncValue` is preferred when it fits the current project convention.

Do not manually recreate loading/error/data state if the established
project already handles it through AsyncValue.

---

# 10. Custom State

Use a custom Freezed state when one provider needs to represent
multiple related values.

Example:

@freezed
class FarmState with _$FarmState {
  const factory FarmState({
    @Default([]) List<FarmModel> farms,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _FarmState;
}

Use custom state when it improves clarity.

Do NOT create a large custom state merely to avoid using appropriate
Riverpod primitives.

---

# 11. Separate Loading Concerns

Do not use one ambiguous `isLoading` when multiple independent
operations can occur simultaneously.

Example:

isLoading
isSubmitting

may be clearer than one flag.

Possible operations:

initial loading
refresh
create
update
archive

However, do not create a boolean for every possible operation unless
the UI actually needs to distinguish them.

---

# 12. State Immutability

Provider state should be immutable.

Avoid mutating lists directly.

Avoid:

state.farms.add(farm);

Prefer creating updated immutable state according to the established
state implementation.

State transitions must remain predictable.

---

# 13. Repository Injection

Repositories should be provided/injected through Riverpod rather than
constructed repeatedly inside provider methods.

Avoid:

Future<void> load() async {
  final repository = FarmRepository(Dio());
}

Expected conceptual flow:

dioProvider
↓
farmRemoteDataSourceProvider
↓
farmRepositoryProvider
↓
farmProvider

Reuse existing dependency providers.

---

# 14. Dependency Graph

Preferred dependency graph:

environmentProvider
        │
        ▼
    dioProvider
        │
        ▼
RemoteDataSourceProvider
        │
        ▼
RepositoryProvider
        │
        ▼
Feature Provider
        │
        ▼
       UI

This makes dependencies explicit and testable.

---

# 15. `ref.watch`

Use `ref.watch` when the current provider/widget should react to
changes in another provider.

Example conceptual use:

final state = ref.watch(farmProvider);

A watched dependency should represent a reactive relationship.

Do not use `watch` simply to retrieve a value once.

---

# 16. `ref.read`

Use `ref.read` for imperative actions or one-time access.

Typical UI example:

ref.read(farmProvider.notifier).refresh();

Do not use `read` when UI must automatically rebuild when the value
changes.

---

# 17. `ref.listen`

Use `ref.listen` for side effects caused by state transitions.

Examples:

- show success snackbar
- show error dialog
- redirect after login
- close modal after successful submission

Do not use listeners to render ordinary UI.

Rendering should generally use `watch`.

---

# 18. Avoid Watching Too Much

A widget should watch only state it needs.

If an established provider exposes large state and a widget only needs
one small field, consider Riverpod selection where it meaningfully
reduces unnecessary rebuilds.

Do not prematurely optimize every provider with selectors.

Use them when rebuild behavior matters.

---

# 19. Initialization

Do not trigger the same API request from multiple lifecycle locations.

Avoid combinations such as:

initState()
+
postFrameCallback()
+
provider build()
+
page build()

all fetching the same resource.

There must be one clear owner for initial data loading.

---

# 20. Refresh

Refresh behavior should be explicit.

Example:

Future<void> refresh()

or provider invalidation according to established project style.

Pull-to-refresh should call the feature's refresh mechanism rather than
duplicate fetch logic inside the page.

---

# 21. Provider Invalidation

Invalidate state when data is genuinely stale.

Example:

Create Farm succeeds
↓
farm list becomes stale
↓
refresh/invalidate farm list

Do not globally invalidate unrelated providers.

Prefer targeted invalidation.

---

# 22. Mutation Flow

Typical create operation:

User
↓
CreateFarmPage
↓
Farm Provider
↓
FarmRepository.createFarm()
↓
API
↓
Success
↓
Refresh/Update relevant state
↓
UI feedback

Do not duplicate the create operation in both Page and Provider.

---

# 23. Optimistic Update

Use optimistic updates only when:

- UX materially benefits
- operation is predictable
- rollback behavior is clear

Do not introduce optimistic updates automatically.

For critical agricultural records such as harvest or persistent farm
data, prefer confirmed server state unless product requirements specify
otherwise.

---

# 24. Error Handling

Provider receives application-level errors from lower layers.

Conceptual flow:

DioException
↓
Network/Error Layer
↓
AppFailure
↓
Repository
↓
Provider
↓
UI State

Provider should not expose raw DioException to UI.

---

# 25. Error State Reset

When retrying an operation, stale errors should not remain visible
unless intentionally retained.

State transitions should clearly represent:

error
↓
retry/loading
↓
success/error

Avoid situations where:

data = success
errorMessage = previous error

unless partial-error behavior is intentionally designed.

---

# 26. Preserve Existing Data During Refresh

Initial load and refresh are not always equivalent.

For initial load:

Loading
↓
Data

For refresh:

Existing Data
+
Refreshing
↓
Updated Data

When UX benefits, avoid unnecessarily replacing existing content with a
full loading screen during refresh.

Follow the feature requirements.

---

# 27. Empty State

An empty collection is not automatically an error.

Example:

GET /farms
→ []

should normally produce an empty state such as:

"Belum ada lahan"

rather than:

"Gagal mengambil data"

The presentation layer determines the final wording.

---

# 28. Pagination

If pagination is introduced, provider state should explicitly track the
minimum necessary pagination information.

Possible state:

items
currentPage
hasMore
isLoadingMore

Do not mix initial loading and load-more state into ambiguous flags when
the UI needs to distinguish them.

---

# 29. Parameterized Providers

Use provider parameters/family when state naturally depends on an
identifier.

Examples:

farmDetailProvider(farmId)

plantingSeasonProvider(farmId)

Avoid storing temporary IDs globally simply so another provider can
access them.

---

# 30. Derived State

Do not store values that can be safely derived from existing state
unless computation or domain requirements justify it.

For example:

hasFarm = farms.isNotEmpty

usually does not need separate mutable state.

Prefer derived state to duplicated state.

---

# 31. Selected Entity State

Do not create global:

selectedFarmProvider

automatically.

First determine whether the selection is:

- page-local
- route-based
- feature-level
- application-level

Prefer passing stable identifiers through routes when that better
represents navigation state.

---

# 32. Authentication Provider

Authentication state may be application-wide.

Expected responsibilities:

- authenticated/unauthenticated state
- login orchestration
- logout orchestration
- session restoration

Authentication provider should depend on authentication repository.

It should NOT manually configure Authorization headers.

That remains the responsibility of shared network infrastructure.

---

# 33. Plant Scan State

Plant Scan has asynchronous processing requirements.

Conceptual states may include:

idle
↓
uploading
↓
processing
↓
completed

or:

error

Provider may orchestrate:

upload
↓
receive scan identifier
↓
poll result
↓
stop polling on terminal state

Polling implementation must:

- avoid duplicate timers/requests
- stop when completed
- stop when failed
- stop when provider is disposed when applicable
- avoid endless polling without defined behavior

Do not implement polling directly inside the page.

---

# 34. Assistant State

Assistant conversations may contain:

messages
isSending
conversationId
error

Avoid re-fetching the entire conversation unnecessarily after every
message if the API contract allows predictable state updates.

Do not put LLM/API-provider credentials or prompt construction in
Flutter state.

AI context belongs to Laravel.

---

# 35. Provider Lifecycle

Choose lifecycle according to state ownership.

Do not keep every provider alive indefinitely.

Temporary page/feature state should be disposable when appropriate.

Persistent session-level state may require longer lifetime.

Do not use `keepAlive` automatically.

There must be a clear reason.

---

# 36. Auto Dispose

Auto-dispose is appropriate for state that does not need to survive
after its consumers disappear.

Examples may include:

- detail screen state
- temporary search
- one-time form workflow

Do not auto-dispose application session state.

Follow existing project conventions.

---

# 37. Provider Size

A provider becoming large is a signal to inspect responsibilities.

Do not split a provider solely based on line count.

Split when it owns unrelated behavior.

For example:

FarmNotifier

should not eventually manage:

farms
activities
weather
plant scan
harvest
notifications

Each feature should own its own state.

---

# 38. No Provider-to-Provider Mutation Chains

Avoid fragile chains where:

Provider A mutates Provider B
↓
Provider B mutates Provider C
↓
Provider C invalidates Provider A

Prefer explicit dependencies and targeted invalidation.

Cross-feature coordination should be deliberate.

---

# 39. No UI Formatting in Provider

Avoid presentation formatting such as:

"Rp 1.000.000"
"12 Januari 2026"
Color.green
Icons.check

inside provider state unless it represents an actual domain value.

Provider should expose raw/semantic values.

Presentation performs UI formatting.

---

# 40. No Navigation State Inside Feature Provider

Avoid:

bool shouldNavigateToHome

when navigation can cleanly respond to a meaningful state transition.

Example:

authentication state
unauthenticated → authenticated

The UI/router can react accordingly.

---

# 41. Testing Providers

Provider tests should focus on meaningful state transitions.

Examples:

initial
↓
loading
↓
success

initial
↓
loading
↓
error

create farm
↓
success
↓
farm list updated/refreshed

Mock/fake dependencies at repository boundaries when appropriate.

Avoid testing Riverpod internals.

Test Smart Tani behavior.

---

# 42. Provider Review Checklist

Before creating a provider, ask:

1. What state does this provider own?
2. Which feature owns this state?
3. Is this state local UI state instead?
4. Does an existing provider already own it?
5. What repository does it depend on?
6. Does it need AsyncValue or custom state?
7. What invalidates the state?
8. How is error represented?
9. What happens when the provider is disposed?
10. Does the provider contain anything belonging to networking/UI?

If ownership cannot be explained clearly, reconsider the provider
design.

---

# 43. Provider Completion Checklist

Before considering provider work complete:

- no direct Dio usage
- no BuildContext
- no navigation implementation
- no dialogs/snackbars
- repository injected
- state immutable
- loading handled
- empty handled where relevant
- error handled
- refresh behavior defined
- lifecycle considered
- invalidation targeted
- duplicate requests avoided
- provider follows existing Riverpod style

---

# 44. Final Provider Principle

A Smart Tani provider should answer:

"What state does this feature currently have, and what feature action
should happen next?"

It should NOT answer:

"How does HTTP work?"

It should NOT answer:

"How should this screen be drawn?"

It should NOT answer:

"Where should the user navigate?"

Keep state orchestration in Riverpod, data access below it, and UI
behavior above it.