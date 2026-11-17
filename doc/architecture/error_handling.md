# Smart Tani Mobile — Error Handling

## 1. Purpose

Defines how errors move through the Smart Tani Flutter application.

The objective is to:

- avoid leaking infrastructure errors into UI
- provide predictable state
- provide understandable user feedback
- centralize common network error handling

---

## 2. Error Flow

Preferred flow:

Dio / Infrastructure Error
        ↓
Error Mapping
        ↓
Application Error
        ↓
Repository
        ↓
Provider State
        ↓
Presentation

Raw infrastructure exceptions should not be rendered directly.

---

## 3. Error Categories

The application should distinguish errors only when doing so affects
behavior or user experience.

Potential categories include:

- network unavailable
- timeout
- unauthorized
- validation
- not found
- server error
- unknown error

The exact mapping must follow the actual Smart Tani backend contract.

Do not invent backend error semantics.

---

## 4. Network Errors

Network-specific exceptions belong to network/error infrastructure.

Feature Pages should not interpret `DioException` directly.

Avoid:

if (error is DioException) ...

inside UI.

---

## 5. Authentication Errors

Authentication/session errors should be handled centrally when
possible.

Conceptual flow:

HTTP 401
↓
Network/Auth Infrastructure
↓
Authentication State
↓
Authentication Flow

Do not independently implement logout behavior in every feature.

---

## 6. Validation Errors

Backend validation is authoritative.

Field-level validation information may be mapped into form state when
supported by the API contract.

Raw Laravel validation JSON should not be shown directly to users.

---

## 7. User-Facing Messages

Messages should be:

- concise
- understandable
- actionable where possible
- appropriate for Smart Tani users

Avoid technical messages such as:

DioException: connection timeout

Prefer user-oriented wording such as:

"Koneksi bermasalah. Periksa internet Anda dan coba lagi."

Final wording should follow the approved Smart Tani UX/content
guidelines.

---

## 8. Empty Is Not Error

A successful empty response is not automatically an error.

Example:

GET farms
→ []

represents an empty state.

The UI may show:

"Belum ada lahan"

with an appropriate action.

---

## 9. Retry

Provide retry behavior when retrying can reasonably recover the
operation.

Example:

network failure
↓
Error State
↓
Retry
↓
Loading
↓
Success / Error

Do not automatically retry mutations when doing so risks duplicate
records unless idempotency behavior is known.

---

## 10. Existing Data During Refresh

When refreshing existing data fails, consider preserving existing
content while communicating the refresh failure.

Do not automatically discard valid previously loaded data.

Behavior depends on the feature UX.

---

## 11. Mutation Errors

For create/update/archive operations:

- stop submission loading
- preserve user input when appropriate
- expose meaningful failure state
- avoid duplicate submission
- allow safe retry

Do not clear forms automatically when submission fails.

---

## 12. Plant Scan Errors

Plant Scan can fail at different stages:

- image selection
- upload
- backend processing
- polling
- result retrieval

The UI should distinguish meaningful recoverable states when required.

Polling must stop on terminal failure.

Do not expose AI-provider internals directly to users.

---

## 13. Logging

Technical errors may be logged using the project's logging
infrastructure.

Never log sensitive credentials.

User-facing error messages and technical logs serve different purposes.

---

## 14. Unknown Error

Unexpected failures should have a safe fallback.

Example:

"Terjadi kesalahan. Silakan coba lagi."

The technical cause may be logged separately.

---

## 15. Error Ownership

Data/network layer:

- detect infrastructure failure
- map low-level exceptions

Repository:

- expose meaningful operation failure

Provider:

- represent failure in feature state

Presentation:

- display appropriate feedback
- offer retry/action when relevant

---

## 16. API Contract Dependency

The final Smart Tani error model must be updated when the backend API
error contract is finalized.

Required future documentation should define:

- common error response
- validation response
- authentication error
- not-found response
- server error response
- stable error codes if provided

Until that contract exists, do not invent backend-specific fields.

---

## 17. Final Rule

Technical errors belong below presentation.

User-facing feedback belongs in presentation.

Do not make users interpret backend or networking implementation
details.