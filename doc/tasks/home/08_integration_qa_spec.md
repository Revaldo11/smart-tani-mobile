# T8 — Integration & QA

## Tasks
- [ ] All section providers registered in `HomePage`; refresh reloads each; disposing is clean.
- [ ] Section isolation: force one provider to error → other sections still render; each shows retry.
- [ ] Offline / 401: 401 handled globally by existing auth flow; offline shows error+retry per section (Indonesian copy from `AppException`).
- [ ] No raw `DioException` in UI; no `print`; no hardcoded sample text from the design left in code.
- [ ] Visual compare with design at 360×640, 390×844, and 1.3× font scale; screenshot via simulator.
- [ ] Empty-account path: new user without farm → T2 CTA, T3 hidden/prompt, T4 empty, others fine.
- [ ] Unit tests: `greetingFor`, `tipFor`, plant-age calc, each provider's success/error (fake repository).
- [ ] `dart format <changed files>`, `flutter analyze`, `flutter test` — report real results.

## Definition of Done
Every section meets its spec acceptance; open questions in README resolved or explicitly
deferred with a snackbar stub listed in the PR description.

## Report (per CLAUDE.md)
Changed · Architecture decisions · Reused vs new components · Data mapping ·
Design differences/assumptions · Validation actually run · Open items.
