# Smart Tani Mobile — State Management

## 1. Purpose

Smart Tani uses Riverpod for application and feature state management.

---

## 2. State Ownership

State should have a clear owner.

### Local UI State

Examples:

- password visibility
- expansion
- temporary tab selection
- animation state

May remain inside the widget.

### Feature State

Examples:

- farms
- activities
- planting season
- scan result
- harvest history

Owned by Riverpod feature providers.

### Application State

Examples:

- authentication session
- application environment

Owned by application-level providers/services.

---

## 3. Provider Flow

UI
↓
Riverpod Provider
↓
Repository
↓
Data Source

Provider coordinates state.

It does not implement raw HTTP communication.

---

## 4. Async State

Network-driven state should represent relevant lifecycle states:

- loading
- success
- empty
- error

Additional states may be introduced when the UI needs them.

Examples:

- submitting
- refreshing
- loading more

Avoid excessive boolean state.

---

## 5. watch

Use `ref.watch` for reactive dependencies.

UI that renders provider state should generally watch that state.

---

## 6. read

Use `ref.read` for imperative operations.

Example:

ref.read(farmProvider.notifier).refresh();

---

## 7. listen

Use `ref.listen` for presentation side effects triggered by state
changes.

Examples:

- snackbar
- dialog
- redirect
- close form after success

Do not use listeners for normal rendering.

---

## 8. Dependency Injection

Riverpod may provide shared dependencies.

Conceptual graph:

Environment
↓
Dio
↓
RemoteDataSource
↓
Repository
↓
Feature Provider
↓
UI

Do not construct dependencies repeatedly inside provider methods.

---

## 9. Immutability

Feature state should remain predictable and preferably immutable.

Avoid directly mutating shared collections.

---

## 10. Refresh

Refresh should reuse feature data-loading logic.

Pull-to-refresh should not duplicate API logic inside a Page.

---

## 11. Invalidation

Invalidate only state that becomes stale.

Example:

Create Farm
↓
Farm List stale
↓
Refresh / invalidate Farm List

Do not invalidate unrelated features.

---

## 12. Empty State

Empty data is not an error.

Example:

farms = []

should allow presentation to show:

"Belum ada lahan"

rather than an API failure state.

---

## 13. Parameterized State

Use parameterized/family providers when state naturally depends on an
identifier.

Example:

farmDetailProvider(farmId)

Avoid unnecessary global `selectedFarm` state.

---

## 14. Lifecycle

Provider lifetime should match state ownership.

Temporary detail/form state may be disposable.

Application session state generally has a longer lifecycle.

Do not use keepAlive automatically.

---

## 15. Plant Scan

Plant Scan requires asynchronous processing.

Conceptually:

idle
↓
uploading
↓
processing
↓
completed

or:

error

The state layer should own polling orchestration rather than the Page.

Polling must stop when the operation reaches a terminal state or the
responsible state owner is disposed.

---

## 16. Assistant

Assistant state may include:

- conversation identifier
- messages
- sending state
- error state

Backend remains responsible for AI context construction.

---

## 17. Final Rule

Riverpod owns feature state and orchestration.

Repository owns feature data operations.

Data Source owns API communication.

UI owns rendering and user interaction.