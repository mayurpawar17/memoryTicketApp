# Implementation Plan - Conditional Onboarding Flow

Implement a professional app entry flow that shows the Splash screen first, then conditionally shows Onboarding based on whether it's the user's first time, using `shared_preferences`.

## User Review Required

> [!IMPORTANT]
> - I will be adding the `shared_preferences` package to your project.
> - The logic will be: **Splash -> (Check Prefs) -> Onboarding (if new) or Home (if returning)**.

## Proposed Changes

### [Dependencies]

#### [MODIFY] [pubspec.yaml](file:///D:/Projects/flutter_projects/memory_ticket_app/pubspec.yaml)
- Add `shared_preferences: ^2.5.2` (or latest stable compatible version).

### [Onboarding]

#### [MODIFY] [welcome_page.dart](file:///D:/Projects/flutter_projects/memory_ticket_app/lib/features/onboarding/presentation/pages/welcome_page.dart)
- Import `shared_preferences`.
- Update `_handleGetStarted` to be asynchronous.
- Implement logic to check `seenOnboarding` flag.
- Navigate to `MemoryOnboardingPage` if `false`, otherwise `HomePage`.

#### [MODIFY] [onboarding_page.dart](file:///D:/Projects/flutter_projects/memory_ticket_app/lib/features/onboarding/presentation/pages/onboarding_page.dart)
- Import `shared_preferences`.
- Update `_handleNext` to be asynchronous.
- On the final step, set `seenOnboarding` to `true` in preferences before navigating to `HomePage`.

## Verification Plan

### Automated Tests
- Run `flutter pub get` to verify dependency resolution.
- Run `flutter analyze` to ensure no syntax errors.

### Manual Verification
1. **Fresh Install**: Open app -> Splash -> Click Get Started -> Should see Onboarding.
2. **Complete Onboarding**: Finish onboarding -> Should see Home.
3. **Subsequent Launch**: Close app -> Open app -> Splash -> Click Get Started -> Should skip Onboarding and go straight to Home.
