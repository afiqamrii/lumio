# Phase 3 verification — Parent Onboarding & Child Profiles

Verified on Windows with Flutter 3.38.6 / Dart 3.10.7. Phase 4 is not implemented.

## Quality gates

| Check | Result |
| --- | --- |
| `flutter pub get` | Pass |
| `dart run build_runner build` | Pass; schema generated and checked in |
| Dart formatting | Pass; 69 Dart files formatted |
| `flutter analyze` | Pass; no issues |
| `flutter test` | Pass; 81 tests including previous phases |
| `flutter build apk --debug` | Pass; final normal APK, no sandbox define |
| Android runtime | Pass on Pixel_9_API_35 / emulator-5554 |
| Native error log | No Flutter error or AndroidRuntime crash entry during the recorded checks |
| Production identifiers | Android/iOS remain `my.nexuralabs.lumio` |
| Runtime artwork | All 11 selected files match their source bytes and recorded SHA-256 |
| Present source package | All 214 present manifest files match recorded SHA-256 |
| Color tokens | No raw `Color(0x...)` outside the existing palette |
| Credentials | No credential signatures found in application source; no credentials added |

The original manifest lists 244 paths; 30 legacy concept/reference paths are
absent from the current folder. Earlier phase reports recorded all 244 as
present. The cause/timing of this discrepancy has not been established. None of
the 11 application assets is missing. The source folder and manifest were not
edited to resolve it. The current path list is in ignored
`verification/phase3-final-audit.json`.

## Meaningful automated coverage

- Real SQLite setup, UUIDs, parent ownership, validated Unicode inputs, edits
  preserving identity/creation time, final-child deletion and reset.
- A trigger-induced write failure proves initial setup rolls back atomically.
- Malformed stored avatar fails safely without deleting data.
- Closing and reopening a real database file preserves setup, parent and children.
- Complete UI setup, second child, edit, selection/switch, confirmation,
  deletion, restart behavior and debug reset.
- Load/save error recovery and unsaved editor cancellation.
- Missing/deleted child routes, active-provider invalidation, separate mode
  navigation, production tool exclusion and child language isolation.
- Profile forms, cards and confirmation dialogs at 200% text on 320×640,
  390×844, 600×960, 768×1024 and 1024×768 layouts.
- Previous brand loading, design system, startup/lifecycle, route, reduced-motion,
  semantics and responsive navigation coverage remains passing.

Windows SQLite tests use the official native DLL prepared by
`tool/prepare-test-sqlite.ps1`. The archive checksum is pinned; extraction stays
in ignored `.dart_tool`. The app uses Drift's native connector, not this helper.

## Android runtime checks

The visible Pixel 9 API 35 emulator was used with a separate debug sandbox file,
avoiding changes to existing local profiles. This runs the production repository,
schema, router and screens. A visible PROFILE SANDBOX banner identifies it.

1. Fresh sandbox starts with official Lumio/Lumi welcome and four-stage setup.
2. Optional guardian name, first child nickname, age 6, Sun avatar and review
   save successfully; the real selector appears.
3. A second child with age 9 and Moon avatar saves from Add Child.
4. Opening each child's space shows its own nickname/avatar. Child tabs work;
   returning Home and exiting returns to the selector.
5. Parent Children edits the second nickname; the changed name appears in the
   deletion action and confirmation.
6. Cancel leaves the profile intact; confirmed deletion removes it and retains
   the first child.
7. Force-stop and restart loads the retained profile into the selector instead
   of restoring Child Mode. The parent name remains visible in Settings.
8. A 1024×768, density-160 layout shows bounded selector content and the parent
   navigation rail; cards and controls remain readable and scrollable.
9. Reset confirmation works at 200% system text. Confirming clears the sandbox
   and returns to onboarding; no unrelated database is reset.
10. Original Pixel size 1080×2424, density 420 and text scale 1.0 were restored.
    The final normal APK was installed and opened, without the sandbox banner.

Screenshots, accessibility hierarchies and logs are kept in ignored
`verification/phase3-*`. Native keyboard/input commands had occasional emulator
automation failures; successful retries and screen inspection confirmed actual
form entry and saves. An alternate headless emulator and temporary Android test
user could not provide a reliable UI tree. The temporary user was removed and
the task-owned headless emulator closed after restoring its display settings.
The user's visible Pixel emulator remains running.

## Build recovery and platform limits

An intermediate multi-architecture build ran out of disk space. Only disposable
workspace build intermediates were cleaned. An x64 sandbox APK then built for
testing; the final unflagged `flutter build apk --debug` also succeeded.

iOS cannot be built/run on this Windows host. Real-device VoiceOver/TalkBack,
native reduced motion and Bahasa Melayu copy review remain release checks.
Android native CRUD/persistence/reset was exercised; automated tests cover both
languages and reduced motion. Web SQLite WASM/worker assets are not provisioned
in this mobile phase; a web launch reports a safe local-load error. See
[PROFILES.md](PROFILES.md) for storage, privacy and future platform decisions.

No authentication, parental gate, backend, learning engine, progression,
subscription, analytics or Phase 4 UI was introduced. No commit or push was made.
