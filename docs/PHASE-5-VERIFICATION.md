# Phase 5 Verification

Verified on 27 September 2026 for the Lumio Flutter application.

## Scope

Phase 5 adds the local progression and rewards engine without introducing
learning-game content. Progress is isolated by child profile and includes XP,
derived levels, best mission stars, coins, world totals, and one-time
achievements.

## Automated checks

The following commands completed successfully:

```powershell
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub --fatal-infos
flutter test --no-pub
flutter build apk --debug --no-pub
flutter build apk --debug --no-pub --target-platform android-x64
```

The final complete test run passed all 107 tests. It covers reward arithmetic,
level thresholds, replay and event idempotency, best-star improvements, coin
balance validation, one-time achievements, two-child isolation, file-backed
persistence, the version 1 to version 2 database migration, child switching,
the developer simulator, level-up feedback, and reduced-motion behavior.

Drift prints its known debug-only multiple-database warning in the persistence
test because the test deliberately closes and reopens the same database file.
The assertions and the full suite pass.

## Database migration

The profile database schema moves from version 1 to version 2. The migration
adds progression tables and does not recreate or clear profile tables. An
automated migration test creates a version 1 database, inserts profile data,
opens it with version 2, and confirms the profile remains available.

## Emulator verification

The Android x64 debug APK was installed on `emulator-5554`. Verification used
the existing child profile so the real migration path ran. The following flow
was checked:

1. Opened Home and confirmed initial Level 1 progression.
2. Opened all six Adventure worlds and confirmed they remain broadly available.
3. Used the debug simulator to complete a one-star mission.
4. Confirmed First Glow unlocked and XP, stars, and coins changed to 20, 1, and 3.
5. Retried the same event ID and confirmed no reward was added.
6. Restarted the app and confirmed the earned values persisted.
7. Scrolled Adventure, opened Rewards, and confirmed Rewards starts at its own
   top position rather than inheriting another destination's scroll offset.

Visual records are stored in `verification/ui-redesign/phase-5-home.png`,
`phase-5-map.png`, and `phase-5-rewards.png`.

## Product constraints confirmed

- Progression remains fully local and works offline.
- No cloud sync, analytics, advertising, purchases, or social features were
  added.
- The debug simulator and progression reset action are excluded from release
  behavior.
- Reset Progression Data clears progression while preserving child profiles.
- Full local reset continues to clear both profiles and their progression.
- No credentials or secret values were added. The repository scan only matched
  documentation that warns against storing database passwords.

