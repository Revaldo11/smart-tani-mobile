# Smart Tani Flutter Architecture Rules

## Purpose

This document defines the detailed architecture rules for Smart Tani
Mobile.

Read `AGENTS.md` before using this document.

---

# 1. Architecture Style

Smart Tani uses Feature-First Architecture.

Primary structure:

lib/
├── app/
├── core/
└── features/

The architecture should optimize for:

- feature isolation
- predictable dependencies
- maintainability
- testability
- simple navigation through the codebase

Architecture MUST remain proportional to feature complexity.

---

# 2. Dependency Direction

The standard request flow is:

Presentation
↓
Riverpod
↓
Repository
↓
Remote Data Source
↓
Dio
↓
Laravel API

The standard response flow is:

Laravel API
↓
Remote Data Source
↓
Repository
↓
Provider State
↓
Presentation

Higher-level layers MUST NOT depend on concrete UI implementation.

Lower-level infrastructure MUST NOT depend on presentation.

---

# 3. Layer Responsibilities

## Presentation

Location:

features/<feature>/presentation/

Contains:

- pages
- widgets
- providers/notifiers
- presentation state

Responsibilities:

- render UI
- observe state
- dispatch user actions
- navigation
- UI-specific formatting when appropriate

Presentation MUST NOT:

- directly call Dio
- know API URLs
- parse raw HTTP responses
- store authentication tokens
- contain persistence logic

---

## Data

Location:

features/<feature>/data/

Contains:

- models
- remote data sources
- repositories

Responsibilities:

- communicate with API infrastructure
- serialize/deserialize API data
- provide feature data operations
- translate infrastructure results into values usable by state layer

---

## Domain

Location:

features/<feature>/domain/

Domain is OPTIONAL.

Use it only when feature complexity requires independent business logic.

Potential contents:

- entities
- repository contracts
- use cases

Introduce the domain layer when one or more conditions apply:

1. Business logic is substantial.
2. Logic must operate independently from Flutter/UI.
3. Multiple presentation flows reuse the same business operation.
4. Repository implementation needs meaningful abstraction.
5. Testing business rules independently provides clear value.

Do NOT introduce domain merely because Clean Architecture diagrams
usually contain it.

---

# 4. Standard Feature

Default structure:

feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── providers/
    ├── pages/
    └── widgets/

Use this by default.

Example:

farm/
├── data/
│   ├── datasources/
│   │   └── farm_remote_data_source.dart
│   ├── models/
│   │   └── farm_model.dart
│   └── repositories/
│       └── farm_repository.dart
└── presentation/
    ├── providers/
    │   ├── farm_provider.dart
    │   └── farm_state.dart
    ├── pages/
    │   ├── farm_page.dart
    │   ├── farm_detail_page.dart
    │   └── create_farm_page.dart
    └── widgets/
        └── farm_card.dart

---

# 5. Complex Feature

Example:

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

Plant Scan is a candidate because its workflow can involve:

Camera / Gallery
↓
Upload
↓
Processing
↓
Polling
↓
AI Result
↓
Recommendation

Do not assume every Smart Tani feature requires this structure.

---

# 6. Cross-Feature Dependencies

Avoid:

feature A
→ presentation of feature B

For example:

activity/
→ farm/presentation/providers/farm_provider.dart

should generally be avoided.

If multiple features require the same reusable infrastructure,
determine whether it belongs in:

- core
- a shared domain abstraction
- an existing parent feature

Do NOT create a global shared layer prematurely.

---

# 7. Core Rules

`core` is infrastructure shared by multiple features.

Examples:

core/
├── constants/
├── error/
├── network/
├── storage/
├── theme/
├── utils/
└── widgets/

Appropriate for core:

- Dio configuration
- authentication interceptor
- common API exception mapping
- secure storage wrapper
- application theme
- genuinely reusable widgets

Not appropriate for core:

- FarmCard
- HarvestForm
- PlantScanResult
- ActivityRecommendation

Those belong to their respective features.

---

# 8. Repository Responsibilities

Repositories expose operations required by a feature.

Example:

FarmRepository

may expose:

getFarms()
getFarm(id)
createFarm(request)
updateFarm(id, request)
archiveFarm(id)

Repository MUST NOT contain:

- BuildContext
- navigation
- dialogs
- snackbars
- UI state
- Widget references

Repository methods should represent domain/API operations rather than
HTTP implementation details.

Prefer:

getFarms()

instead of:

sendGetFarmHttpRequest()

---

# 9. Remote Data Source Responsibilities

RemoteDataSource handles API-specific communication.

Example:

FarmRemoteDataSource

Responsibilities:

- endpoint invocation
- query/path parameters
- request body
- response extraction
- API-specific serialization

It should use the shared Dio instance.

It MUST NOT instantiate its own Dio client.

---

# 10. Riverpod Responsibilities

Riverpod connects data operations with presentation state.

Example:

FarmNotifier
↓
FarmRepository

Provider/Notifier handles:

- orchestration
- loading
- success
- error
- refresh
- mutations

It should not know low-level HTTP implementation details.

Avoid:

provider
→ dio.get(...)

Use:

provider
→ repository.getFarms()

---

# 11. State Ownership

Ask:

"Who owns this state?"

### UI-only state

Examples:

- password visibility
- expanded/collapsed
- currently selected local tab

May stay local.

### Feature state

Examples:

- farms
- activities
- current planting season
- plant scan result
- loading/error states

Belongs to Riverpod.

### Persistent application state

Examples:

- authentication session
- environment
- user session information

Belongs to application-level providers/services.

Do not promote local state to global state without need.

---

# 12. Model Boundaries

API models should mirror the backend contract sufficiently to provide
safe serialization.

Do not mix Flutter UI concepts into API models.

Avoid fields such as:

Color statusColor
IconData icon

inside API/domain models.

Translate those concepts in presentation.

---

# 13. API Boundary

The Flutter application communicates only with Laravel for Smart Tani
business operations.

Expected:

Flutter
→ Laravel
→ AI Provider

Not:

Flutter
→ AI Provider

Expected:

Flutter
→ Laravel
→ Weather Provider

Not:

Flutter
→ Weather Provider

This keeps:

- API credentials on backend
- business rules centralized
- provider changes isolated from mobile

---

# 14. Authentication Boundary

Feature repositories should not know how authentication tokens are
stored.

Expected:

Feature
↓
Shared Dio
↓
AuthInterceptor
↓
SecureStorage

Not:

Feature
↓
SecureStorage
↓
Read Token
↓
Manually Build Authorization Header

---

# 15. Environment Boundary

Feature implementation MUST be environment-agnostic.

Feature code should not contain:

api-dev.smarttani...
api-staging.smarttani...
api.smarttani...

Instead:

Feature
↓
Dio
↓
Environment Configuration
↓
Base URL

---

# 16. Error Boundary

Infrastructure errors should stop at the infrastructure/application
boundary.

Example:

DioException
↓
ErrorMapper
↓
AppException / Failure
↓
Repository
↓
Provider
↓
UI State

UI should receive meaningful state rather than low-level HTTP
exceptions.

---

# 17. Vertical Slice Development

Smart Tani should preferably be developed using vertical slices.

Example Farm slice:

Database/API
↓
Farm Model
↓
Farm DataSource
↓
Farm Repository
↓
Farm Provider
↓
Farm UI
↓
Tests

Complete one usable feature flow before creating speculative
architecture for multiple future features.

---

# 18. Architecture Decision Checklist

Before creating a new class/layer, ask:

1. What responsibility does it own?
2. Does an existing component already own this responsibility?
3. Will more than one caller use this abstraction?
4. Does it simplify testing?
5. Does it reduce coupling?
6. Does it make the code easier to understand?

If most answers are "no", do not create the abstraction.

---

# 19. Architecture Smells

Watch for:

## Fat Page

Symptoms:

- API calls
- JSON parsing
- business rules
- navigation logic
- large UI composition

Solution:

Move appropriate state/orchestration into Riverpod and extract
feature-specific widgets.

## Fat Provider

Symptoms:

- hundreds of lines
- unrelated responsibilities
- networking implementation
- formatting
- multiple feature domains

Solution:

Move data access to repositories/data sources and separate genuinely
different responsibilities.

## God Core

Symptoms:

core/
├── helpers/
├── managers/
├── services/
└── utils/

containing unrelated feature logic.

Solution:

Move domain-specific code back to its owning feature.

## Repository as UI Controller

Symptoms:

- BuildContext
- showDialog
- navigation
- snackbars

inside repository.

This is prohibited.

## Unnecessary Clean Architecture

Symptoms:

One API endpoint requires:

Page
→ Provider
→ UseCase
→ Repository Interface
→ RepositoryImpl
→ DataSource
→ API Service

without meaningful business logic.

Simplify the dependency chain.

---

# 20. Architecture Review Rule

Any proposal that changes one of these requires explicit architectural
review:

- state management
- networking library
- routing library
- project-level folder strategy
- authentication storage
- API boundary
- environment strategy
- introduction of a new global service layer

Feature implementation should not silently make project-wide
architecture decisions.

---

# 21. Final Principle

The preferred Smart Tani architecture is the simplest architecture that:

- preserves feature boundaries
- maintains predictable dependency flow
- remains testable
- avoids duplicate infrastructure
- supports current MVP requirements
- can evolve when real complexity appears

Do not optimize the architecture for hypothetical future complexity.