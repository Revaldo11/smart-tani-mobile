# Smart Tani Mobile — Flutter Architecture

## 1. Overview

Smart Tani Mobile is a Flutter application that communicates with the
Smart Tani Laravel backend through a versioned REST API.

High-level architecture:

Flutter Mobile
        │
        │ HTTPS / JSON
        ▼
Laravel REST API
        │
        ├── MySQL
        ├── AI Provider
        ├── Weather Provider
        ├── Storage
        └── Other Backend Services

Flutter does not communicate directly with database infrastructure or
private third-party providers.

Laravel acts as the primary backend boundary.

---

## 2. Technology Stack

The Smart Tani Flutter application uses:

- Flutter
- Dart
- Riverpod
- Dio
- GoRouter
- Freezed
- json_serializable
- flutter_secure_storage
- shared_preferences
- cached_network_image
- image_picker
- firebase_messaging

Environment configuration is provided through the project's environment
configuration mechanism such as `--dart-define`.

---

## 3. Architecture Style

Smart Tani uses Feature-First Architecture.

Top-level structure:

lib/
├── main.dart
├── app/
├── core/
└── features/

The architecture prioritizes:

- feature isolation
- predictable dependencies
- maintainability
- explicit state flow
- reuse of shared infrastructure
- proportional complexity

Smart Tani does not require full Clean Architecture for every feature.

---

## 4. Application Layer

`app/` contains application-level configuration.

Example:

app/
├── app.dart
├── bootstrap.dart
├── router.dart
└── environment.dart

Responsibilities include:

- application initialization
- environment initialization
- root application configuration
- routing
- global application providers when required

Feature-specific business logic must not be placed here.

---

## 5. Core Layer

`core/` contains infrastructure shared by multiple features.

Example:

core/
├── constants/
├── error/
├── network/
├── storage/
├── theme/
├── utils/
└── widgets/

Examples of appropriate core responsibilities:

- shared Dio configuration
- authentication interceptor
- network error mapping
- secure storage
- application theme
- common widgets

`core` must not become a collection of unrelated feature logic.

---

## 6. Feature Layer

Business functionality is grouped by feature.

MVP feature structure:

features/
├── auth/
├── home/
├── farm/
├── planting_season/
├── activity/
├── plant_scan/
├── assistant/
├── harvest/
├── notification/
└── profile/

A feature owns the implementation required for its domain.

---

## 7. Standard Feature Architecture

Most straightforward features use:

feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── providers/
    ├── pages/
    └── widgets/

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
    │   └── farm_provider.dart
    ├── pages/
    │   ├── farm_page.dart
    │   └── farm_detail_page.dart
    └── widgets/
        └── farm_card.dart

---

## 8. Complex Feature Architecture

Features with substantial independent business logic may introduce a
domain layer.

feature/
├── data/
├── domain/
└── presentation/

Possible domain contents:

domain/
├── entities/
├── repositories/
└── usecases/

A domain layer is introduced only when it provides real value.

Do not introduce it merely for architectural symmetry.

Plant Scan is an example of a feature that may justify additional
domain/orchestration complexity because processing is asynchronous.

---

## 9. Dependency Flow

Standard request flow:

Presentation
      │
      ▼
Riverpod Provider
      │
      ▼
Repository
      │
      ▼
Remote Data Source
      │
      ▼
Shared Dio
      │
      ▼
Laravel REST API

Response flow:

Laravel REST API
      │
      ▼
JSON
      │
      ▼
Remote Data Source
      │
      ▼
Repository
      │
      ▼
Riverpod State
      │
      ▼
Presentation

Layers must not be bypassed without a documented reason.

---

## 10. Example — Farm

Example request:

GET /api/v1/farms

Flow:

FarmPage
    ↓
Farm Provider
    ↓
FarmRepository
    ↓
FarmRemoteDataSource
    ↓
Shared Dio
    ↓
Laravel API
    ↓
FarmResource / JSON
    ↓
FarmModel
    ↓
Provider State
    ↓
FarmPage

---

## 11. State Management

Riverpod is responsible for application and feature state.

Typical responsibilities:

- loading
- data
- empty
- error
- refresh
- mutation orchestration

UI-specific temporary state may remain local to a widget.

Examples:

- password visibility
- expanded section
- temporary selected tab

Network/business state belongs to Riverpod.

See:

`state_management.md`

---

## 12. Networking

Dio is the standard HTTP client.

Features must use the shared configured Dio instance.

Features must not instantiate independent Dio clients.

Shared networking infrastructure owns concerns such as:

- base URL
- authentication
- headers
- timeout
- common interceptors
- logging configuration
- network error mapping

See:

`api_convention.md`

---

## 13. Authentication

Authentication uses Laravel Sanctum Bearer Tokens.

Flow:

Login
  ↓
POST Authentication API
  ↓
Laravel
  ↓
Sanctum Token
  ↓
Secure Storage
  ↓
Dio Auth Interceptor
  ↓
Authenticated Requests

Repositories and providers should not manually attach Bearer tokens.

---

## 14. Routing

GoRouter is used for navigation.

Routes are managed using the established centralized application routing
strategy.

Navigation belongs to the presentation layer.

Repositories and data sources must not perform navigation.

---

## 15. Environment

Smart Tani supports:

- development
- staging
- production

Environment configuration must control environment-specific values such
as API base URL.

Feature source code must remain environment-independent.

---

## 16. AI Boundary

Flutter never stores external AI provider credentials.

Expected Plant Scan flow:

Flutter
  ↓
Image Upload
  ↓
Laravel
  ↓
Store Scan
  ↓
Processing
  ↓
Queue / AI Service
  ↓
Update Scan
  ↓
Flutter Polling
  ↓
Result

This protects credentials and keeps AI provider integration under
backend control.

---

## 17. Assistant Boundary

Flutter sends user interaction to Laravel.

Laravel is responsible for enriching AI requests with Smart Tani
context such as:

- farm
- planting season
- weather
- plant age
- growth stage

Flutter should not reconstruct backend AI context or prompts.

---

## 18. Weather Boundary

Weather provider integration belongs to Laravel.

Expected:

Flutter
  ↓
Smart Tani API
  ↓
Weather Service
  ↓
External Weather Provider

Not:

Flutter
  ↓
External Weather Provider

---

## 19. Architecture Principle

Use the simplest architecture that maintains:

- clear responsibilities
- predictable dependency flow
- testability
- feature isolation
- maintainability

Architecture should grow when real complexity appears, not in
anticipation of hypothetical future complexity.