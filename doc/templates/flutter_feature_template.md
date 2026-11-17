# Smart Tani Mobile — Flutter Feature Template

## 1. Purpose

This document provides the reference implementation structure for
creating Smart Tani Flutter features.

This is a template, not a requirement to create every file shown here.

Before using this template, read:

1. `AGENTS.md`
2. `.ai/rules/architecture.md`
3. `.ai/rules/flutter.md`
4. `.ai/rules/provider.md`
5. relevant documents under `docs/architecture/`
6. existing similar Smart Tani features

Existing project implementation takes priority when it establishes a
clear convention.

---

# 2. Architecture

Default Smart Tani feature flow:

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
Laravel `/api/v1`

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

---

# 3. Standard Feature Structure

Use this structure for straightforward features:

```text
features/<feature>/
├── data/
│   ├── datasources/
│   │   └── <feature>_remote_data_source.dart
│   ├── models/
│   │   ├── <feature>_model.dart
│   │   └── create_<feature>_request.dart
│   └── repositories/
│       └── <feature>_repository.dart
│
└── presentation/
    ├── providers/
    │   └── <feature>_provider.dart
    ├── pages/
    │   ├── <feature>_page.dart
    │   └── <feature>_detail_page.dart
    └── widgets/
        ├── <feature>_card.dart
        └── <feature>_empty_state.dart
```

Create only files actually required by the feature.

---

# 4. Example Feature — Farm

This document uses `farm` as the reference feature.

Example:

```text
features/farm/
├── data/
│   ├── datasources/
│   │   └── farm_remote_data_source.dart
│   ├── models/
│   │   ├── farm_model.dart
│   │   └── create_farm_request.dart
│   └── repositories/
│       └── farm_repository.dart
│
└── presentation/
    ├── providers/
    │   └── farm_provider.dart
    ├── pages/
    │   ├── farm_page.dart
    │   ├── farm_detail_page.dart
    │   ├── create_farm_page.dart
    │   └── edit_farm_page.dart
    └── widgets/
        ├── farm_card.dart
        ├── farm_form.dart
        └── farm_empty_state.dart
```

Farm is used only as an architectural example.

Actual fields and endpoints MUST follow the current Smart Tani API
contract.

---

# 5. Step 1 — Model

Example structure:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'farm_model.freezed.dart';
part 'farm_model.g.dart';

@freezed
class FarmModel with _$FarmModel {
  const factory FarmModel({
    required String id,
    required String name,
  }) = _FarmModel;

  factory FarmModel.fromJson(Map<String, dynamic> json) =>
      _$FarmModelFromJson(json);
}
```

Important:

The fields above are illustrative.

Do NOT copy them as the final Smart Tani API contract.

The real model must be derived from the actual backend response.

---

# 6. Request Model

When create/update payload differs from the response model, use a
focused request object if it improves clarity.

Example:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_farm_request.freezed.dart';
part 'create_farm_request.g.dart';

@freezed
class CreateFarmRequest with _$CreateFarmRequest {
  const factory CreateFarmRequest({
    required String name,
  }) = _CreateFarmRequest;

  factory CreateFarmRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFarmRequestFromJson(json);
}
```

Do not create separate request classes when a simple existing model or
small payload already represents the operation clearly.

---

# 7. Step 2 — Remote Data Source

The Remote Data Source owns HTTP-specific behavior.

Conceptual example:

```dart
class FarmRemoteDataSource {
  FarmRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<FarmModel>> getFarms() async {
    final response = await _dio.get(
      ApiEndpoints.farms,
    );

    // Response extraction must follow the actual API contract.
    final items = response.data['data'] as List<dynamic>;

    return items
        .map(
          (item) => FarmModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
```

Responsibilities:

- HTTP method
- endpoint
- query/path parameters
- request payload
- response extraction

The Data Source MUST NOT instantiate `Dio()`.

---

# 8. Create Operation

Conceptual example:

```dart
Future<FarmModel> createFarm(
  CreateFarmRequest request,
) async {
  final response = await _dio.post(
    ApiEndpoints.farms,
    data: request.toJson(),
  );

  return FarmModel.fromJson(
    response.data['data'] as Map<String, dynamic>,
  );
}
```

The exact response extraction depends on the API contract.

Do not assume every response contains a `data` property.

---

# 9. Step 3 — Repository

Repository exposes feature-oriented operations.

Example:

```dart
class FarmRepository {
  FarmRepository(this._remoteDataSource);

  final FarmRemoteDataSource _remoteDataSource;

  Future<List<FarmModel>> getFarms() {
    return _remoteDataSource.getFarms();
  }

  Future<FarmModel> createFarm(
    CreateFarmRequest request,
  ) {
    return _remoteDataSource.createFarm(request);
  }
}
```

Repository must not depend on:

- BuildContext
- Widget
- Navigator
- GoRouter
- Snackbar
- Dialog

---

# 10. Repository Naming

Prefer domain operations:

```dart
getFarms()
getFarm()
createFarm()
updateFarm()
archiveFarm()
```

Avoid HTTP implementation names:

```dart
sendGetRequest()
executeFarmApi()
processFarmResponse()
```

---

# 11. Step 4 — Dependency Providers

Use Riverpod to expose dependencies.

The exact implementation MUST follow the Riverpod style already used
by Smart Tani.

Conceptual example:

```dart
final farmRemoteDataSourceProvider =
    Provider<FarmRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);

  return FarmRemoteDataSource(dio);
});

final farmRepositoryProvider =
    Provider<FarmRepository>((ref) {
  final remoteDataSource =
      ref.watch(farmRemoteDataSourceProvider);

  return FarmRepository(remoteDataSource);
});
```

Do not create another Dio instance here.

---

# 12. Step 5 — Feature Provider

The exact Riverpod implementation depends on the project's established
style.

Conceptually:

```text
FarmPage
↓
Farm Provider
↓
FarmRepository
```

Provider owns:

- async state
- refresh
- mutation orchestration

Provider does not own HTTP details.

---

# 13. AsyncNotifier Example

If the project uses Riverpod code generation and AsyncNotifier, a
conceptual implementation may look like:

```dart
@riverpod
class FarmNotifier extends _$FarmNotifier {
  @override
  Future<List<FarmModel>> build() async {
    return _loadFarms();
  }

  Future<List<FarmModel>> _loadFarms() {
    return ref.read(farmRepositoryProvider).getFarms();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      _loadFarms,
    );
  }
}
```

This is an example only.

Do not change the project's Riverpod style merely to match this
template.

---

# 14. Mutation Example

Conceptually:

```dart
Future<void> createFarm(
  CreateFarmRequest request,
) async {
  final repository = ref.read(farmRepositoryProvider);

  await repository.createFarm(request);

  await refresh();
}
```

Actual implementation should consider:

- submission state
- validation errors
- duplicate submissions
- whether refresh is necessary
- whether local state update is simpler

Do not automatically refetch everything after every mutation.

---

# 15. Step 6 — Page

Example:

```dart
class FarmPage extends ConsumerWidget {
  const FarmPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farms = ref.watch(farmProvider);

    return Scaffold(
      body: farms.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return FarmErrorView(
            onRetry: () {
              ref
                  .read(farmProvider.notifier)
                  .refresh();
            },
          );
        },
        data: (items) {
          if (items.isEmpty) {
            return const FarmEmptyState();
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return FarmCard(
                farm: items[index],
              );
            },
          );
        },
      ),
    );
  }
}
```

The Page:

- observes state
- renders state
- dispatches user actions

The Page does not call the API directly.

---

# 16. Loading State

Every network-driven feature must consider loading.

Use the established Smart Tani loading component when one exists.

Do not introduce a different loading design per feature without a UX
requirement.

---

# 17. Empty State

Empty state is a valid result.

Farm example:

```text
Belum ada lahan.
```

The final copy must follow the approved product/UI design.

Empty state may include a relevant CTA.

Example:

```text
Tambah Lahan
```

---

# 18. Error State

Error state should provide understandable feedback.

Example:

```text
Data lahan belum dapat dimuat.
Silakan coba lagi.
```

Possible action:

```text
Coba Lagi
```

Do not display raw `DioException`.

---

# 19. Feature Widget

Example:

```dart
class FarmCard extends StatelessWidget {
  const FarmCard({
    required this.farm,
    super.key,
  });

  final FarmModel farm;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(farm.name),
      ),
    );
  }
}
```

The actual Farm Card must follow the Smart Tani design and PRD.

Do not treat this simplified example as UI specification.

---

# 20. Form Pattern

Typical form flow:

User Input
↓
Form Validation
↓
Request Object
↓
Provider
↓
Repository
↓
API

Example:

```dart
Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  final request = CreateFarmRequest(
    name: _nameController.text.trim(),
  );

  await ref
      .read(farmProvider.notifier)
      .createFarm(request);
}
```

Do not construct Dio requests inside the form.

---

# 21. Form State

Keep simple input state local when appropriate.

Examples:

- TextEditingController
- FocusNode
- password visibility

Feature/network submission state belongs to Riverpod.

Controllers owned by the widget must be disposed appropriately.

---

# 22. Navigation Pattern

Navigation uses GoRouter.

Example conceptual flow:

FarmPage
↓
CreateFarmPage
↓
Create Farm
↓
Success
↓
Return / Update Farm List

Follow the current project route definitions.

Do not hardcode an alternative navigation architecture inside the
feature.

---

# 23. Detail Pattern

Prefer stable identifiers for detail routes.

Conceptually:

```text
/farms/:farmId
```

Then:

```text
farmId
↓
farmDetailProvider(farmId)
↓
repository.getFarm(farmId)
```

Do not automatically create a global `selectedFarmProvider` solely for
navigation.

---

# 24. Refresh Pattern

Pull-to-refresh:

```text
UI
↓
provider.refresh()
↓
repository
↓
API
↓
new state
```

Do not duplicate fetch implementation in the Page.

---

# 25. Mutation Pattern

For:

- create
- update
- archive

determine which state becomes stale.

Example:

Create Farm
↓
Success
↓
Farm List stale
↓
Update or refresh relevant Farm state

Use targeted invalidation/update.

---

# 26. Archive Pattern

Do not automatically implement hard delete for business resources.

For Farm, product requirements favor archive behavior so historical
records can remain available.

Actual endpoint and request semantics must follow the API contract.

---

# 27. Complex Feature Template

Use additional layers only when justified.

Example:

```text
plant_scan/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    ├── pages/
    └── widgets/
```

Do not copy this structure into ordinary CRUD features.

---

# 28. Plant Scan Example Flow

Conceptually:

```text
PlantScanPage
      │
      ▼
PlantScan Provider
      │
      ▼
PlantScan Repository
      │
      ▼
Remote Data Source
      │
      ▼
POST /plant-scans
      │
      ▼
processing
      │
      ▼
poll GET /plant-scans/{id}
      │
      ├── processing → continue
      │
      ├── completed → result
      │
      └── failed → error
```

The backend controls AI-provider interaction.

Flutter does not contain external AI credentials.

---

# 29. Polling Requirements

When implementing polling:

- prevent duplicate polling
- stop on completed state
- stop on failed state
- stop when lifecycle ownership ends
- avoid uncontrolled infinite polling
- respect backend/API requirements

Polling must not be implemented inside Widget `build()`.

---

# 30. Error Handling Template

Conceptual:

```text
DioException
↓
Shared Error Mapper
↓
Application Error
↓
Repository
↓
Provider
↓
UI Error State
```

Do not create feature-specific interpretations of common network errors
when shared handling already exists.

---

# 31. Testing Template

Recommended test structure:

```text
test/
└── features/
    └── farm/
        ├── data/
        │   └── farm_repository_test.dart
        └── presentation/
            └── farm_provider_test.dart
```

Create tests that provide meaningful confidence.

Prioritize:

- model parsing when non-trivial
- repository behavior
- provider state transitions
- critical business rules
- regressions

---

# 32. Provider Test Cases

Useful cases may include:

```text
Initial
↓
Loading
↓
Success
```

```text
Initial
↓
Loading
↓
Error
```

and:

```text
Create Farm
↓
Success
↓
Farm state updated/refreshed
```

Test feature behavior rather than Riverpod implementation internals.

---

# 33. Feature Implementation Checklist

Before implementation:

- [ ] Read the requirement.
- [ ] Read relevant PRD.
- [ ] Check API contract.
- [ ] Check database/domain documentation if relevant.
- [ ] Inspect existing feature.
- [ ] Find closest implementation.
- [ ] Inspect shared infrastructure.
- [ ] Determine Standard vs Complex feature.

Data:

- [ ] API model defined from actual contract.
- [ ] Request model added only if useful.
- [ ] Remote Data Source implemented.
- [ ] Shared Dio reused.
- [ ] Repository implemented.
- [ ] No BuildContext below presentation.

State:

- [ ] Existing Riverpod style followed.
- [ ] Loading handled.
- [ ] Success handled.
- [ ] Empty handled.
- [ ] Error handled.
- [ ] Refresh defined when needed.
- [ ] Mutation consistency handled.
- [ ] Provider contains no raw HTTP logic.

Presentation:

- [ ] Page remains thin.
- [ ] Meaningful widgets extracted.
- [ ] No API call from UI.
- [ ] Navigation uses GoRouter.
- [ ] Forms preserve user input on recoverable failure.
- [ ] User-facing error messages are understandable.

Architecture:

- [ ] No unnecessary domain layer.
- [ ] No duplicate Dio instance.
- [ ] No hardcoded API base URL.
- [ ] No manually attached auth token.
- [ ] No feature logic moved prematurely to core.
- [ ] No new package without justification.

Validation:

- [ ] Generated code updated when required.
- [ ] `dart format .`
- [ ] `flutter analyze`
- [ ] relevant tests
- [ ] `flutter test` when practical

---

# 34. Agent Implementation Order

When an agent creates a feature, use this order:

1. Understand requirement
2. Inspect existing project
3. Inspect similar feature
4. Read PRD/API/domain documentation
5. Define feature boundary
6. Determine Standard vs Complex
7. Define model/request
8. Implement Remote Data Source
9. Implement Repository
10. Implement dependency providers
11. Implement feature Provider/Notifier
12. Implement Page
13. Implement feature widgets
14. Connect routing
15. Handle loading/empty/error
16. Add meaningful tests
17. Generate code
18. Format
19. Analyze
20. Test
21. Report changes

Do not start by generating every possible file.

---

# 35. What Not to Copy Blindly

This document contains illustrative code.

Do NOT blindly copy:

- model fields
- endpoint paths
- JSON response structure
- Riverpod provider type
- route paths
- error response structure

Always verify against:

1. existing project code
2. current API contract
3. current PRD
4. current architecture

---

# 36. Final Principle

This template provides a baseline, not bureaucracy.

Use:

the smallest number of layers and files required to implement the
feature correctly while preserving Smart Tani architecture.

A feature is complete when:

- responsibility is clear
- state flow is predictable
- API integration follows project conventions
- UI handles relevant states
- implementation is validated

Not when every possible architectural layer exists.