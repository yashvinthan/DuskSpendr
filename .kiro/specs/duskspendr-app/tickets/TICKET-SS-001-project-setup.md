# SS-001: Flutter Project Setup with Clean Architecture

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-001 |
| **Epic** | Core Infrastructure |
| **Type** | Setup |
| **Priority** | P0 - Critical |
| **Story Points** | 5 |
| **Sprint** | Sprint 1 |
| **Assignee** | TBD |
| **Labels** | `setup`, `architecture`, `foundation` |

---

## User Story

**As a** development team member  
**I want** a properly structured Flutter project with Clean Architecture  
**So that** we have a maintainable, scalable foundation for DuskSpendr development

---

## Description

Set up the DuskSpendr Flutter project with Clean Architecture principles, proper folder structure, essential dependencies, and development tooling. This forms the foundation for all subsequent development.

---

## Acceptance Criteria

### AC1: Project Structure
```gherkin
Given the Flutter project is created
When I examine the folder structure
Then it should follow Clean Architecture:
  - lib/core/ (theme, utils, widgets, routing)
  - lib/features/ (auth, dashboard, transactions, etc.)
  - lib/data/ (models, repositories, datasources)
  - test/ (unit, widget, integration tests)
```

### AC2: Dependencies Configured
```gherkin
Given the project pubspec.yaml
When I review the dependencies
Then it should include:
  - flutter_riverpod: ^2.4.0 (state management)
  - go_router: ^12.0.0 (routing)
  - drift: ^2.14.0 (local database)
  - dio: ^5.4.0 (networking)
  - flutter_secure_storage: ^9.0.0 (secure storage)
  - freezed: ^2.4.0 (immutable models)
```

### AC3: Code Quality Tools
```gherkin
Given the project is set up
When I run analysis commands
Then the following should pass:
  - flutter analyze (0 issues)
  - dart format --set-exit-if-changed . (formatted)
  - Custom lint rules configured in analysis_options.yaml
```

### AC4: CI/CD Ready
```gherkin
Given the project structure
When I push to the repository
Then GitHub Actions should:
  - Run flutter analyze
  - Run flutter test
  - Build APK successfully
```

---

## Technical Requirements

### Folder Structure
```
DuskSpendr_app/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── theme/
│   │   ├── routing/
│   │   ├── utils/
│   │   └── widgets/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── dashboard/
│   │   ├── transactions/
│   │   ├── budgets/
│   │   ├── accounts/
│   │   └── settings/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── datasources/
│   └── main.dart
├── test/
├── integration_test/
├── android/
├── ios/
├── pubspec.yaml
└── analysis_options.yaml
```

### Key Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  go_router: ^12.0.0
  dio: ^5.4.0
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.18
  flutter_secure_storage: ^9.0.0
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  fl_chart: ^0.65.0
  flutter_animate: ^4.3.0
  google_fonts: ^6.1.0
  intl: ^0.18.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  riverpod_generator: ^2.3.0
  drift_dev: ^2.14.0
  mocktail: ^1.0.0
```

---

## Definition of Done

- [ ] Flutter project created with `flutter create --org com.DuskSpendr DuskSpendr_app`
- [ ] Folder structure matches specification
- [ ] All dependencies added and resolved (`flutter pub get`)
- [ ] analysis_options.yaml configured with strict rules
- [ ] README.md with project overview and setup instructions
- [ ] .gitignore properly configured
- [ ] GitHub Actions workflow created (`.github/workflows/flutter.yml`)
- [ ] `flutter analyze` passes with 0 issues
- [ ] `flutter test` runs (even with no tests)
- [ ] APK builds successfully (`flutter build apk`)
- [ ] iOS build configured (if on macOS)
- [ ] Code reviewed and approved

---

## Dependencies

| Dependency | Type | Description |
|------------|------|-------------|
| None | - | This is the foundation ticket |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-002 | Encrypted Database Setup |
| SS-003 | Core Data Models |
| SS-010 | Account Linking |
| All subsequent tickets | Foundation required |

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| Create Flutter project | 0.5 |
| Set up folder structure | 1 |
| Add dependencies | 1 |
| Configure analysis_options | 0.5 |
| Set up GitHub Actions | 1 |
| Documentation | 1 |
| **Total** | **5 hours** |

---

## Notes

- Use Flutter 3.16+ for latest features
- Target Android SDK 34, min SDK 24
- Target iOS 14+
- Enable null safety (default in Flutter 3.x)

---

## Related Links

- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Go Router](https://pub.dev/packages/go_router)

---

*Created: 2026-02-04 | Last Updated: 2026-02-04*
