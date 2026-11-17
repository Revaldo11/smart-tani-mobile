# Smart Tani Mobile — Agent Engineering Guidelines

## 1. Purpose

This document defines the engineering rules that AI coding agents MUST
follow when working on the Smart Tani Flutter application.

These rules exist to keep implementation:

- consistent
- maintainable
- testable
- scalable
- aligned with the existing Smart Tani architecture
- free from unnecessary architectural complexity

The agent MUST follow existing project conventions before applying
generic Flutter conventions.

---

# 2. Source of Truth

When implementing or modifying Smart Tani, use the following priority:

1. Existing Smart Tani source code
2. AGENTS.md
3. Architecture documentation under `docs/architecture`
4. Smart Tani Product Requirements Document (PRD)
5. Smart Tani API contract
6. Smart Tani database / ERD documentation
7. Task-specific user instructions
8. General Flutter best practices

If an implementation already exists for a similar feature, use that
implementation as the primary reference.

Do NOT introduce a different architecture or pattern only because it is
considered a common Flutter best practice.

If project documentation conflicts with the current implementation,
report the conflict before making a structural change.

---

# 3. Technology Stack

Smart Tani Mobile uses:

- Flutter
- Dart
- Provider
- Dio
- GoRouter
- Freezed
- json_serializable
- flutter_secure_storage
- shared_preferences
- cached_network_image
- image_picker
- firebase_messaging

Backend communication:

Flutter
→ HTTPS REST API
→ Laravel
→ MySQL / External Services

Flutter MUST NOT communicate directly with:

- MySQL
- AI provider
- Weather provider
- private backend infrastructure

All external integrations MUST go through the Laravel backend unless
explicitly documented otherwise.

---

# 4. Architecture

Smart Tani uses:

Feature-First Architecture

Default dependency flow:

Presentation
↓
Provider / Notifier
↓
Repository
↓
Remote Data Source
↓
Shared Dio Client
↓
Laravel REST API

Response flow:

Laravel API
↓
JSON
↓
Remote Data Source
↓
Repository
↓
Model / State
↓
Provider
↓
UI

Dependencies MUST flow inward according to this structure.

The UI MUST NOT bypass layers.

---

# 5. Project Structure

The expected top-level Flutter structure is:

lib/
├── main.dart
├── app/
├── core/
└── features/

## app/

Application-level configuration.

Expected responsibilities:

- application bootstrap
- routing
- environment configuration
- root application configuration

Example:

app/
├── app.dart
├── bootstrap.dart
├── router.dart
└── environment.dart

## core/

Shared infrastructure used by multiple features.

Example:

core/
├── constants/
├── error/
├── network/
├── storage/
├── theme/
├── utils/
└── widgets/

Do NOT place feature-specific business logic inside `core`.

## features/

Contains Smart Tani business features.

Expected MVP features:

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

Weather may remain supporting infrastructure/data for relevant features
unless it develops an independent UI/user journey.

---

# 6. Feature Architecture

Smart Tani MUST NOT apply full Clean Architecture to every feature.

Architecture complexity must match feature complexity.

## Standard Feature

Use for normal CRUD and relatively simple features.

Example:

features/farm/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── providers/
    ├── pages/
    └── widgets/

Typical flow:

Page
→ Provider
→ Repository
→ RemoteDataSource
→ Dio

## Complex Feature

A `domain` layer MAY be introduced when the feature contains substantial
business logic or workflows that justify the additional abstraction.

Example:

features/plant_scan/
├── data/
├── domain/
└── presentation/

Possible domain contents:

domain/
├── entities/
├── repositories/
└── usecases/

Do NOT create a domain layer simply for architectural symmetry.

---

# 7. Anti-Overengineering Rule

Before creating:

- repository interfaces
- repository implementations
- use cases
- entities
- DTOs
- mappers
- services
- abstractions

the agent MUST determine whether the abstraction solves an actual
project requirement.

Do NOT create:

IFarmRepository
FarmRepositoryImpl
GetFarmUseCase
FarmEntity
FarmDto
FarmMapper

for a simple CRUD feature unless the existing project architecture or
feature complexity requires them.

Prefer the smallest architecture that preserves:

- clear responsibilities
- testability
- maintainability
- dependency boundaries

---

# 8. State Management

Provider is the default state management solution.

Provider / Notifier responsibilities include:

- fetching data
- mutation orchestration
- loading state
- success state
- empty state
- error state
- refreshing state when necessary

Pages should primarily:

- observe state
- render UI
- dispatch user actions

Business state MUST NOT be managed using `setState`.

`setState` MAY be used for ephemeral local UI state such as:

- password visibility
- local tab selection
- temporary animation state
- simple UI toggles

Do not introduce another state management package without explicit
approval.

---

# 9. Networking

All API communication MUST use the shared Dio configuration.

Never instantiate:

Dio()

inside:

- pages
- widgets
- providers
- repositories
- feature data sources

Use the centrally configured Dio instance.

Expected flow:

dioProvider
↓
Repository / RemoteDataSource
↓
API

Common concerns such as authentication, logging, timeout, and common
headers belong in shared network infrastructure.

---

# 10. Authentication

Smart Tani uses Laravel Sanctum Bearer Token authentication.

Expected flow:

Login
↓
Laravel API
↓
Sanctum Token
↓
flutter_secure_storage
↓
Dio Auth Interceptor

Rules:

- Tokens MUST be stored in secure storage.
- Tokens MUST NOT be stored in plain shared preferences.
- Authorization headers MUST be attached by the Dio interceptor.
- Repositories MUST NOT manually attach Bearer tokens.
- Tokens MUST NOT be hardcoded.
- Secrets MUST NOT be committed into source control.

Logout should:

1. request backend logout/revocation when required
2. clear local authentication credentials
3. invalidate authentication state
4. return the user to the authentication flow

---

# 11. Models

API models should use the project's established serialization pattern.

Preferred:

- Freezed
- json_serializable

Example:

farm_model.dart

Generated files may include:

farm_model.freezed.dart
farm_model.g.dart

Do NOT manually edit generated files.

API field mapping MUST reflect the API contract.

Do NOT silently invent fields that are not defined by the backend
contract.

---

# 12. Routing

Application routing uses GoRouter.

Route definitions should remain centralized according to the existing
router implementation.

Features MUST NOT introduce independent navigation frameworks.

Prefer named or typed route patterns when already used by the project.

Navigation logic should not contain business logic.

---

# 13. Environment

Smart Tani supports:

- development (`dev`)
- staging (`stg`)
- production (`prod`)

Environment-specific values include:

- API base URL
- logging configuration
- integration configuration when required

Never hardcode environment-specific URLs inside features.

Never hardcode:

- API secrets
- access tokens
- private keys
- provider credentials

Use the project's environment configuration.

---

# 14. Error Handling

Every asynchronous user-facing feature MUST consider:

- loading
- success
- empty
- error

Raw infrastructure exceptions such as `DioException` MUST NOT be shown
directly to users.

Infrastructure errors should be converted into application-friendly
errors.

Example:

DioException
↓
Error Mapper
↓
App Failure / App Exception
↓
Provider State
↓
User-friendly UI

Do not silently swallow exceptions.

---

# 15. UI Responsibilities

Pages should remain thin.

A page should mainly:

- compose widgets
- observe Provider state
- trigger provider actions
- handle navigation

Reusable global components belong in:

core/widgets/

Feature-specific components belong in:

features/<feature>/presentation/widgets/

Do NOT move a widget into `core` merely because it is extracted from a
page.

A component belongs in `core` only when it is genuinely reusable across
multiple features.

---

# 16. Smart Tani Domain

The MVP domain includes:

- User
- Farm
- Planting Season
- Activity
- Plant Scan
- Recommendation
- Harvest
- Weather Snapshot
- Assistant Conversation
- Assistant Message
- Notification
- User Device

Agents MUST inspect the current PRD, API contract, and database
documentation before introducing new persistent domain entities.

Do NOT duplicate data relationships unnecessarily.

For example, when a child resource is already scoped through
`plantingSeasonId`, do not automatically introduce `farmId` unless the
API contract requires it.

---

# 17. API Versioning

Smart Tani API uses versioned endpoints.

Expected prefix:

/api/v1

Endpoints MUST be centralized according to the project's network
convention.

Do not scatter endpoint strings throughout UI and providers.

---

# 18. Naming Convention

Files and directories:

snake_case

Examples:

farm_page.dart
farm_provider.dart
farm_repository.dart
farm_remote_data_source.dart

Classes:

PascalCase

Examples:

FarmPage
FarmRepository
FarmRemoteDataSource
FarmNotifier

Variables and methods:

camelCase

Examples:

activeFarm
fetchFarms()
createFarm()

Boolean variables should communicate intent:

isLoading
isAuthenticated
hasActiveSeason
canSubmit

Avoid vague names such as:

data
temp
value
item2
manager
helper

when a domain-specific name is available.

---

# 19. Agent Workflow

Before modifying code, the agent MUST:

1. Understand the requested requirement.
2. Inspect the relevant existing feature.
3. Search for similar implementations.
4. Inspect shared infrastructure that may already solve the problem.
5. Identify the appropriate architecture level.
6. Check relevant PRD/API/domain documentation.
7. Determine which existing files should be reused.

Only then should implementation begin.

---

# 20. New Feature Workflow

When asked to implement a feature:

1. Identify the Smart Tani domain.
2. Check whether the feature already exists.
3. Inspect a similar existing feature.
4. Determine whether it is simple or complex.
5. Define required API/model/state.
6. Implement data layer.
7. Implement Provider state.
8. Implement presentation.
9. Handle loading/empty/error/success states.
10. Add tests where appropriate.
11. Format and analyze the implementation.

Do NOT create the entire architecture before understanding the feature.

---

# 21. Refactoring Rules

When asked to refactor:

Preserve behavior unless behavior changes are explicitly requested.

Prioritize:

1. duplicate logic
2. unclear responsibilities
3. large methods/classes
4. repeated API handling
5. state inconsistencies
6. unnecessary coupling
7. naming problems

Do NOT perform unrelated architectural migrations during a focused
refactor.

Avoid "refactoring" that only increases the number of files and
abstractions without reducing complexity.

---

# 22. Dependency Rules

Before adding a dependency:

1. Verify the existing project does not already solve the requirement.
2. Determine whether Flutter/Dart SDK functionality is sufficient.
3. Evaluate whether the package is necessary.
4. Explain why it is needed when introducing it.

Do NOT add packages for trivial utilities that can be implemented safely
with existing dependencies.

---

# 23. Code Generation

When modifying Freezed/json_serializable models, run the project's
established code-generation command.

Generated files MUST NOT be manually edited.

Generated files should follow the repository's existing source-control
policy.

---

# 24. Validation

Before considering an implementation complete, run when available:

dart format .
flutter analyze
flutter test

For generated models, also run the appropriate build_runner command.

The agent MUST NOT claim that validation passed unless the command was
actually executed successfully.

If validation cannot be executed, explicitly report it.

---

# 25. Completion Report

After implementing a task, report:

## Changed
Files created or modified.

## Architecture
Important implementation decisions.

## Validation
Commands executed and their results.

## Notes
Remaining limitations, API dependencies, TODOs, or assumptions.

Keep the report concise.

---

# 26. Prohibited Patterns

Unless explicitly justified by existing project code, avoid:

- API calls directly from Widgets
- API calls directly from Pages
- direct `Dio()` construction inside features
- business logic inside UI widgets
- hardcoded API base URLs
- hardcoded tokens or secrets
- storing authentication tokens in shared_preferences
- introducing another state management library
- duplicated network clients
- unnecessary service locator patterns
- unnecessary singleton classes
- full Clean Architecture for trivial features
- generic "manager" or "helper" classes with mixed responsibilities
- silently changing API contracts
- silently changing database/domain assumptions

---

# 27. Primary Engineering Principle

Smart Tani favors:

Consistency over novelty.

Clarity over abstraction.

Feature isolation over global coupling.

Explicit data flow over hidden behavior.

Maintainability over theoretical architecture purity.

Existing project conventions over generic examples.

Architecture should solve current project complexity without creating
unnecessary complexity for hypothetical future requirements.

# Figma and Design Source

When a Figma design is provided, the agent MUST treat it as the primary
source of truth for presentation and interaction design.

Figma defines:

- layout
- component hierarchy
- spacing
- typography
- colors
- icons
- visual states
- responsive behavior when documented
- interaction behavior when documented
- component variants
- design tokens

Figma does NOT override:

- PRD business rules
- API contracts
- database relationships
- authentication rules
- application architecture

Before implementing a Figma screen, the agent MUST:

1. Inspect the provided Figma frame/component.
2. Identify reusable components and design tokens.
3. Inspect existing Flutter implementation for similar components.
4. Reuse existing Smart Tani components when they match the design.
5. Identify missing components.
6. Map UI actions to the appropriate Provider actions.
7. Map displayed data to the appropriate API/domain models.
8. Implement the screen using existing architecture.
9. Compare the implementation against the Figma design.

Do NOT redesign or "improve" the provided design unless explicitly
requested.

Do NOT invent interaction behavior that is not visible or documented
when that behavior materially affects the feature.

If Figma conflicts with the PRD or API contract, report the conflict
instead of silently changing product behavior.