# NailMuse Style Guide (Dart / Flutter)

Owner: Aida Nazura (Lead Mobile Architect). Applies to everything in `src/`.
Rule of thumb: if `dart format` and `flutter analyze` are clean, the style is mostly right.

## 1. Tools (required before every commit)

```bash
dart format .
flutter analyze
flutter test
```

- Lint rules come from `flutter_lints` (in `analysis_options.yaml`). Do not silence a lint without a comment saying why.
- The CI pipeline (`.github/workflows/ci.yml`) runs `flutter analyze` and `flutter test` on every pull request. A red CI blocks the merge.

## 2. Naming

| Thing | Style | Example |
| --- | --- | --- |
| Files and folders | `lowercase_with_underscores` | `booking_screen.dart` |
| Classes, enums, typedefs | `UpperCamelCase` | `BookingScreen`, `Appointment` |
| Variables, functions, parameters | `lowerCamelCase` | `selectedSlot`, `loadAppointments()` |
| Constants | `lowerCamelCase` | `defaultDepositRate` |
| Private members | leading `_` | `_isLoading` |

File suffixes: `_screen.dart`, `_widget.dart`, `_provider.dart`, `_service.dart`, `_model.dart`.

## 3. Folder structure (`src/lib/`)

```
lib/
  main.dart
  core/        # theme (Material 3), routing, constants, shared widgets
  features/    # one folder per module, see below
  models/      # data classes and Firestore entities
  services/    # Firebase Auth, Firestore, OpenAI access
```

Each module in `features/` has the same inside:

```
features/appointments/
  screens/     # full pages
  widgets/     # pieces used only by this feature
  providers/   # Provider state (ChangeNotifier)
```

Suggested modules (from Figure 4 of the proposal): `auth`, `appointments`, `services_designs`, `reminders`, `inventory`, `ai_assistant`.

## 4. Architecture rules

1. **Screens only show things.** No Firestore or HTTP calls inside a widget.
2. **State lives in providers** (`provider` package, `ChangeNotifier`). Widgets read state with `context.watch` and call methods with `context.read`.
3. **Providers call services.** Only files in `services/` talk to Firebase or OpenAI.
4. **Models are plain Dart classes** with `fromMap` and `toMap`. Keep models free of Flutter imports.
5. **One screen, one job.** If a build method passes about 80 lines, split it into smaller widgets.
6. **Handle errors and loading** in every provider: loading, success and error states must all show something to the user.

## 5. Formatting and language

- Let `dart format` decide layout. Line length 80.
- Use single quotes for strings.
- Use `const` constructors wherever possible.
- Keep trailing commas in widget trees so the formatter lays them out well.
- Prefer `final` over `var`. Avoid `dynamic`.
- No unused imports, no commented-out code, no `print()` (use `debugPrint` while developing).
- Use `async`/`await`, and always handle errors with `try`/`catch` in services.
- Write `///` doc comments for public classes and methods. Add a comment when the reason for code is not obvious.

## 6. UI

- Material 3: `useMaterial3: true`. Take colours and text styles from `core/theme`, never hard-code them in screens.
- Target: Android 8.0 and above, phone screens.
- Show prices as `RM 58` and keep the 20% deposit visible before the customer pays.

## 7. Secrets and security (NFR-02)

- Never commit API keys, `google-services.json` secrets or `.env`. Only `.env.example` is committed.
- OpenAI calls must not expose the key in the repository.

## 8. Git workflow

- Never push directly to `main`. Work on a branch: `feature/FR-01-booking`, `fix/FR-02-calendar-crash`.
- Commit messages start with the FR-ID: `FR-07: add inventory list screen`.
- One feature per pull request. Fill in the pull request template and link the GitHub Issue.
- Each pull request needs one review and a green CI before merging. The Lead Mobile Architect checks structure and style.

## 9. Tests

- Test files mirror `lib/`: `lib/models/appointment_model.dart` is tested by `test/models/appointment_model_test.dart`.
- Every provider and model gets unit tests. Key screens get widget tests.

## 10. Branding: colours and fonts

Brand colours (the team's choice): **Night Bordeaux, Cool Horizon and Ivory Mist**. Use the names from `lib/core/theme/app_theme.dart`, never raw hex values in screens.

| Name | Hex | RGB | Used for |
| --- | --- | --- | --- |
| **Night Bordeaux** | `#5B0015` | 91, 0, 21 | Main colour: app bar, main buttons, headings |
| **Cool Horizon** | `#80AEE8` | 128, 174, 232 | Accent: selected items, active tab, tags |
| **Ivory Mist** | `#F7F2E0` | 247, 242, 224 | Screen background |

Helper colours (not brand colours, only for text, borders and messages):

| Name | Hex | RGB | Used for |
| --- | --- | --- | --- |
| Sky tint | `#DCE8F8` | 220, 232, 248 | Photo boxes, chat bubbles (light Cool Horizon) |
| Ink | `#2A1A1D` | 42, 26, 29 | Body text |
| White | `#FFFFFF` | 255, 255, 255 | Card fill, text on Night Bordeaux |
| Border | `#D9D2BC` | 217, 210, 188 | Borders, dividers |
| Sage | `#3F6B4C` | 63, 107, 76 | Success messages |
| Error red | `#C62828` | 198, 40, 40 | Error messages |

Colour rules (contrast numbers, 4.5 or more is readable):
- White text on Night Bordeaux: 14.4. Good.
- Night Bordeaux text on Ivory Mist: 12.9. Good.
- Night Bordeaux text on Cool Horizon: 6.3. Good.
- **Never put white text on Cool Horizon** (2.3) and never use Cool Horizon as text on Ivory Mist (2.1). Use it only as a fill, with Night Bordeaux text on top.

In Flutter, write a colour as `Color(0xFF5B0015)`. The `FF` at the start means fully solid.

Wireframes use grey only (`#E4E4E4`, `#9E9E9E`, `#424242`). These colours are not used in the final app.

Fonts (bundled as files in `src/assets/fonts/`, see the README there; no `google_fonts` package):

| Use | Font | Style |
| --- | --- | --- |
| Headings (H1, H2, H3) | Lora | Bold / SemiBold, 28 / 22 / 18 sp |
| Body, buttons, chips | Poppins | Regular / Medium, 16 / 14 / 12 sp |

Shape and spacing: spacing steps of 4, 8, 16 and 24 dp. Cards have 16 dp corners, input fields 12 dp, buttons and chips are fully rounded. Buttons are 48 dp high.
