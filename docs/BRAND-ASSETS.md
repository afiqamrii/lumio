# Supplied brand package assessment

Source: `lumio-assets/`. The package README and guideline v2 supersede older
concept/stage notes. The original files and directory names are preserved.

## Findings and Phase 0 use

| Area | Source | Finding / current integration |
| --- | --- | --- |
| Palette | brand/05-colors/lumio-colors.json | Exact sRGB palette and semantic/functional roles transcribed into Dart. |
| Contrast | brand/05-colors/contrast-checks.json | White/violet passes normal-text contrast; turquoise/gold need plum text. |
| Logo | brand/09-production/logos | Transparent production PNG integrated into the shell; aspect ratio and surrounding clear space retained. |
| Typography | brand/09-production/fonts | Licensed Nunito, Lexend and Noto Sans Arabic variable TTFs bundled directly; original OFL files included. |
| Android icon | brand/09-production/icons/android/res | Provided legacy, v26 adaptive and v33 monochrome resources copied into the native app. |
| iOS icon | brand/09-production/icons/ios/AppIcon.appiconset | Provided universal 1024px catalog copied into Assets.xcassets; Xcode/device checks need macOS. |
| Web icon | brand/09-production/icons/web | Provided favicon and 192/512px icons used for local preview. No unverified maskable claim. |
| Mascot | brand/01-mascot/approved and brand/09-production/character | Original reference, 18-part redraw and rig map retained; no runtime animation or Flame added. |
| Reactions | brand/06-character/reactions | Nine static transparent reactions retained; not a frame atlas. |
| Sound | brand/09-production/audio | Five prototype cues retained; no sound playback added. |
| Screen concepts | brand/08-ui/concepts | Four visual mockups retained as later-phase reference; no finished screen implementation. |
| Game structure | game-structure/README.md | Reserved placeholder, not an existing game engine/app. |

## Authority and remaining review

The palette JSON retains an older “proposed palette for approval” status. The
newer package README and guideline v2 explicitly identify these exact values as
the current project baseline; Phase 0 follows that baseline. No sampled or
invented colors are used.

Production vectors/export redraws intentionally simplify shading and contours;
the package says they do not establish separate owner approval. Phase 0 uses
the documented production export without modifying any source artwork. Compare
the installed result with approved PNG references before a release.

The package validates file structure and exports, not store acceptance or a full
accessibility audit. Variable-font rendering, Arabic shaping/diacritics, adaptive
icon masks, iOS assets, and logo minimum sizes require device review.
BM shell strings are a minimal implementation translation; obtain language review
before publishing child-facing content.

Initial manifest check: all **244 listed files** matched SHA-256. Re-run the
non-mutating check from the repository root:

```powershell
./tool/verify-brand-assets.ps1
```

This script checks the supplied MANIFEST.json; it never rewrites the package.

## Phase 1 integration

The Phase 0 table is historical. Runtime assets now use byte-identical copies under assets/brand. Three production SVG logo variants replace the shell PNG reference; happy and curious static mascot reactions are added. The same three variable fonts and their licenses are relocated into the explicit runtime asset structure. Native icons and the entire source package remain unchanged. See docs/ASSET_SELECTION.json for all 11 paths and hashes, and docs/DESIGN_SYSTEM.md for component contracts and source authority. No other brand source files enter the Flutter bundle.

## Phase 3 current manifest audit

The current folder contains 214 of the 244 files referenced by the original
manifest; all 214 hashes match. Thirty legacy concept/reference paths are
absent, whereas earlier phase audits recorded them as present. Cause and timing
are unresolved. All 11 selected runtime assets still match their source bytes
and recorded hashes. No source artwork or manifest was edited to resolve this.
See [PHASE-3-VERIFICATION.md](PHASE-3-VERIFICATION.md).
