# Smart Tani — Integrate API Command

## Purpose

Use this command when integrating a Laravel REST API endpoint into the
Smart Tani Flutter application.

This command applies to:

- GET
- POST
- PUT/PATCH
- archive/delete operations
- multipart upload
- pagination
- polling
- authenticated endpoints

Read first:

1. `AGENTS.md`
2. `.ai/rules/architecture.md`
3. `.ai/rules/flutter.md`
4. `.ai/rules/provider.md`
5. existing network implementation
6. relevant API contract

Do not implement an endpoint from assumptions.

---

# 1. Inspect the API Contract

Before coding identify:

- HTTP method
- endpoint
- authentication requirement
- path parameters
- query parameters
- request body
- request content type
- response structure
- nullable fields
- error structure
- pagination structure when applicable

Example:

GET /api/v1/farms

Do not infer undocumented fields from database columns.

The database schema is NOT automatically the API response schema.

---

# 2. Inspect Existing Network Infrastructure

Inspect:

core/network/

and related infrastructure.

Identify existing:

- Dio provider/client
- base URL configuration
- auth interceptor
- logging interceptor
- timeout configuration
- response wrapper
- error mapper
- API exception types

Reuse existing infrastructure.

Do NOT create another Dio client.

---

# 3. Inspect Similar Existing Endpoint

Before implementation find the closest existing API integration.

Compare:

- request construction
- response extraction
- model parsing
- exception handling
- repository style
- provider style

Follow established conventions.

---

# 4. Determine Integration Location

Default flow:

Provider
↓
Repository
↓
Remote Data Source
↓
Dio
↓
Laravel

Do not put HTTP code into:

- Page
- Widget
- Provider

---

# 5. Endpoint Definition

Follow existing project convention for endpoint definitions.

If centralized endpoints are used, add the endpoint there.

Example concept:

ApiEndpoints.farms

Avoid repeating:

'/api/v1/farms'

throughout multiple classes.

Do not introduce endpoint abstraction if the existing project uses a
different established pattern.

---

# 6. Authentication

Authentication uses Laravel Sanctum Bearer Token.

Authorization should be handled by the shared Dio AuthInterceptor.

Do NOT:

1. read secure storage in every repository
2. manually construct Bearer headers
3. pass token through Page → Provider → Repository

Expected:

Feature
↓
Shared Dio
↓
AuthInterceptor
↓
Laravel

---

# 7. GET Integration

For GET endpoints determine:

- path parameters
- query parameters
- response collection/object
- pagination
- empty behavior

Example:

RemoteDataSource:

getFarms()

Repository:

getFarms()

Provider:

loadFarms()

UI:

watch farm state

Do not return raw Dio Response to presentation.

---

# 8. POST Integration

For POST determine:

- required fields
- optional fields
- validation
- JSON/multipart
- returned resource
- success semantics

Prefer a request model when payload complexity justifies it.

Example:

CreateFarmRequest

Do not construct large API maps inside widgets.

Avoid:

onPressed: () {
  repository.createFarm({
    'name': controller.text,
    ...
  });
}

Prefer:

final request = CreateFarmRequest(...);

ref
  .read(farmProvider.notifier)
  .createFarm(request);

---

# 9. PUT / PATCH Integration

Determine backend semantics.

Do not assume PUT and PATCH are interchangeable.

Map only fields accepted by the API contract.

After successful mutation, update or invalidate the relevant local
state.

---

# 10. Archive / Delete Integration

Check product and API semantics before implementing deletion.

Do not assume every resource supports hard delete.

For Smart Tani, preserve historical data according to documented
business rules.

Use archive/soft-delete flows when required by product/backend design.

---

# 11. Multipart Integration

For image/file uploads determine:

- field name
- MIME/content type
- filename handling
- additional fields
- upload timeout
- response format

Use Dio multipart support according to existing project conventions.

Do not manually build multipart protocol strings.

---

# 12. Response Mapping

Do not expose raw JSON maps throughout the application.

Map response data into the established model representation.

Example:

JSON
↓
FarmModel.fromJson(...)
↓
Repository
↓
Provider

Respect nullable fields.

Do not force defaults that change backend meaning unless product rules
explicitly define them.

---

# 13. API Wrapper

If Laravel responses use a common wrapper such as:

{
  "success": true,
  "message": "...",
  "data": ...
}

reuse the project's common response parser if one exists.

Do not create a new wrapper per feature.

Do not assume this exact response structure unless the actual Smart
Tani API contract defines it.

---

# 14. Error Mapping

Network errors should be normalized by shared infrastructure.

Potential categories may include:

- no connection
- timeout
- unauthorized
- validation error
- not found
- server error
- unknown error

Follow actual backend/error contracts.

Do not map status codes differently in every feature.

---

# 15. HTTP 401

Authentication expiration should be handled centrally where possible.

Expected:

Laravel 401
↓
Dio/Auth infrastructure
↓
Session handling
↓
Authentication state

Do not implement independent logout behavior in every feature
repository.

---

# 16. HTTP 422

Laravel validation errors may contain field-level validation details.

Preserve useful validation information when the existing API/error
contract supports it.

Do not show raw JSON error payloads directly to users.

---

# 17. Pagination

If the endpoint is paginated, identify:

- page parameter
- page size
- metadata
- last page / has more semantics

Provider may maintain:

items
currentPage
hasMore
isLoadingMore

Do not invent pagination behavior when the backend endpoint is not
paginated.

---

# 18. Query Parameters

Only send documented query parameters.

Do not send empty or null parameters unnecessarily if the backend
contract does not require them.

Keep query construction in data/network layers.

---

# 19. Date and Time

Determine API date/time format from the contract.

Do not assume:

- local timezone
- UTC
- ISO 8601
- Unix timestamp

unless documented or established by existing implementation.

Avoid UI-formatted dates in API payloads.

---

# 20. Numeric Data

Preserve numeric meaning.

Examples:

- hectares
- kilograms
- prices
- confidence values
- humidity
- rainfall

Do not format numeric API values as presentation strings inside data
models.

Example:

API/domain:
1250000

UI:
Rp 1.250.000

---

# 21. Enum / Status

When backend sends statuses such as:

planned
active
harvested
cancelled

map them according to existing project conventions.

Do not silently treat unknown backend values as a valid known status.

Prefer safe fallback/error behavior.

---

# 22. Nullable Fields

API nullable fields must remain intentionally nullable where applicable.

Do not automatically convert:

null

into:

''
0
false

unless product semantics explicitly define that behavior.

Null and zero may represent different meanings.

---

# 23. Provider Integration

After repository integration, connect it through Riverpod.

Example:

FarmPage
↓
farmProvider
↓
FarmRepository
↓
FarmRemoteDataSource

Provider owns UI-facing async state.

Do not expose Dio response objects to Provider/UI.

---

# 24. Loading State

Distinguish when useful:

- initial loading
- refresh
- submitting
- loading more

Do not introduce unnecessary loading flags.

Only model distinctions the UI needs.

---

# 25. Empty State

Successful API response with no resources is generally an empty state,
not a network error.

Example:

GET farms
→ []

UI:
"Belum ada lahan"

---

# 26. Mutation Success

After POST/PATCH/archive:

determine what becomes stale.

Possible strategies:

- update state locally
- invalidate list provider
- refetch affected resource

Choose the simplest strategy consistent with the existing project.

---

# 27. Polling

Polling is allowed when required by backend workflow.

For polling integrations define:

- polling interval
- terminal success state
- terminal error state
- maximum/retry behavior if specified
- lifecycle cancellation

Never create uncontrolled infinite polling.

Polling belongs in state/data orchestration, not Widget build methods.

---

# 28. Plant Scan Integration

Smart Tani Plant Scan follows the conceptual backend-controlled flow:

Flutter
↓
POST image
↓
Laravel stores scan
↓
processing
↓
Backend AI processing
↓
Flutter polls scan result
↓
completed / failed

Flutter MUST NOT call the external AI provider directly.

Flutter MUST NOT store AI provider credentials.

Follow the actual endpoint contract when implementing this flow.

---

# 29. Weather Integration

Flutter should consume Smart Tani backend weather data.

Expected:

Flutter
↓
Laravel
↓
Weather Provider

Do not integrate third-party weather credentials directly into Flutter
unless architecture is explicitly changed.

---

# 30. Assistant Integration

Expected:

Flutter
↓
message + conversation identifier
↓
Laravel
↓
load Smart Tani context
↓
LLM
↓
response

Flutter should not construct backend AI system context containing the
entire farm domain.

Laravel owns contextual AI orchestration.

---

# 31. Logging

Network logging must follow project logging configuration.

Never log sensitive values such as:

- Authorization headers
- Sanctum tokens
- passwords
- private keys
- AI provider credentials

Production logging should respect environment configuration.

---

# 32. Environment

API Base URL must come from environment configuration.

Supported environments:

dev
stg
prod

Feature integrations MUST work without changing source code when
switching environments.

---

# 33. Testing

When integrating an endpoint, test meaningful behavior.

Possible cases:

- success
- empty
- validation failure
- network/server failure
- unauthorized when relevant
- model parsing
- provider state transitions

Do not test Dio internals.

Test Smart Tani behavior.

---

# 34. Contract Verification

Before completion compare implementation with the provided API contract.

Check:

- method
- endpoint
- parameters
- body
- response
- nullable fields
- status values
- errors

Do not declare integration complete solely because code compiles.

---

# 35. Format and Analyze

Run:

dart format .

flutter analyze

When model generation changed, run the project's build_runner command.

Run relevant tests.

---

# 36. Final Report

Return:

## Endpoint

Example:

POST /api/v1/farms

## Flow

Page
→ Provider
→ Repository
→ DataSource
→ Dio
→ API

## Files Changed

List actual files.

## Error Handling

Describe how errors are mapped.

## State Update

Describe refresh/invalidation behavior.

## Validation

Report actual commands executed.

## Blockers

Mention missing backend contracts or unresolved requirements.

---

# 37. Prohibited API Patterns

Never:

Page → Dio

Widget → Dio

Provider → Dio

Feature → new Dio()

Feature → manually read auth token

Feature → hardcoded base URL

Flutter → MySQL

Flutter → external AI provider

Flutter → third-party Weather API

unless the architecture is explicitly changed.

---

# 38. Final API Principle

Flutter should know the Smart Tani API contract.

Flutter should NOT know backend infrastructure details.

Laravel owns:

- database access
- external providers
- protected credentials
- primary business integration

Flutter owns:

- request intent
- presentation state
- user interaction
- rendering API results