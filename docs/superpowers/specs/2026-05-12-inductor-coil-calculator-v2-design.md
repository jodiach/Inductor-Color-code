# Inductor Coil Calculator — Feature Expansion Design

**Date:** 2026-05-12
**Project:** Inductor Coil Calculator Flutter App

---

## 1. App Identity

| Item | Value |
|------|-------|
| Package name | `inductor_coil_calculator` |
| Android/iOS label | `Inductor Coil Calculator` |
| Meta keywords | inductor, color code, SMD, coil, inductance, calculator |

---

## 2. Theme: Light + Dark Mode

### Light Theme Palette

| Token | Hex | Usage |
|-------|-----|-------|
| backgroundDeep | `#F8F9FB` | Scaffold background |
| backgroundSurface | `#FFFFFF` | Header, toolbar |
| backgroundCard | `#FFFFFF` | Cards |
| accentNeon | `#E8FF47` | Primary accent (kept) |
| accentElectric | `#00E5CC` | Secondary accent (kept) |
| textPrimary | `#1A1E2A` | Headings, values |
| textSecondary | `#5A6A7A` | Labels, hints |
| textMuted | `#9AA5B1` | Disabled |
| borderSubtle | `#E2E8F0` | Card borders |
| shadowLight | `#E2E8F0` | Card elevation |

### Dark Theme
Existing dark theme colors remain unchanged.

### Implementation
- `ThemeViewModel` (ChangeNotifier) holds `isDarkMode` boolean
- Persisted via `SharedPreferences` key `is_dark_mode`
- `app.dart` reads theme and sets `MaterialApp.themeMode`
- Toggle accessible from settings page

---

## 3. Navigation Structure

```
HomePage (TabBar)
├── INDUCTOR tab → existing inductor calculator
├── COIL tab → existing coil calculator
└── AppBar actions (right side):
    ├── 🕐 History → HistoryPage
    ├── 🎨 Color Bands → InductorColorBandsPage
    ├── 💠 SMD Code → SmdCodePage
    ├── ⚙️ Steel Coil → SteelCoilPage
    └── ☰ Menu → SettingsPage
        ├── Settings → SettingsPage
        ├── About → AboutPage
        ├── Privacy Policy → PrivacyPage
        └── Terms of Service → TermsPage
```

---

## 4. New Pages

### SettingsPage
- Theme toggle switch (Light/Dark)
- App version info
- Navigation links to About, Privacy, Terms

### HistoryPage
- Grouped by calculation type: Inductor Color Bands, Coil Calculations, SMD Code, Steel Coil
- Each entry: type icon, result summary, timestamp
- Tap → re-load into respective calculator
- Swipe-to-delete
- Empty state illustration

### InductorColorBandsPage
- Tab: **Reference** — all color codes chart (digits, multipliers, tolerances)
- Tab: **Calculator** — interactive 4/5/6-band calculator

### SmdCodePage
- Text input for 3-character SMD code
- Auto-detect EIA-96 vs numeric
- Result: value in µH with breakdown
- History of decoded codes

### SteelCoilPage
- Toggle: **Weight** | **Unwind**
- **Weight inputs:** Inner Diameter (in), Outer Diameter (in), Width (in), Density (lb/in³, default 0.284)
- **Weight output:** Total weight (lbs), Weight per inch (lbs/in)
- **Unwind inputs:** OD, ID, Thickness (in), Width (in)
- **Unwind output:** Lineal feet, Feet per layer, Sheets per coil

### AboutPage, PrivacyPage, TermsPage
- Static content pages
- Name: `Inductor Coil Calculator`

---

## 5. Database Schema (SQLite)

### Table: calculations
```sql
CREATE TABLE calculations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type TEXT NOT NULL,
  -- type values: inductor_color_4, inductor_color_5, coil_single, coil_multi,
  -- coil_flat_spiral, smd_code, steel_weight, steel_unwind
  inputs TEXT NOT NULL,     -- JSON string
  result TEXT NOT NULL,     -- JSON string
  created_at INTEGER NOT NULL -- Unix timestamp ms
);
```

---

## 6. ViewModels

| ViewModel | State |
|-----------|-------|
| `ThemeViewModel` | `isDarkMode`, `toggleTheme()` |
| `HistoryViewModel` | CRUD, grouped list |
| `SmdCodeViewModel` | `inputCode`, `resultValue`, `parse()` |
| `SteelCoilViewModel` | Weight/unwind inputs, computed results |

---

## 7. Naming

All user-facing text: **English only**
App name on all pages and metadata: **Inductor Coil Calculator**