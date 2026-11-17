# Smart Tani Mobile — API Convention

## 1. Purpose

Defines how Flutter communicates with the Smart Tani Laravel API.

---

## 2. API Boundary

Flutter communicates with:

Smart Tani Laravel REST API

Flutter does not directly communicate with:

- MySQL
- AI providers
- weather providers
- private backend services

---

## 3. API Version

Current API convention:

/api/v1

Example:

GET /api/v1/farms

API versioning must remain explicit.

---

## 4. Request Flow

UI
↓
Provider
↓
Repository
↓
Remote Data Source
↓
Shared Dio
↓
Laravel

Do not bypass this flow without documented justification.

---

## 5. Dio

Dio is centrally configured.

Feature code must not instantiate:

Dio()

The shared client owns common configuration.

---

## 6. Authentication

Laravel Sanctum Bearer Token is used.

Token lifecycle:

Login
↓
Receive Token
↓
Secure Storage
↓
AuthInterceptor
↓
Authorization: Bearer <token>

Do not manually add the Authorization header in each repository.

---

## 7. Base URL

Base URL comes from environment configuration.

Supported environments:

development
staging
production

Never hardcode a base URL inside a feature.

---

## 8. Endpoint Ownership

Endpoint strings should follow the existing centralized or feature-owned
project convention.

Do not put raw endpoint strings in Pages or Widgets.

---

## 9. Request Models

Use focused request objects when payload complexity warrants them.

Example:

CreateFarmRequest

Do not construct large request maps directly inside UI.

---

## 10. Response Models

Deserialize API responses into typed models.

Example:

JSON
↓
FarmModel

Do not pass raw Dio Response objects to UI.

---

## 11. Nullability

Preserve API nullability.

Do not automatically convert:

null → ""
null → 0
null → false

unless the product/API contract explicitly defines that meaning.

---

## 12. HTTP Errors

Infrastructure errors should be mapped before reaching presentation.

Conceptual flow:

DioException
↓
Error Mapper
↓
Application Error
↓
Provider State
↓
UI

---

## 13. Validation Errors

Backend validation remains authoritative.

When Laravel provides field validation errors, preserve useful
information according to the project's error model.

Do not expose raw backend JSON to users.

---

## 14. Multipart

File/image uploads use Dio multipart support.

The API contract determines:

- field name
- content type
- additional payload
- response model

---

## 15. Pagination

Do not assume all list endpoints are paginated.

When an endpoint is paginated, preserve backend pagination semantics.

Typical presentation state may include:

items
currentPage
hasMore
isLoadingMore

---

## 16. Dates

Use the date/time representation defined by the API contract.

Do not send UI-formatted dates to backend APIs.

Do not assume timezone behavior when it is not defined.

---

## 17. Logging

Never log:

- password
- token
- Authorization header
- API secret
- AI provider credential

Network logging must respect environment configuration.

---

## 18. External Providers

External service credentials belong to Laravel.

AI:

Flutter → Laravel → AI Provider

Weather:

Flutter → Laravel → Weather Provider

---

## 19. Final Rule

Flutter understands the public Smart Tani API contract.

Flutter should not depend on private backend implementation details.