# Lumio Brand Guideline v2

26 September 2026. Current project baseline.

## Brand idea

Lumio is a playful educational game for children aged 5-9. Lumi is a curious companion. The brand is playful, thoughtful and confident. Encourage effort, use natural stopping points, and avoid shame or pressure to return. Tagline: Play. Learn. Glow.

## Logo use

Use brand/09-production/logos for editable SVGs and PNG exports. Primary is the integrated-o logo; wordmark and small-UI alternate cover tighter spaces. Color, black, white, plum and reverse-color variants included. Keep 0.25 times the o height clear around all artwork. Starting widths: 240/120/80 logical px, still subject to device review. No distortion, rotation, added effects or retyped lettering. Vector redraws deliberately flatten source shading; selected PNG references remain for comparison.

## Color

Exact palette and functional shades: brand/05-colors/lumio-colors.json and .css. Violet #7651D6, Gold #FFD34E, Turquoise #20C8C4; supporting Lilac #B8A0F2, Aqua #65E1D6, Coral #F47B7F, Leaf #43C59E; Plum #38234F, Cream #FFF4D9, White #FFFFFF, Mist #F4F0FC, Slate #6A6275. Functional pressed #5F3DB3, success #216E53, attention #8A5700, error #A53345. White/violet 5.36:1; plum/gold 9.65:1; plum/turquoise 6.65:1. Never use white normal text on gold or turquoise. Pair color with icons and text. Contrast source: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html

## Typography

Use bundled Nunito 700-800 for display, Lexend 400-600 for English/BM UI and Noto Sans Arabic 400-600 for Arabic. Files are unmodified variable TTFs with original OFL licenses, metadata and source hashes. Starting sizes/line heights: title 32/40, section 24/32, child instruction 20/30, choice 18/26, parent body 16/24, metadata 14/20; Arabic 22/36. Test engine font support, shaping, diacritics, RTL and text scaling. Specimen: brand/09-production/fonts/specimen.html. Sources: https://github.com/google/fonts/tree/main/ofl/nunito ; https://github.com/google/fonts/tree/main/ofl/lexend ; https://github.com/google/fonts/tree/main/ofl/notosansarabic

## Character source

brand/09-production/character/lumi-layered.svg is a hand-authored flat redraw, with 18 named editable groups, individual part SVGs, a monochrome silhouette and rig-map.json. Parts are fully closed and overlap behind joints. Original selected full-body PNG stays in brand/01-mascot/approved. The new SVG is a redraw with small contour differences. This is an animation source kit, not a native engine bone rig. Use small rotations around supplied pivots; large pose extremes need extra drawing.

## Reactions

Nine separate RGBA PNGs: happy, excited, curious, thinking, surprised, proud, confused, sleepy and celebrating. Files, usage manifest and preview are in brand/06-character/reactions. These are static torso-up illustrations with minor pose/scale variation, not a frame atlas. Keep aspect ratio and contain sizing. Confused is Lumi exploring, never judging the child; sleepy invites a break; proud recognizes effort.

## Motion

Press 80-120ms; answer feedback 200-350ms; transition 220-320ms; reaction 500-900ms; milestone 800-1200ms. A finite 900ms wave/nod/tail HTML/SVG study is included in brand/09-production/character/motion-preview.html. Reduced motion disables that animation. Use text/icons for essential feedback; keep hit areas stable and let celebrations settle. No camera shake, strobing or endless loops. Runtime rigs and game integration are future implementation work.

## Sound and voice

Five original 44.1kHz mono 16-bit WAV prototype cues: startup 0.8s, correct 0.3s, retry 0.18s, reward 0.75s, transition 0.18s. No recordings or third-party melodies. Peak levels checked; mixing and device listening remain part of implementation. Audio preview and manifest: brand/09-production/audio. Do not stack cues; reward supersedes correct. Provide independent effects/voice controls. No human voice/narration files. Keep all essential feedback visible. Copy: You found it! Good try. Let’s look again. What do you notice? Ready for a little break?

## App icons

brand/09-production/icons includes iOS AppIcon.appiconset (1024 opaque RGB) plus legacy sizes, Android 48dp legacy density PNGs, separate 108dp foreground/background and monochrome density layers, v26/v33 adaptive XML, 512px store image, and web favicons/PWA icons/manifest. Adaptive foreground was newly generated from the approved wink and fitted to a 63.8dp protected diameter. Apple uses the flat asset-catalog route, not Icon Composer. Export checks are complete; platform compilation and device review are not. Sources: https://developer.apple.com/documentation/xcode/configuring-your-app-icon ; https://developer.android.com/develop/ui/compose/system/icon_design_adaptive

## UI concept

Four PNG mockups and interaction notes: brand/08-ui/concepts. Adventure home, counting activity, activity complete, parent overview. Child UI: one task, short instructions, large choices and clear progress. Use 56x56 logical-pixel child touch targets as a starting point, tested in the real device layout. Parent UI: calm white/mist surfaces, labeled progress and plain language. Fictional demo data. Support sound-off, reduced motion, text scaling, focus and Arabic RTL. Provide natural stopping and parent-controlled purchasing. These are visual mockups, not a working app or final accessibility audit.

## Illustration and worlds

Use simple rounded silhouettes and flat/cel color. Number Kingdom: exact math objects; Word Woods: readable letter/story objects; Language Village: reviewed everyday BM examples; Arabic Oasis: culturally reviewed scenes and accurate script; Logic Lab: clear cause/effect; Discovery Island: factual nature/science. These are world directions, not completed levels or lesson content.

## Handoff

This package completes the requested brand/design baseline: references, editable logo family, monochrome/reverse variants, icon exports, palette, font files/licenses, nine separate reactions, layered mascot parts/pivots, motion study, prototype sound kit, guidelines and UI concepts. Game code, playable lessons, engine-specific rigging, human voice, device testing and app-store submission are implementation work. START-HERE.html is the index. game-structure/ is reserved for the user’s architecture. V2 supersedes V1. New vector/export assets are authored baseline deliverables, not a claim of separate user approval or store readiness.
