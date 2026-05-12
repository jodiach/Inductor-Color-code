# Inductor Color Code Calculator — Design Spec

## Concept & Vision

A minimalist, modern Flutter mobile app for calculating inductor color codes and air-core coil inductance. Dark mode aesthetic with cyan neon accents. Zero clutter, high function. The centerpiece is a clean vector inductor illustration that updates in real-time as bands are selected.

---

## Aesthetic

- **Theme:** Dark mode — deep charcoal/near-black backgrounds (`#0D0D1A`, `#13132B`)
- **Accent:** Cyan neon (`#00F0FF`) for active/selected bands and highlights
- **Style:** Clean vector/flat illustration for the inductor, no photorealism
- **Typography:** `Roboto Mono` for values (precision/technical), `Roboto` for labels
- **Spacing:** Generous padding, breathing room, single-focus layout

---

## Layout

Mobile-first, centered single-column card layout, max-width 480px, centered on larger screens.

```
[Header: App Title + Tagline]
[Inductor Illustration — CustomPaint, real-time band colors]
[Value Display — inductance + tolerance range]
[Tab Bar: Inductor Calculator | Coil Calculator]
[Content Area — varies by tab]
```

---

## Tab 1: Inductor Calculator

### Mode Toggle (Manual / Auto)

**Manual Mode:**
- Band count toggle: 4 or 5 bands
- 4-band: Digit1 | Digit2 | Multiplier | Tolerance
- 5-band: Digit1 | Digit2 | Digit3 | Multiplier | Tolerance
- Each band slot shows a row of 10 color tiles (Black→White) + Gold/Silver for tolerance
- Tapping a tile selects it; selected tile shows cyan border glow
- Inductor illustration updates in real-time as bands are selected

**Auto Mode:**
- Number input for inductance value
- Unit dropdown: pH / nH / µH / mH / H
- Tolerance dropdown: ±1%, ±2%, ±5%, ±10%, ±20%
- "Calculate" button → resolves to E-series value + band colors
- Shows resulting bands on the visual inductor

### Color Code Mapping

| Digit | Color | Multiplier | Color | Tolerance | Color |
|-------|-------|------------|-------|-----------|-------|
| 0     | Black | ×1         | Black | ±20%      | No band |
| 1     | Brown | ×10        | Brown | ±1%       | Brown  |
| 2     | Red   | ×100       | Red   | ±2%       | Red    |
| 3     | Orange| ×1k        | Orange| ±3%       | Orange |
| 4     | Yellow| ×10k       | Yellow| ±4%       | Yellow |
| 5     | Green | ×100k      | Green | ±0.5%     | Green  |
| 6     | Blue  | ×1M        | Blue  | ±0.25%    | Blue   |
| 7     | Violet| ×10M       | Violet| ±0.1%     | Violet |
| 8     | Gray  | ×100M      | Gray  | ±0.05%    | Gray   |
| 9     | White | ×1G        | White |           |        |
|       |       | ×0.1       | Gold  | ±5%       | Gold   |
|       |       | ×0.01      | Silver| ±10%      | Silver |

### Output

- Large bold inductance value: auto-switches to best unit (pH → nH → µH → mH → H)
- Tolerance text: `±10%` and value range `4.23–5.17 mH`

---

## Tab 2: Coil Calculator

Three sub-tabs: **Single-Layer** | **Multi-Layer** | **Flat Spiral**

### Single-Layer Solenoid
Inputs:
- Coil diameter D (mm)
- Coil length/winding width L (mm)
- Wire diameter dw (mm)
- Number of turns N

Output: Calculated inductance in µH (Wheeler's formula)

### Multi-Layer Coil
Inputs:
- Inner diameter d (mm)
- Outer diameter D (mm)
- Winding length l (mm)
- Wire diameter dw (mm)
- Number of turns N

Output: Calculated inductance in µH (simplified multilayer formula)

### Flat Spiral Coil
Inputs:
- Outer diameter D (mm)
- Trace width w (mm)
- Trace spacing s (mm)
- Number of turns N
- Substrate thickness t (mm)

Output: Calculated inductance in µH (Mongef's flat spiral formula)

Each sub-tab shows a small schematic diagram of the geometry above the inputs.

---

## Technical Architecture

```
lib/
├── main.dart
├── core/
│   ├── theme/
│   │   └── app_theme.dart           # Dark theme, cyan accent
│   ├── constants/
│   │   └── color_codes.dart         # All color code data constants
│   └── utils/
│       └── unit_converter.dart      # pH/nH/µH/mH/H auto-switch
├── domain/
│   ├── entities/
│   │   └── inductor.dart           # Inductor value, tolerance, bands
│   └── usecases/
│       ├── color_to_value.dart      # Band colors → inductance value
│       ├── value_to_color.dart      # Inductance value → band colors (E-series)
│       ├── single_layer_coil.dart   # Wheeler's formula
│       ├── multi_layer_coil.dart    # Multilayer formula
│       └── flat_spiral_coil.dart    # Flat spiral formula
├── presentation/
│   ├── viewmodels/
│   │   ├── inductor_calculator_vm.dart  # Manages band state, manual/auto mode
│   │   └── coil_calculator_vm.dart       # Manages coil form state
│   ├── widgets/
│   │   ├── inductor_illustration.dart   # CustomPaint vector inductor
│   │   ├── color_tile.dart              # Individual color tile widget
│   │   ├── value_display.dart           # Large inductance value display
│   │   └── coil_geometry_diagram.dart    # Small SVG-like diagram per coil type
│   └── pages/
│       └── home_page.dart           # Main screen with tabs
└── app.dart                          # MaterialApp + theme setup
```

State management: **ChangeNotifier** (ViewModel pattern, no extra packages).
No external state management packages — keep it clean and testable.