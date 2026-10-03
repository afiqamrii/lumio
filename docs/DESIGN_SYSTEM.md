# Lumio Design System

Lumio is the public product. “Play. Learn. Glow.” is its tagline. Nexura Labs is
the owner, credited once in Settings. Ownership is not a repeated page footer. Both platform IDs
remain `my.nexuralabs.lumio`. This phase supplies reusable presentation only.

## Current presentation direction

The October 1, 2026 owner request establishes a professional AI-inspired
interface. Original brand assets remain the character and identity reference;
the current UI uses a separate semantic palette. Read
[UI-REDESIGN.md](UI-REDESIGN.md) for the revision and verification history.

- Pearl canvas #F7F8FC, ink text #20253D, secondary text #646B80.
- Indigo gradient actions (#5653D9 to #3C39AD), semibold 16px labels, leading
  icons, 18px corners and soft elevation. Minimum interactive target: 56px.
- White surfaces with fine borders, a midnight parent overview panel, and
  adaptive navigation with selected indigo capsules.
- Original full-body Lumi on orbital scenes; original celebrating reaction.
- Recessed text fields use native editing, icon tiles and an illuminated focus
  rim. Persistent labels, errors and choice semantics remain accessible.
- Sora headings and Plus Jakarta Sans reading text (owner-requested font revision). Natural-height layouts
  support large text; enlarged phone navigation scrolls horizontally.
- Progression uses stored values; unimplemented learning analytics remain
  clearly marked as coming soon. Do not invent statistics or AI capabilities.
- Shared focus, reduced motion, screen-reader behavior and localization remain
  required. Source artwork and original raw brand colours remain intact.

The owner-requested font revision overrides the original Latin font roles below.
Sora and Plus Jakarta Sans are separately bundled under `assets/ui/fonts/`, with
licenses and provenance in `UI_FONT_SOURCES.json`. Original brand fonts remain
archived in the bundle; the app uses the new pair and Noto Sans Arabic fallback.

## Brand authority and selected assets

The intact source is `lumio-assets/`. Read its README, MANIFEST.json, CHECKS.md,
CHECKS.json and START-HERE.html alongside
`brand/07-guidelines/Lumio-Brand-Guideline-v2.md`. V2 supersedes V1 and earlier
stage/concept notes. The palette JSON’s older “proposed” status does not override
the newer README/v2 designation of these exact values as the project baseline.

Only these source files enter Flutter's `assets/brand/` bundle:

| Source relative to lumio-assets/ | App use |
| --- | --- |
| brand/09-production/logos/lumio-primary-color.svg | Full integrated-o identity, LumioLogo.primary |
| brand/09-production/logos/lumio-wordmark-plum.svg | Monochrome wordmark, LumioLogo.wordmark |
| brand/09-production/logos/lumio-wordmark-color.svg | Default purple-and-gold app wordmark |
| brand/09-production/logos/lumio-small-ui-white.svg | Compact reverse mark on a plum/dark surface |
| brand/06-character/reactions/lumi-happy.png | LumiMascot.happy |
| brand/06-character/reactions/lumi-curious.png | LumiMascot.curious |
| brand/01-mascot/approved/lumi-mascot-reference.png | Full-body welcome scene, LumiMascot.welcome |
| brand/06-character/reactions/lumi-celebrating.png | Rewards empty state, LumiMascot.celebrating |
| brand/09-production/fonts/nunito/Nunito[wght].ttf + OFL.txt | Nunito display and headings |
| brand/09-production/fonts/lexend/Lexend[wght].ttf + OFL.txt | Lexend English/BM text and numerals |
| brand/09-production/fonts/notosansarabic/NotoSansArabic[wdth,wght].ttf + OFL.txt | Arabic fallback and specimen |

`docs/ASSET_SELECTION.json` records all 14 source/destination pairs and SHA-256.
The files are byte-for-byte copies, with no format conversion. Pubspec registers
each needed image/license and the three font families explicitly. Licenses are
also registered with Flutter's LicenseRegistry during bootstrap.

Production vectors are the package's authored baseline; they flatten source
shading and differ slightly from approved PNG references. Their selection follows
v2; it does not assert separate owner approval of redraws or store acceptance.
The mascot reactions are original separate static PNGs, not rig parts or animation
frames. Layered character sources, other poses, audio and screen mockups stay out
of the app bundle. Native launcher icons selected in Phase 0 are unchanged.

Logos preserve original colors, aspect ratio and lettering, without RTL mirroring,
effects or retyping. LumioLogo reserves 6% of rendered width on every edge, at
least the v2 clear-space rule of 0.25 × the o height for these exports.
Default rendered widths are 240/140/140/96 logical pixels for primary,
plum wordmark, colour wordmark and compact variants. V2's starting widths
240/120/80 remain provisional device-review guidance. Constrained previews may
shrink a specimen to fit; production layouts should select a compact variant
rather than squeeze a full lockup into a small control. Reverse white belongs
on a dark surface. LumiMascot uses contain, retains transparent padding and
never crops, recolors or mirrors Lumi.

## Color tokens

`LumioPalette` is raw source color data; `LumioColors` is the semantic API.
Raw values belong only in the palette declaration. Decorative palette colors
are not automatically accessible text or status colors.

| Raw token | sRGB hex |
| --- | --- |
| violet | #7651D6 |
| gold | #FFD34E |
| turquoise | #20C8C4 |
| lilac | #B8A0F2 |
| aqua | #65E1D6 |
| coral | #F47B7F |
| leaf | #43C59E |
| plum | #38234F |
| cream | #FFF4D9 |
| white | #FFFFFF |
| mist | #F4F0FC |
| slate | #6A6275 |
| violetPressed | #5F3DB3 |
| successInk | #216E53 |
| attentionInk | #8A5700 |
| errorInk | #A53345 |

| Semantic role | Raw mapping / use |
| --- | --- |
| primary / onPrimary | violet / white: main action |
| primaryContainer / primaryPressed | mist / violetPressed: selection surface / pressed action |
| secondary / onSecondary / secondaryContainer | turquoise / plum / aqua |
| accent, glow / onGlow | gold / plum: visual glow accent |
| background | canvas: calm almost-white page |
| surface, surfaceElevated | white: content containers |
| surfaceSubtle | mist: grouping and progress track |
| textPrimary | plum |
| textSecondary, textMuted | slate; muted does not reduce contrast |
| success / warning / error | successInk / attentionInk / errorInk |
| info / infoContainer | plum / turquoise |
| outline / outlineSubtle | slate / mist; subtle outline is decorative |
| disabled / onDisabled | mist / slate; disabled actions also expose semantic state |
| focusRing | plum: visible keyboard focus |
| transparent | transparent paint, not a new brand color |

White on violet is the approved primary pairing. Gold/turquoise need plum text,
not white normal text. Status badges include a label and icon; selected cards add
a checkmark. No star/coin economy or associated business semantics are introduced.

There is one approved light theme. `LumioTheme.light` sets explicit ColorScheme
roles, TextTheme, scaffold, native button/input/card/progress defaults and text
selection. No seed-generated palette or invented dark mode is used. Future dark
support should supply a separately reviewed ThemeData/semantic mapping and
migrate contextual consumers deliberately; current static tokens represent light
only. Input defaults are style foundations, not authentication forms.

## Typography

All fonts are supplied variable TTFs with original SIL OFL licenses. No font
download or network font service is used. Explicit weight axes request original
font weights instead of relying on synthetic bold.

| Role | Family / weight | Size / line height |
| --- | --- | --- |
| displayLarge | Nunito 800 | 40 / 48 |
| displayMedium | Nunito 800 | 32 / 40 |
| headingLarge | Nunito 700 | 32 / 40 |
| headingMedium | Nunito 700 | 24 / 32 |
| headingSmall | Nunito 700 | 20 / 28 |
| bodyLarge | Lexend 400 | 20 / 30 |
| bodyMedium | Lexend 400 | 16 / 24 |
| bodySmall | Lexend 400 | 14 / 20 |
| labelLarge | Lexend 600 | 18 / 26 |
| labelMedium | Lexend 500 | 14 / 20 |
| numberLarge | Lexend 600, tabular figure feature | 48 / 56 |
| arabicBody | NotoSansArabic 400 | 22 / 36 |

V2 provides the 32/40, 24/32, 20/30, 18/26, 16/24, 14/20 and Arabic 22/36
starting roles. Larger display/numeral roles and the small heading are Phase 1 UI
extensions within the approved font families, not additional brand specifications.
Use named styles or Theme.of(context).textTheme; do not scatter font sizes.
Text wraps and respects the system TextScaler, including 200% tests. Clear
numerals are demonstrated in the showcase. Do not assume every font supports every
OpenType feature; retain readable proportional numerals if tabular figures fall
back on an engine.

English and Bahasa Melayu are localized through existing ARBs. NotoSansArabic
fallback, directional layout and an isolated RTL font specimen leave room for
Arabic later. Arabic UI localization, shaping/diacritics and language review are
not implemented by this phase. The specimen is not learning content.

## Spacing and shapes

Spacing is a deliberately small scale: xs 4, sm 8, md 16, lg 24, xl 32, xxl 48
logical pixels. `childTouchTarget` is 56, separate from spacing hierarchy.

Radius: small 12 (small containers/inputs), medium 20 (buttons), large 28 (cards)
(larger feature surfaces), pill 999 (progress/badge shapes); circular avatar
frames use a circle. Do not make every surface a pill.

These spacing/radius values are Phase 1 implementation decisions; v2 describes
rounded friendly UI but does not mandate a numeric scale. Hierarchy comes from
layout/type and surfaces, with restraint in rounding.

Shadows derive only from plum: card alpha 0.06, blur 16, offset (0,4); floating
alpha 0.10, blur 24, offset (0,8). Lists are immutable. Static cards opt into a
soft shadow; native cards remain elevation zero. Dialog/reward effects are not
invented before those components exist.

## Motion foundation

| Token | Duration | V2 range / purpose |
| --- | --- | --- |
| fast | 100 ms | 80–120: press/release |
| standard | 260 ms | 200–350: feedback/card selection/progress |
| transition | 280 ms | 220–320: future page transition |
| slow | 700 ms | 500–900: future mascot reaction |
| reward | 900 ms | 800–1200: future finite celebration |

Phase 2 adds shared pageScale (0.985) and pageSlide (0, 0.02) amplitudes to LumioMotion for startup/navigation; duration and reduced-motion policy are unchanged.

Default easing is Flutter's easeOutCubic. An enabled button/card compresses its
painted surface to 0.97 on press; its actual InkWell, semantics and hit target
never scale. Press/focus/hover changes remain visible; layout geometry is stable.
Progress updates interpolate to the new fraction. The showcase loading sample
finishes after 900 ms and cancels its timer on disposal.

Use `LumioMotion.duration(context, token)` and `LumioMotion.reduced(context)`.
Both disableAnimations and accessibleNavigation request reduced motion.
Reduced motion uses zero-duration transitions, no press scale, and a static
hourglass for loading. Functionality and accessible loading status remain.
The showcase switch can add reduced motion but cannot override a system request.

Future page transitions should be short and preserve orientation; future reactions
and celebrations must be finite and settle. No camera shake, flashes, endless
decorative loops, sound-only feedback or large animation rigs. Motion tokens do
not implement route animation, character logic or reward behavior.

## Reusable components

Import `package:lumio/core/design_system.dart` for public presentation primitives.

| Component | Contract |
| --- | --- |
| LumioButton | primary/secondary/outline/ghost; nullable callback disables; isLoading blocks activation and announces loading; optional icon |
| LumioIconButton | required descriptive label, tooltip, enabled/disabled callback |
| LumioCard | static or interactive; interactive requires semanticLabel; selection exposes state and checkmark; optional restrained static elevation |
| LumioProgressBar | labeled fraction; finite values clamp to 0–1, non-finite values render zero; localized percentage, completion check, no progression logic |
| LumioBadge | neutral/info/success/warning/error/glow label with icon; purely presentational |
| LumioAvatarFrame | circular visual container and required label; no child/profile data |
| LumioLogo | official primary/wordmark/compactReverse SVGs with configurable width and semantic name |
| LumiMascot | official happy/curious static assets with configurable size and semantic description |
| LumioScaffold | brand background + SafeArea + bounded responsive scrolling content |

An internal LumioActionSurface shares keyboard, focus, semantics and stable-target
press behavior; application features should use public components. LumioScaffold
uses Phase 0 breakpoints 600/840, 24/40 gutters and a default 720 max reading width.
The development showcase opts into 1120 and natural-height grids. Layout uses
available constraints, not device names, fixed tile heights or locked orientation.

Example:

```dart
LumioButton(
  label: localizedLabel,
  icon: Icons.check_rounded,
  onPressed: isAvailable ? onConfirm : null,
  isLoading: isSaving,
);

LumioCard(
  child: Text(localizedBody, style: LumioTypography.bodyMedium),
);

LumioProgressBar(value: fraction, label: localizedProgressLabel);
```

DO: `LumioColors.primary`, `LumioSpacing.md`, `LumioTypography.bodyMedium`.

DON'T: `Color(0xFF...)`, arbitrary repeated padding/font sizes, or copied component
styling when a semantic token/component exists. A deliberate exception belongs
in a reviewed token, not an ad hoc screen.

Do not tint logos, crop/mirror Lumi, import the whole source package, synthesize
new assets, add animation dependencies for trivial transitions, cap text scaling,
use color alone for state, or add later-phase business state to these components.
Do not place technical token names in future child-facing flows.

## Accessibility expectations

- Child buttons/icon actions/interactive cards have at least 56 × 56 logical targets.
- Descriptive labels are required for icon actions, avatar frames and actionable
  cards. Loading is a live status; disabled actions have no semantic tap callback.
- Keyboard focus is visible and Enter activates the same action as touch.
- Use approved foreground/background pairs and meaningful outlines. Mist borders
  are decorative, not sufficient by themselves to identify an input/action.
- Content can wrap, scroll and scale; do not impose fixed-height text containers.
- Directional padding/alignment supports future RTL; brand artwork is not mirrored.
- Sound is absent; all sample states use visible text/icons and semantics.
- Test on actual phone/tablet hardware with platform screen readers before release.
  Automated contrast/touch checks are foundations, not a full accessibility audit.

## Development preview and verification

Phase 2 preserves this gallery at /dev/design-system. Debug development/staging builds open the mode chooser, which links to it. To open only the gallery after startup, run flutter run --dart-define=LUMIO_NAVIGATION_PREVIEW=false. Disable both preview flags to use the holding screen. Release/profile and production builds now reject all development routes, even with explicit preview flags; this supersedes the Phase 1 release-preview exception. See docs/NAVIGATION.md. Showcase state remains local demonstration state only.

```sh
flutter pub get
dart format lib test
flutter analyze --fatal-infos
flutter test
flutter build apk --debug
```

Run `./tool/verify-brand-assets.ps1` to verify all 244 source-manifest hashes.
Tests compare all 11 imported files with source bytes, decode every SVG/PNG,
guard exact palette values, initialize the theme and exercise interaction,
semantics, contrast and scaled phone/tablet layouts. Read
`docs/PHASE-1-VERIFICATION.md` for recorded device/browser results and limits.

Phase 3: both preview flags now default false. Opt into the gallery with LUMIO_DESIGN_PREVIEW=true; normal launches use real onboarding/selection. Profile symbols reuse LumioAvatarFrame and the existing palette. No original brand asset changed. See PROFILES.md.
