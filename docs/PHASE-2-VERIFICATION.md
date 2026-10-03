# Phase 2 verification

Verified 2026-09-26 on Windows using Flutter 3.38.6 / Dart 3.10.7.
Scope: app shell and navigation only. No Phase 3 implementation, commit or push.

## Required gates

| Check | Result |
| --- | --- |
| dart format lib test | Pass; 53 files, final check 0 changes |
| flutter pub get | Pass; existing dependencies preserved |
| flutter analyze --fatal-infos | Pass; no issues |
| flutter test --reporter expanded | Pass; 64 tests total, including 22 new navigation/lifecycle tests |
| flutter build apk --debug | Pass; build/app/outputs/flutter-apk/app-debug.apk |
| Source brand audit | Pass; all 244 original manifest SHA-256 hashes match |
| Imported brand audit | Pass; all 11 selections match docs/ASSET_SELECTION.json |
| Credentials scan | No credential-pattern matches in app/assets/config/docs/native app source |
| Production identifiers | Android/iOS remain my.nexuralabs.lumio |

No dependencies were added or upgraded. Newer incompatible dependency notices
are informational. Existing Phase 0/1 tests and asset/font decoding checks pass.

## Automated checks

Navigation tests verify branded startup and its finite handoff, both mode entries,
all sections, distinct selected state, repeated taps without stack growth, system
back to mode home then development chooser, alias/context routing, unknown and
malformed routes, and recovery. Incoming navigation cannot be overwritten by a
pending bootstrap timer. Lifecycle tests verify pending handoff cancellation on
pause/disposal and one completion after resume.

Release-style configuration rejects development routes even with flags enabled.
Reduced-motion pages have zero-duration transitions, preserve readable startup
and still navigate. Parent/child context survives pause/resume and layout changes.
Semantics cover selected actions, accessible labels, touch targets and contrast.
An isolated content semantics container keeps the nested Navigator from masking
the preceding mode header and back button.

Both shells render without Flutter overflow exceptions at 320x568, 390x844,
430x932, 768x1024, 1024x768 and 568x320. Additional 200% English/Bahasa Melayu
cases cover small phones, tablets and short landscape. Text is not capped or
ellipsized; narrow layouts wrap labels and content remains scrollable.

## Android runtime

Installed and launched the final debug APK on API 35 using the existing
flutter_emulator AVD in a task-owned emulator-5556 session. Inspected native
screenshots and UI Automator accessibility hierarchies:

- startup reaches the clearly marked development chooser;
- parent Home/Children/Progress/Settings navigate and system back returns to Home,
  then chooser; final APK header/back controls appear in native semantics;
- child Home/Worlds/Rewards navigate and system back returns to the same Home,
  then chooser; no parent destinations appear;
- route recovery renders curious Lumi and safely returns to the chooser;
- 390x844 logical phone portrait renders intact wordmark, mascot, cards and bars;
- resizing from selected Child Worlds to 1024x768 and 768x1024 preserves selection;
  landscape uses a rail, portrait uses bottom destinations and bounded content;
- parent tablet portrait and 320x568 with native font_scale 2.0 remain usable with
  wrapped labels and scrolling content;
- app-specific Flutter/AndroidRuntime error log contains no errors.

Display size/density and font scale were restored to the initial 1080x1920,
420 density and 1.0 font scale. The task-owned emulator was closed.

## Release browser runtime

Built the final code with flutter build web --no-web-resources-cdn and both
LUMIO_NAVIGATION_PREVIEW=true and LUMIO_DESIGN_PREVIEW=true. Served only on
127.0.0.1:8483 and checked using the agent-browser and agent-browser-verify skills.

- startup resolves to /welcome, preserving the holding screen;
- /dev and /dev/design-system show the friendly route error page;
- direct /parent/home renders only parent navigation; selecting Children changes
  the URL to /parent/children, including a 1024x768 tablet viewport;
- direct /child/browser_context/home renders only child navigation and no debug
  exit action;
- /missing renders recovery, whose action returns to /welcome;
- browser page errors are empty; console contains only normal Flutter
  loader/service-worker messages.

The web build reports Flutter's generic optional Cupertino icon-font discovery
notice; no Cupertino icons are used by the app and there are no runtime errors.
The browser session and task-owned local HTTP server were closed.

Screenshots, native hierarchies and gate logs remain in ignored verification/.

## Remaining device review

Windows cannot build or run iOS. Check iOS safe-area/status-bar behavior and
back gestures on a real device before release. Reduced motion is exercised by
widget tests; review a native device with the OS preference enabled. Real-device
TalkBack/VoiceOver traversal and Bahasa Melayu copy review remain valuable release
checks. Native external deep-link intent filters/universal links are intentionally
not introduced; browser/internal routing has been verified.

No account/profile authorization or parental gate exists in this phase. The
shell callbacks and top-level redirect are documented future integration points,
not a security boundary. No Phase 2 implementation issue remains unresolved.
