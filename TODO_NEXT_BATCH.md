# Auto Ledger — Next TODO Batch (Pending Approval)

## Batch Goal
Move from feature-complete MVP core to release-ready MVP with better usability and deployment readiness.

---

## A) Reminder Actions (Product Usefulness)
- [ ] Add reminder action controls (Mark done / Snooze / Reschedule).
- [ ] Persist reminder action state per vehicle/reminder type.
- [ ] Show “next due” recalculation after reminder actions.
- [ ] Add tests for reminder action flows.

## B) Settings Expansion (Control & Safety)
- [x] Add export/import entry points in Settings.
- [x] Add backup/restore guidance screen.
- [x] Add reset confirmation flow (safe + explicit).
- [x] Add tests for settings action triggers.

## C) Reports & Insights Polish
- [x] Add custom date range picker UX in Reports.
- [x] Improve chart legends + empty/fallback states.
- [x] Add summary chips (top cost category, monthly delta).
- [x] Add tests for report filter and summary logic.

## D) Release Readiness (Android-first)
- [x] Finalize app branding assets (icon/splash/title).
- [x] Confirm package/app naming strategy (keep `motoledger` internally or rename).
- [x] Build Android release APK/AAB sanity check.
- [x] Add lightweight release checklist to README.

## E) Dev Workflow Hardening
- [ ] Expand TODO discipline (task start/midpoint/done cadence documented).
- [ ] Add CI-ready check script (`analyze + test`) for local consistency.
- [ ] Add contribution notes for future iterations.

---

## Proposed Execution Order
1. Reminder Actions
2. Settings Expansion
3. Reports Polish
4. Release Readiness
5. Dev Workflow Hardening

---

## Definition of Done (for this batch)
- [ ] All approved items implemented and checked off.
- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] Changes pushed to `main` with clean commit history.
