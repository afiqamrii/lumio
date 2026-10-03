# Baseline validation - 26 September 2026

- Nine reaction PNGs checked for 1254 x 1254 dimensions and real transparency.
- SVG sources parsed and checked for real geometry, with no embedded raster images.
- Eighteen individual SVG and PNG parts share one coordinate frame; pivots and draw order are mapped.
- iOS source is 1024 x 1024 RGB and opaque. Asset-catalog filenames resolve.
- Android density sizes and XML resource references resolve. Color and themed foreground pixels stay inside the 66dp protected circle. Web icon dimensions and manifest included.
- All three font families have valid TTF headers, original OFL licenses and source metadata.
- Five audio files checked as mono 16-bit PCM at 44.1kHz; synthesis manifests record unclipped peaks.
- Twelve-page PDF rendered and visually reviewed for layout, clipping and text readability. Current guide matches delivered assets.
- Small logo previews and monochrome/dark-background previews rendered for visual review.
- Start Here and local specimen/motion/audio links resolve.

## Practical limits

Static reactions vary slightly in pose scale and are not animation frames. Vector sources are authored redraws, not exact traces. No native engine rig is included. Motion is a replayable HTML/SVG source study. Sound cues need final mixing/listening in the game. App icons have export/resource checks but have not been compiled in Xcode/Android Studio or tested on launcher devices. UI screens are concepts, not implemented screens. Real-device minimum sizes, full accessibility, Arabic/curriculum review and app-store submission happen during the build.
