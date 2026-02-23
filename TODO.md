# Auto Ledger Task TODOs

- [x] Fix analyzer lint warnings in settings page (`use_build_context_synchronously`) and push to main.

## Approved Next Batch
- [x] Add reminder action controls (Mark done / Snooze / Reschedule).
- [x] Persist reminder action state per vehicle/reminder type.
- [x] Show “next due” recalculation after reminder actions.
- [x] Add tests for reminder action flows.
- [x] Add export/import entry points in Settings.
- [x] Add backup/restore guidance screen.
- [x] Add reset confirmation flow (safe + explicit).
- [x] Add tests for settings action triggers.
- [x] Add custom date range picker UX in Reports.
- [x] Improve chart legends + empty/fallback states.
- [x] Add summary chips (top cost category, monthly delta).
- [x] Add tests for report filter and summary logic.
- [x] Finalize app branding assets (icon/splash/title).
- [x] Confirm package/app naming strategy (keep `motoledger` internally or rename).
- [x] Build Android release APK/AAB sanity check.
- [x] Add lightweight release checklist to README.
- [x] Expand TODO discipline (task start/midpoint/done cadence documented).
- [x] Add CI-ready check script (`analyze + test`) for local consistency.
- [x] Add contribution notes for future iterations.
- [x] All approved items implemented and checked off.
- [x] `flutter analyze` passes.
- [x] `flutter test` passes.
- [x] Changes pushed to `main` with clean commit history.

## TODO Discipline Cadence
- Start: mark the task as active in this file and add a one-line implementation intent.
- Midpoint: add a short status note with one concrete checkpoint completed and one next action.
- Done: check off the task only after code, docs, and tests are complete; include evidence reference (script/command used).
- Batch close: mark `All approved items implemented and checked off` only when every approved item in the batch is complete.

## New Priority Requests
- [x] Reports UI modernization: redesign with richer dashboard metrics and additional charts.
- [x] Dashboard-first navigation: add a new Dashboard as first tab with quick overview cards.
- [x] Dashboard actions: quick add expense, jump to vehicles, jump to reports.
- [x] Apply liquid-glass visual style to dashboard surfaces and key cards.
- [x] Convert bottom navigation to floating Telegram-like style.
- [ ] Validate UX changes with analyze/test and push to main.
