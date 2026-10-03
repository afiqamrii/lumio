# Lumio typography

Bundled unmodified variable TrueType fonts: Nunito (display 700-800), Lexend (Latin UI/learning 400-600), Noto Sans Arabic (Arabic 400-600). Each folder contains its original OFL.txt and Google Fonts metadata. `sources.json` records download locations and SHA-256 fingerprints. Preserve licenses when redistributing.

Load `fonts.css` for web prototypes; `specimen.html` works locally. For native/game-engine use, import the .ttf files through that engine's font pipeline; export static instances if it cannot handle variable fonts. The custom wordmark is separate SVG geometry.

Starting scale in logical px: title 32/40, section 24/32, child instruction 20/30, choice 18/26, parent body 16/24, metadata 14/20. Arabic starts at 22/36 and needs content-specific diacritic/RTL checks. Do not imply any font by itself guarantees reading accessibility.
