# Phase 1 verification

Verified 2026-09-26 on Windows with Flutter 3.38.6 stable / Dart 3.10.7.
Scope: design system only. No Phase 2 implementation, commit or push.

## Required gates

| Check | Result |
| --- | --- |
| dart format lib test | Pass; final check reports 42 Dart files, 0 changes |
| flutter pub get | Pass; flutter_svg 2.3.0 resolved on the existing SDK |
| flutter analyze --fatal-infos | Pass; no issues |
| flutter test --reporter expanded | Pass; 42 tests total |
| flutter build apk --debug | Pass; build/app/outputs/flutter-apk/app-debug.apk |
| Runtime image/font/license bundle checks | Pass; all 11 imports loaded and matched source bytes |
| Source preservation | Pass; all 244 original manifest SHA-256 hashes match |
| Imported selection hashes | Pass; all 11 hashes match docs/ASSET_SELECTION.json |
| Credential-pattern scan | No matches in app/assets/config/docs/native app source |

Dependency notices about newer incompatible versions are informational. Existing
dependencies and the Flutter SDK were not upgraded. Only flutter_svg was added
as a direct dependency to render original production SVGs.

## Automated behavior and layout coverage

The 32 new design-system tests supplement the 10 existing foundation tests:
- four button variants activate once and meet labeled-target/contrast checks;
- disabled and loading actions cannot activate; loading has accessible status;
- reduced motion substitutes a static loading indicator;
- a held press compresses paint to 0.97 while InkWell geometry remains stable;
- keyboard focus and Enter activate the same callback;
- icon actions are labeled and selected cards expose state with a check icon;
- fractions 0, 0.5, 1, negative, above 1, NaN and infinity render safely;
- progress updates interpolate; reduced motion applies the final value immediately;
- all badge tones meet automated text-contrast checks;
- all source palette values match the original JSON;
- every imported SVG/PNG/font/license file loads and matches source bytes;
- all three SVGs decode into pictures; both PNGs decode at 1254 × 1254;
- logo variants/mascot poses mount without asset errors; light theme initializes;
- production cannot expose the preview, even with its flag enabled;
- English/BM showcase layouts render without Flutter overflow exceptions at
  320×568, 390×844, 430×932, 768×1024 and 1024×768, including 200% text on the
  small phone, large phone and portrait tablet;
- existing shell/recovery/localization tests still pass.

## Visual and runtime checks

Android:
- installed the debug APK on the existing API 35 flutter_emulator, task-owned
  emulator-5556 session; launched my.nexuralabs.lumio/.MainActivity successfully;
- inspected native portrait rendering at 1080×1920 physical pixels, density 420
  (approximately 411 logical pixels wide);
- inspected source wordmark, Nunito/Lexend, Lumi, white/cream surfaces and wrapping;
- set system font_scale to 2.0, restarted, inspected natural text wrapping and
  scrolling, then restored the original 1.0 setting;
- app-specific logcat scan found no Flutter asset, RenderFlex or fatal errors.

Browser:
- compiled with flutter build web --no-web-resources-cdn
  --dart-define=LUMIO_DESIGN_PREVIEW=true, serving locally on 127.0.0.1:8473;
- used the agent-browser and agent-browser-verify skills to inspect actual rendering,
  controls, semantics and errors;
- visually reviewed 1024×768 tablet and 320×568 phone views;
- verified full primary integrated-o, plum wordmark and white compact logo SVGs,
  including transparent cutouts; both source mascot poses appear intact;
- inspected typography including numerals/RTL Arabic font specimen, button wrapping,
  disabled/icon controls, selected-card checkmark, fractions and status badges;
- pressed a button and observed “Presses: 1”, selected a card and observed its
  changed accessible label, changed the sample from 40% to 50%;
- browser page-error list was empty; console contained only Flutter loader/service
  worker debug messages. Web compilation emitted a generic Cupertino font-discovery
  notice; the app uses Material icons, which rendered successfully.

Enabling Flutter web semantics sets accessibleNavigation, so the web preview
correctly switches to reduced motion and prevents the local switch overriding it.
Normal press animation is verified by widget gesture tests; physical-device
animation feel remains a manual review item.

Screenshots/logs are local and ignored under verification/. Relevant captures:
phase1-android-phone.png, phase1-android-identity.png, phase1-android-text200.png,
phase1-tablet-identity.png, phase1-tablet-buttons.png, phase1-tablet-selection.png,
phase1-tablet-progress.png, phase1-phone-top.png, phase1-phone-buttons.png.
The temporary browser/server/emulator are closed after inspection; no background
preview is needed to run the app normally.

## Audits and limits

Raw brand hex declarations occur only in lumio_palette.dart; font sizes only in
lumio_typography.dart. The development palette specimen displays source values
deliberately. No unnecessary animation/state/backend packages were introduced.
Original branding and native launcher sources were not modified.

No Phase 1 blockers remain. Windows cannot run iOS/Xcode verification. Physical
phone/tablet and screen-reader testing, broader Arabic shaping/diacritics review,
BM language review and store icon acceptance remain release checks. The source
package explicitly describes its vector redraws as baseline deliverables without
separate owner approval; its logo minimum sizes remain provisional device guidance.
No substitute artwork or invented approval is supplied.

## Manual review

Run flutter run in development to open the showcase:
1. Phone portrait: scroll all seven sections; confirm text, controls and artwork
   remain within the viewport. Repeat on a smaller phone.
2. Tablet: check portrait/landscape grid spacing and reading width.
3. Increase system text to 200%; repeat in English and Bahasa Melayu. Content
   should wrap and scroll, without clipped labels or overflow.
4. Press all four action variants; confirm counter changes. Disabled controls
   should do nothing. Preview loading should block another tap for 900 ms.
   Reset should return the counter to zero.
5. Hold/release a button: subtle compression, stable hit area and clear focus.
   Enable reduced motion; scale/interpolation should disappear while state remains.
6. Check all three logos, clear space and white compact mark on plum; compare
   primary redraw with the package reference. Check happy/curious Lumi without
   crop, tint, distortion or mirrored artwork.
7. Select/deselect the sample card; check text and checkmark. Change progress:
   40 → 50 → 100 → 0, with visible percentages and completion check.
8. Use TalkBack/VoiceOver and keyboard where available; check action labels,
   disabled/loading/selection state and percentage announcements.
