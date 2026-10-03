# Phase 4 verification — Child Home & Adventure Map

Verified on 27 September 2026 against Flutter 3.38.6 stable and Dart 3.10.7.

## Delivered scope

- Real child Home driven by the selected local profile
- Continue Adventure entry into a vertically scrolling connected map
- Six stable learning worlds with explicit temporary unlocked/locked states
- Localized world presentation in English and Bahasa Melayu
- Guarded World Landing route for unlocked worlds
- Friendly locked, unknown-world and missing-child recovery
- Lumi integration with finite entry motion and reduced-motion behavior
- Home, Adventure and Rewards child navigation
- Interaction hooks for a later sound layer

Learning games, persistent progression and reward balances remain outside Phase
4. Start Adventure clearly identifies the landing page as a preview and does
not mutate local data.

## Automated verification

Commands completed successfully from the project root:

```sh
flutter pub get
dart format lib test
flutter analyze --no-pub --fatal-infos
flutter test --no-pub
flutter build apk --debug --no-pub
```

Results:

- Dart formatting: 84 files checked, no changes required
- Static analysis: no issues found
- Test suite: 95 tests passed
- Android debug build: `build/app/outputs/flutter-apk/app-debug.apk`

The Phase 4 widget tests cover catalog stability, active-child content,
Home-to-map navigation, all six destinations, unlocked and locked behavior,
landing content, missing-profile recovery, phone layouts, tablet portrait,
tablet landscape and 200% text scaling. Existing routing, profile, persistence,
localization and design-system tests remain green.

Drift prints its known multiple-database debug warning during one persistence
test that intentionally closes and reopens the same test database. The test
passes and this is not a production database lifecycle failure.

## Emulator verification

The final APK was installed with data preserved on Android emulator
`emulator-5554`. The following path was exercised through the rendered UI:

1. Open the saved child profile.
2. Confirm the child's real nickname and avatar on Child Home.
3. Tap Continue Adventure.
4. Confirm the six-world connected map and Home/Adventure/Rewards navigation.
5. Confirm accessibility output announces `Open, Number Kingdom, Mathematics`
   once, without duplicated status.
6. Enter Number Kingdom.
7. Confirm localized subject, title, description, Lumi and Start Adventure.
8. Return with Back to Adventure Map and confirm map state.
9. Scroll to Arabic Oasis and confirm a locked tap stays on the map and displays
   `Keep exploring! This world will unlock later.`

The same screens were rendered by widget tests at 390px phone width, 1024px
tablet width, 320px with 200% English text and 390px with 200% Malay text.

## Product decisions

- Number Kingdom, Word Woods and Language Village are temporarily unlocked.
- Arabic Oasis, Logic Lab and Discovery Island are temporarily locked.
- These values are catalog demonstrations, not stored learner progress.
- Phase 5 will replace temporary status with progression and reward state.
- World IDs remain language-neutral route keys; names and descriptions are
  localized presentation data.
- No dependency was added for the map, animation or interaction hooks.

