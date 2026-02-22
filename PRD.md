# Product Requirements Document (PRD)
## Product: Auto Ledger
**Owner:** Titus / VETECH  
**Prepared by:** Zayne  
**Date:** 2026-02-22

---

## 1) Purpose
Build a mobile-first Flutter app for personal and small-fleet vehicle expense tracking, with clear Cost of Ownership reporting per vehicle.

The app should answer:
- “How much is this car really costing me?”
- “Which expense categories are draining money?”
- “What is my cost per km over time?”

---

## 2) Goals (MVP)
1. Allow users to manage multiple vehicles.
2. Log expenses quickly from phone (fuel, service, repairs, etc.).
3. Generate per-vehicle ownership cost insights and reports.
4. Work offline-first with local storage.

### Non-goals (MVP)
- Multi-user collaboration
- Cloud sync/account auth
- Advanced telematics/OBD integration
- AI predictions

---

## 3) Target users
- Individual car owners tracking rising car costs.
- Entrepreneurs/small businesses with 1–10 vehicles.

---

## 4) Platforms
- Flutter app codebase.
- Initial scaffold: Android + iOS.
- Web support planned in phase 2 by enabling web platform and responsive layouts.

---

## 5) Core MVP features

### 5.1 Vehicle Management
- Add/Edit/Delete vehicle
- Fields:
  - Nickname (optional)
  - Make
  - Model
  - Year
  - Registration number
  - Purchase date
  - Purchase price
  - Initial mileage / odometer at purchase

### 5.2 Expense Tracking
- Add/Edit/Delete expense entries per vehicle
- Categories:
  - Fuel
  - Service
  - Repairs
  - Insurance
  - Licensing/registration
  - Tires
  - Parking/tolls
  - Car wash
  - Other
- Fields:
  - Date
  - Amount
  - Category
  - Odometer (optional but recommended)
  - Vendor (optional)
  - Notes (optional)

### 5.3 Reports & Insights
Per vehicle:
- Total expenses (selected date range)
- Total ownership cost = purchase price + expenses
- Monthly average spend
- Category breakdown (pie/bar)
- Cost per km (when odometer deltas are available)

Global:
- Summary across all vehicles

### 5.4 Filtering
- Preset ranges: 30 days, 90 days, 1 year, all time
- Custom date range

### 5.5 Data Export
- CSV export of expenses (MVP)
- PDF report (stretch goal for MVP, otherwise phase 1.1)

---

## 6) UX requirements (mobile-first)
- Fast “Quick Add Expense” flow (≤10 seconds target)
- Big touch targets and low typing friction
- Bottom navigation:
  - Vehicles
  - Add Expense
  - Reports
  - Settings
- Currency support with locale formatting
- Empty states with guidance

---

## 7) Technical design (MVP)

### 7.1 Stack
- Flutter (stable)
- State management: flutter_bloc
- Routing: go_router
- Local DB: Isar
- Charts: fl_chart

### 7.2 Data model (initial)
- `Vehicle`
  - id, make, model, year, regNumber, purchaseDate, purchasePrice, initialMileage, nickname
- `Expense`
  - id, vehicleId, date, amount, category, odometer, vendor, notes

### 7.3 Architecture
- Feature-first structure:
  - `features/vehicles`
  - `features/expenses`
  - `features/reports`
  - `core/` (theme, utils, constants)
- Repository abstraction above database for future sync migration.

---

## 8) Metrics of success
- User can add first vehicle in <2 minutes
- User can log expense in <10 seconds after onboarding
- Reports load in <1 second for 5,000 local records
- Zero data loss in offline mode

---

## 9) Risks & mitigations
- **Risk:** Incomplete odometer data reduces accuracy of cost/km.  
  **Mitigation:** Prompt user for odometer on relevant categories; fallback messaging.

- **Risk:** Users forget to log small expenses.  
  **Mitigation:** Quick-add UX and optional reminders (phase 1.1).

- **Risk:** Scope creep.  
  **Mitigation:** Strict MVP boundary and phased roadmap.

---

## 10) Roadmap

### Phase MVP (now)
- Vehicle CRUD
- Expense CRUD
- Core dashboard + category chart
- Date filters
- CSV export

### Phase 1.1
- Service/insurance reminders
- Receipt photo attachment
- PDF reporting polish

### Phase 2
- Web target enabled
- Cloud backup/sync (Supabase/Firebase)
- Auth and multi-device sync

---

## 11) Naming options (recommendation)
Current starter project name: **motoledger**

Alternative product names to consider:
1. **AutoLedger**
2. **GarageLedger**
3. **DriveCost**
4. **MotaBook** (local flavor)

Recommended: **AutoLedger** (clear and easy to market).

---

## 12) Approval checklist
Please confirm:
- [ ] Product name choice
- [ ] Keep MVP scope as defined
- [ ] Keep Android+iOS first, web in phase 2
- [ ] Approve stack (flutter_bloc + go_router + Isar + fl_chart)
- [ ] Approve CSV export in MVP, PDF as stretch/phase 1.1

Once approved, I will start implementation immediately.
