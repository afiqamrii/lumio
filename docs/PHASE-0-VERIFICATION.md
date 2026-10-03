# Phase 0 verification

**Status: Complete** — 26 September 2026 (Asia/Kuala_Lumpur).

Verified baseline: Flutter 3.38.6 stable, Dart 3.10.7, Windows 11.
Android SDK platform 36 / emulator Android 35, Java 21 from Android Studio.
Permanent Android/iOS identifier: `my.nexuralabs.lumio`.

## Required quality gates

| Check | Result |
| --- | --- |
| `flutter pub get` | Passed; compatible stable packages resolved and locked. |
| `flutter gen-l10n` | Passed; English and Bahasa Melayu source generated. |
| `dart format lib test` | Passed. |
| `dart format --output=none --set-exit-if-changed lib test` | Passed; 19 Dart files, no pending formatting changes. |
| `flutter analyze --fatal-infos` | Passed; no issues. |
| `flutter test` | Passed; all 10 tests. |
| `flutter build apk --debug` | Passed; universal debug APK produced. |
| Android startup | Passed; installed on emulator-5556, running activity and rendered screen verified. |
| Brand preservation | Passed; all 244 supplied manifest hashes match. |
| Configuration/credential review | No credentials added; sensitive/local files confirmed ignored. |
| Dependency review | Only Flutter SDK, localisation, Riverpod, go_router, intl and lint/test foundations; no backend/game/analytics SDKs. |

First Android build took 1018.4 seconds while Gradle 8.14, Android build artifacts
and the required NDK 28.2.13676358 were prepared. The official SDK installer
completed successfully; the redundant recovery download was stopped and removed.
The shared Flutter SDK was not upgraded.

APK: `build/app/outputs/flutter-apk/app-debug.apk` (148,290,739 bytes).
SHA-256: `a759d414051944e365582abf6dcf04aa6940d729103f3453864af1cd822de345`.

## Runtime checks

Android: installed the exact built APK on the task-owned headless instance of
the existing flutter_emulator AVD, launched `my.nexuralabs.lumio/.MainActivity`,
confirmed the activity remained resumed, and reviewed an actual device screenshot.
The production logo, cream background, bundled fonts, tagline and owner
attribution render. A repeat activity launch returned Status: ok. The initial
cold-launch wait timed out while the software-rendered emulator initialized;
subsequent rendering/startup was verified. App-specific log review found no
fatal exception, unhandled exception, application error-hook event or missing
asset error. This emulator timing is not a physical-device performance test.

Local Android screenshot/logs are in `verification/`, ignored by Git.
The APK remains installed on the AVD for subsequent manual review.

Additional optional web check: `flutter build web --no-web-resources-cdn`
passed; the self-contained build was served locally and verified with Playwright.
It rendered the Flutter surface with the title Lumio and no page exceptions or
failed requests. A screenshot was captured and visually reviewed.
The headless debug web-server check compiled and returned HTTP 200 but did not
initialize the rendered surface; this does not establish a working browser debug
session. Use the compiled preview steps below for the verified browser path.
The web build emitted an SDK Cupertino font-reference tree-shaking warning;
the shell uses no Cupertino glyphs, so the unused cupertino_icons dependency
was not added back.

## What tests cover

- valid environment names and rejection of typos;
- available-width breakpoint boundaries;
- actual provider/router/app startup and supplied logo loading;
- English strings and system Bahasa Melayu locale resolution;
- 200% text plus reduced-motion input on portrait phone, landscape phone,
  landscape tablet and portrait tablet;
- unmatched-route recovery, 56px touch target, accessible labels and contrast.

## Manual acceptance steps

1. From `C:\Users\afiqa\Project Lumio\lumio-1`, run `flutter pub get`.
2. Connect an Android device or launch an emulator, run `flutter devices`,
   then `flutter run -d <device-id>`.
3. Confirm Lumio branding, “Play. Learn. Glow.”, “Development Foundation”,
   and “A product by Nexura Labs.” Inspect the installed launcher icon.
4. Rotate the device and check tablet portrait/landscape where available.
   Increase system text size to 200%; all text should remain readable and
   scroll into view without clipping.
5. Switch the device language to Bahasa Melayu. Relaunch and verify
   “Main. Belajar. Bersinar.” and “Asas Pembangunan”.
6. Enable a screen reader and reduced motion, with sound disabled. Confirm
   the logo and heading are announced; all shell information remains visible.
7. On macOS/Xcode, run on an iOS simulator and review the universal icon catalog,
   orientation, fonts and accessibility. Physical iOS signing remains a later
   release setup task.

For the verified optional compiled browser preview:

```sh
flutter build web --no-web-resources-cdn
python -m http.server 8463 --bind 127.0.0.1 --directory build/web
```

Open http://127.0.0.1:8463. Python is only a local static-file preview helper,
not an application dependency. Stop it with Ctrl+C.

## Remaining review before Phase 1 acceptance/release work

iOS compilation requires macOS/Xcode and was not run on this Windows host.
Physical phone/tablet accessibility, font/Arabic shaping and icon appearance
still need device review; Arabic UI/content has not been implemented.
The minimal BM translation should receive language review before publication.
Release signing, store submission and all later features remain outside Phase 0.

No commits or pushes were made. Existing branding documentation is unchanged.
Phase 1 has not been implemented.

