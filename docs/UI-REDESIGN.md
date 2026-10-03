# Lumio UI redesign

## Current revision — October 1, 2026

The owner requested a professional, modern, AI-inspired interface and delegated
the visual decisions. This revision supersedes the cream-and-cloud presentation
described in the historical Phase 3 notes below.

- Pearl canvas (#F7F8FC), ink text (#20253D), electric indigo actions (#5653D9),
  and restrained cyan accents. Original brand artwork and raw palette values
  are preserved; interface colors live in the semantic theme.
- Sora headings and Plus Jakarta Sans body text, with clear hierarchy and
  shorter English/Bahasa Melayu copy.
- `LumioTextField` retains native editing and validation inside a recessed
  surface with an icon tile and an indigo-to-cyan focus rim. Field labels stay
  visible; ages, avatars and languages retain selected semantics.
- Editorial onboarding, orbital Lumi illustrations, a more compact child home,
  a dark parent overview panel, and adaptive selected navigation capsules.
- Existing profile persistence, learning catalogs, progression and routes stay
  functional. AI is a visual direction, not a claim of a new AI service.

Verification: localization generation, Dart formatting, static analysis and
all 116 existing tests passed. Route captures cover phone/tablet layouts and
200% text in English and Bahasa Melayu. The Android debug build also passed.
Screen captures live under `verification/ui-redesign/` (ignored local outputs).

## Historical Phase 3 direction

Revised September 27, 2026 after the owner clarified that the original Lumio
screen concepts are the primary visual reference.

## Form and typography refinement

The owner's subsequent feedback explicitly replaces the old Nunito/Lexend UI
pairing. Sora now supplies 600–700 weight headings; Plus Jakarta Sans supplies
body text, form labels and actions. Original logo lettering is unchanged.
Both new variable fonts are bundled locally with OFL licenses; provenance and
SHA-256 hashes are recorded separately in `UI_FONT_SOURCES.json`. No runtime
font network request is required. Noto Sans Arabic remains the fallback.

Forms now use persistent wrapping labels above soft lavender filled inputs,
short localized hints and deliberate focus/error outlines. The default floating
labels and age/language dropdowns are removed. Ages 5–9 are direct single-choice
tiles with required-field validation; language uses labelled choices. Avatar
tiles form four columns on normal phones and two columns when space or enlarged
text requires it. Native text editing, keyboard focus, selected semantics,
validation and existing profile storage remain intact.

The new controls are shared by onboarding and profile editing. Verification:
all 87 tests pass, including runtime font registration and the adapted profile-creation interaction; the five
rendered layout checks also pass after the final avatar-spacing refinement.
Captures: `verification/ui-redesign/refined-forms.jpg`.

## Direction and source

Use `lumio-assets/brand/08-ui/concepts/` as the visual baseline: cream child
screens, bold rounded plum headings, purple actions, white rounded cards,
expressive original Lumi artwork, cloud motifs and a compact lavender parent
overview. External app references are secondary inspiration. The earlier
charcoal-button and floating-navigation direction is superseded.

Concept screenshots are design references, not executable screens or evidence
of real learning data. Their sample names, star balances and statistics must not
be presented as actual progress. Phase 3 still provides local onboarding,
profiles and navigation; games, rewards and learning analytics remain later work.

## Implemented screens

- Welcome: original purple-and-gold wordmark, bold headline, full-body Lumi on a
  cloud scene, a short introduction and one purple action.
- Setup and profile editing: the same cream, plum and purple controls, with
  existing validation, language selection and save/back behavior preserved.
- Child home: greeting, full-body Lumi, next-adventure card, prominent explore
  action and discovery cards. Worlds remain clearly labelled previews.
- Rewards: original celebrating Lumi and an honest empty state.
- Parent overview: saved child selector, compact summary cards, grouped subject
  rows, a first-discovery card, family settings and child-selection action.
  Unavailable learning statistics use dashes, with an explanation; none are
  fabricated. The selector opens the existing child-selection flow.
- Navigation: flat white phone navigation with purple selected icons and an
  underline; Adventure / Discover / My stars in the child shell and Overview /
  Profiles / Progress / Settings in the parent shell. Larger layouts use a rail.
- Nexura ownership appears once in Settings, not as a repeated footer.

## Reusable foundation

Child canvas is #FFFCF2; parent canvas is the original mist #F4F0FC. Primary
text is original plum #38234F. Buttons use original violet #7651D6 through
pressed violet #5F3DB3, white semibold Plus Jakarta Sans labels, leading icons, 20px corners
and a raised lower edge. Secondary actions have purple outlines. Minimum
interactive targets remain 56px.

Headings use Sora; body text uses Plus Jakarta Sans. Cards have natural
height, with 16px corners for compact parent groups and larger corners for
child content. Clouds are native vector decoration; the character remains the
original transparent PNG, never a screenshot crop or a reconstructed mascot.

`LumiScene`, `LumioSectionHeading`, `LumioTileGrid` and `LumioInfoTile` provide
shared compositions. `LumioCard` accepts colour and radius; `LumioActionSurface`
preserves focus, semantics, press feedback, loading and reduced-motion behavior.
English and Bahasa Melayu copy stays in the ARBs. Text scaling is not capped.

All 14 bundled brand asset/license files are byte-for-byte source copies,
tracked in `ASSET_SELECTION.json` with SHA-256. The colour wordmark, full-body
welcome mascot and celebrating reaction were added for this correction.

## Verification

- `flutter analyze --no-pub --fatal-infos`: no issues.
- `flutter test --no-pub --dart-define=LUMIO_CAPTURE_UI=true`: all 87 tests passed.
- Coverage includes existing SQLite/profile CRUD, startup, routing, deletion,
  unsaved changes, language isolation, reduced motion and accessibility checks.
- Layouts are exercised with actual bundled fonts, long nicknames, English and
  Bahasa Melayu, phone/tablet widths and 200% text.
- Android x64 debug APK built successfully with the new fonts, installed with
  data-preserving replacement, and reopened on `emulator-5554`. Static analysis
  reports no issues. APK: `build/app/outputs/flutter-apk/app-debug.apk`.
- Real Flutter widget captures: `verification/ui-redesign/`; the Aiman/Sofia
  profiles shown in screenshots are deterministic test fixtures.
- Contact sheet: `verification/ui-redesign/concept-aligned.jpg`.

Reproduce captures with:

```sh
flutter test test/ui_redesign_test.dart --dart-define=LUMIO_CAPTURE_UI=true
```

The local schema and profile repository are unchanged by this presentation
revision. Original and first-pass backups remain in `../lumio-ui-before/` and
`../lumio-ui-first-pass/`. Nothing was committed or pushed. iOS device checks
require macOS; physical-device screen-reader review remains a release check.
