# Smart Tani — Implement Figma Command

## Purpose

Use this command when implementing Smart Tani Flutter UI from a
provided Figma design, frame, component, or prototype.

The objective is to reproduce the approved design accurately while
preserving Smart Tani architecture and existing project conventions.

Read first:

1. `AGENTS.md`
2. `.ai/rules/architecture.md`
3. `.ai/rules/flutter.md`
4. `.ai/rules/provider.md`
5. relevant PRD
6. relevant API contract
7. existing Flutter implementation

---

# 1. Inspect Figma Before Coding

Do NOT immediately generate Flutter code.

First inspect the provided Figma design.

Identify:

- page/frame name
- page hierarchy
- components
- component variants
- typography
- colors
- spacing
- radius
- icons
- images/assets
- buttons
- input fields
- cards
- dialogs
- bottom sheets
- navigation elements
- loading states
- empty states
- error states
- responsive constraints
- interactions/prototype connections

Do not rely only on a screenshot when structured Figma information is
available.

---

# 2. Determine Screen Purpose

Map the design to the relevant Smart Tani feature.

Example:

Figma:
"Tambah Lahan"

Maps to:

features/farm/

Figma:
"Hasil Cek Tanaman"

Maps to:

features/plant_scan/

Do not create a new feature simply because Figma contains a new page.

---

# 3. Compare With PRD

Determine what business requirement the screen represents.

Figma defines presentation.

PRD defines product behavior.

Example:

Figma may show:

"Arsipkan Lahan"

PRD determines the intended archive behavior.

Do not infer backend semantics from button wording alone.

---

# 4. Compare With Existing Flutter UI

Search the project for similar components.

Examples:

- AppButton
- AppTextField
- AppCard
- AppDialog
- AppBottomSheet
- EmptyState
- ErrorState
- LoadingState

Reuse existing components when they accurately represent the Figma
design.

Do not duplicate an existing reusable component.

---

# 5. Identify Design Tokens

Before hardcoding visual values, inspect whether the project already
defines:

- colors
- typography
- spacing
- radius
- shadows
- icon sizes

Prefer existing Smart Tani design tokens.

If Figma introduces a reusable design token that does not exist yet,
determine whether it should be added to the design system.

Do not create global tokens for one-off values.

---

# 6. Component Mapping

Map Figma components to Flutter components.

Example:

Figma
Farm Card
    ↓
Flutter
FarmCard

Figma
Primary Button
    ↓
Flutter
AppButton

Figma
Farm Name Input
    ↓
Flutter
AppTextField

Reuse first.

Create new components only when necessary.

---

# 7. Component Scope

Determine whether a new component is:

GLOBAL

or

FEATURE-SPECIFIC.

Global reusable component:

core/widgets/

Feature-specific component:

features/<feature>/presentation/widgets/

Do not put Farm-specific components into `core/widgets`.

---

# 8. Map UI Data

For every dynamic value shown in Figma identify its source.

Example:

"Lahan Utama"
→ FarmModel.name

"IR64"
→ active PlantingSeason variety

"45 hari"
→ derived plant age

Do not hardcode dynamic Figma sample values into production UI.

Figma sample content is presentation data, not necessarily application
data.

---

# 9. Map User Actions

Every interactive Figma element should have a defined application
action.

Example:

Tambah Lahan
↓
GoRouter
↓
CreateFarmPage

Simpan
↓
Farm Provider
↓
FarmRepository
↓
API

Arsipkan
↓
Confirmation UI
↓
Provider
↓
Repository
↓
Archive API

Do not call repository/API directly from button widgets.

---

# 10. Prototype Interactions

When a Figma prototype defines interaction behavior, inspect it.

Examples:

tap
→ navigate

tap
→ open bottom sheet

tap
→ open dialog

selection
→ change variant/state

Follow documented prototype behavior where it does not conflict with
product requirements.

Do not invent undocumented complex interaction behavior.

---

# 11. Responsive Implementation

Do not reproduce Figma using fixed absolute positioning unless the
design specifically requires it.

Prefer Flutter responsive layout primitives:

- Row
- Column
- Expanded
- Flexible
- Wrap
- LayoutBuilder
- MediaQuery where appropriate
- constraints

The implementation should preserve the visual hierarchy across
supported mobile sizes.

Do not optimize only for the exact Figma frame dimensions.

---

# 12. Avoid Pixel Hardcoding

Exact design values may be used for legitimate design tokens such as:

- spacing
- radius
- icon size
- component height

Avoid constructing the entire page using arbitrary pixel positions.

Do not translate Figma coordinates directly into Positioned widgets
unless the UI genuinely requires stacking/absolute positioning.

---

# 13. Text

Use wording from approved Figma/PRD.

Do not casually rewrite:

- button labels
- titles
- descriptions
- validation messages
- empty states

If Figma and PRD use different wording, identify the inconsistency.

---

# 14. Assets

Before creating or adding an asset:

1. inspect existing assets
2. check whether the asset already exists
3. reuse it when appropriate
4. use the approved Figma asset when needed

Do not substitute icons/images simply because they are visually
similar when the approved asset is available.

---

# 15. Icons

Use the project's established icon strategy.

If Figma uses an icon already available in the project's icon set,
reuse it.

Do not introduce a new icon package for a single icon without
justification.

---

# 16. UI States

Inspect whether Figma defines:

- default
- pressed
- disabled
- loading
- empty
- error
- selected
- success

Implement documented variants.

If important runtime states are missing from Figma but required by the
feature, use existing Smart Tani patterns and report the missing design
state.

Do not ignore runtime states simply because Figma only shows success.

---

# 17. Form States

For input components consider:

- empty
- focused
- filled
- invalid
- disabled
- submitting

Follow Figma variants when provided.

Validation rules come from product/API requirements, not visual design
alone.

---

# 18. Loading State

Do not invent a new loading pattern when Smart Tani already has one.

Reuse existing loading components.

If Figma explicitly defines a different feature-specific loading
experience, implement it according to the design.

---

# 19. Empty State

Empty-state wording and CTA should follow:

1. approved Figma
2. PRD
3. existing Smart Tani pattern

Do not treat empty data as an API failure.

---

# 20. Error State

If Figma provides an error dialog/page/state, follow it.

Error state presentation belongs to UI.

Raw infrastructure errors must still be mapped before reaching UI.

Never display raw DioException text simply because an error component
exists.

---

# 21. Provider Integration

UI must remain connected through Riverpod.

Expected:

Figma Screen
↓
Flutter Page
↓
Riverpod Provider
↓
Repository
↓
DataSource
↓
Dio

Figma does not change application architecture.

---

# 22. No Mock Data in Production

Figma values may be used temporarily while building visual UI only when
clearly isolated.

Do not leave Figma sample data hardcoded in production logic.

Example prohibited:

const farmName = 'Lahan Pak Budi';

when the value should come from API/provider state.

---

# 23. Visual Validation

After implementation compare the Flutter result against Figma.

Check:

- layout
- hierarchy
- spacing
- typography
- colors
- radius
- icons
- component sizes
- alignment
- content behavior
- states

Fix meaningful differences before considering the screen complete.

---

# 24. Architecture Validation

After visual validation check:

Page
→ Provider
→ Repository
→ DataSource
→ Dio

Ensure:

- no API in widgets
- no Dio in provider
- no BuildContext in repository
- no feature logic moved into core unnecessarily
- no duplicate components

---

# 25. Completion Report

Report:

## Figma

Frame/component implemented.

## Screen

Flutter screen created/updated.

## Reused Components

Existing Smart Tani components reused.

## New Components

New components introduced and why.

## Data Mapping

Dynamic UI values and their state/model sources.

## Interaction

Navigation/provider actions implemented.

## Design Differences

Any known differences from Figma and why.

## Validation

Report actual:

- formatting
- analysis
- tests
- visual comparison

Never claim pixel-perfect parity unless it was actually verified.