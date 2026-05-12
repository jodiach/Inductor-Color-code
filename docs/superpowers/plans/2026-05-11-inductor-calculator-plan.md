# Implementation Plan — Inductor Color Code Calculator

## Phase 1: Project Initialization
- [ ] Initialize Flutter project in current directory
- [ ] Add necessary dev_dependencies (test, flutter_lints)
- [ ] Set up directory structure according to design spec
- [ ] Configure `pubspec.yaml` with Google Fonts (`Roboto`, `Roboto Mono`)

## Phase 2: Core & Domain Layer Development
- [ ] Implement `lib/core/theme/app_theme.dart` (Dark mode, cyan neon)
- [ ] Implement `lib/core/constants/color_codes.dart` (Mapping data)
- [ ] Implement `lib/core/utils/unit_converter.dart` (pH to H conversion)
- [ ] Implement `lib/domain/entities/inductor.dart`
- [ ] Implement use cases:
    - [ ] `color_to_value.dart`
    - [ ] `value_to_color.dart`
    - [ ] `single_layer_coil.dart`
    - [ ] `multi_layer_coil.dart`
    - [ ] `flat_spiral_coil.dart`

## Phase 3: Presentation Layer Development
- [ ] Implement ViewModels:
    - [ ] `inductor_calculator_vm.dart`
    - [ ] `coil_calculator_vm.dart`
- [ ] Implement Widgets:
    - [ ] `inductor_illustration.dart` (CustomPaint)
    - [ ] `color_tile.dart`
    - [ ] `value_display.dart`
    - [ ] `coil_geometry_diagram.dart`
- [ ] Implement `home_page.dart` with Tabs and Sub-tabs
- [ ] Finalize `app.dart` and `main.dart`

## Phase 4: Testing & Verification (TDD)
- [ ] Write unit tests for color code calculation logic
- [ ] Write unit tests for coil inductance formulas
- [ ] Write widget tests for color selection interaction
- [ ] Verify state updates in ViewModels

## Phase 5: Build & Deployment
- [ ] Build release APK: `flutter build apk --release`
- [ ] Verify APK installation and basic functionality
