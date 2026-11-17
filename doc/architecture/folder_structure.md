# Smart Tani Mobile — Folder Structure

## 1. Purpose

This document defines the standard Flutter folder structure for
Smart Tani Mobile.

---

## 2. Root Flutter Structure

lib/
├── main.dart
├── app/
├── core/
└── features/

---

## 3. App

app/
├── app.dart
├── bootstrap.dart
├── router.dart
└── environment.dart

### app.dart

Root Flutter application.

Responsibilities may include:

- MaterialApp configuration
- application theme
- GoRouter integration

### bootstrap.dart

Application initialization.

Examples:

- Flutter binding initialization
- environment setup
- Firebase initialization
- application-level startup dependencies

### router.dart

Application routing configuration.

### environment.dart

Environment configuration and environment-specific values.

---

## 4. Core

core/
├── constants/
├── error/
├── network/
├── storage/
├── theme/
├── utils/
└── widgets/

---

## 5. Network

Recommended structure:

core/network/
├── api_client.dart
├── api_endpoints.dart
├── dio_provider.dart
└── interceptors/
    ├── auth_interceptor.dart
    └── logging_interceptor.dart

Exact filenames may follow the existing implementation.

Do not duplicate network clients per feature.

---

## 6. Error

Example:

core/error/
├── app_exception.dart
├── app_failure.dart
└── error_mapper.dart

Use only abstractions required by the actual project.

Do not create multiple overlapping error abstractions unnecessarily.

---

## 7. Storage

Example:

core/storage/
└── secure_storage.dart

Authentication credentials must use secure storage.

Shared preferences may be used for appropriate non-sensitive local
preferences.

---

## 8. Shared Widgets

Example:

core/widgets/
├── app_button.dart
├── app_text_field.dart
├── app_loading_indicator.dart
└── app_error_view.dart

Only genuinely cross-feature components belong here.

---

## 9. Features

MVP:

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

---

## 10. Standard Feature

Default:

feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── providers/
    ├── pages/
    └── widgets/

Use this structure for straightforward features.

---

## 11. Complex Feature

Optional:

feature/
├── data/
├── domain/
└── presentation/

Possible domain structure:

domain/
├── entities/
├── repositories/
└── usecases/

Use only when complexity justifies it.

---

## 12. Farm Example

farm/
├── data/
│   ├── datasources/
│   │   └── farm_remote_data_source.dart
│   ├── models/
│   │   ├── farm_model.dart
│   │   └── create_farm_request.dart
│   └── repositories/
│       └── farm_repository.dart
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

---

## 13. Placement Decision

When creating code, ask:

Is this application configuration?
→ app/

Is this shared infrastructure?
→ core/

Does this belong to one business feature?
→ features/<feature>/

Is this feature-specific UI?
→ features/<feature>/presentation/widgets/

Is this shared by several real features?
→ consider core/

Do not move code to `core` merely because it might theoretically be
reused later.

---

## 14. Naming

Directories and files:

snake_case

Examples:

planting_season/
plant_scan/
farm_detail_page.dart
farm_remote_data_source.dart

Classes:

PascalCase

Methods/variables:

camelCase

---

## 15. Generated Files

Generated files stay beside their source model according to Dart
generation conventions.

Example:

farm_model.dart
farm_model.freezed.dart
farm_model.g.dart

Never manually edit generated files.

---

## 16. Empty Folders

Do not create folders merely to satisfy an architecture diagram.

Create a folder when the feature actually contains that responsibility.

Example:

Do not create:

domain/usecases/

for a simple feature when there are no use cases requiring that layer.

---

## 17. Final Rule

Folder structure communicates ownership.

The question is not:

"Where can this file fit?"

The question is:

"Which part of Smart Tani owns this responsibility?"