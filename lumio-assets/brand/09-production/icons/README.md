# Lumio platform icon exports

## iOS
Import `ios/AppIcon.appiconset` into Assets.xcassets. It contains a 1024 x 1024 opaque RGB PNG and single-size universal iOS Contents.json. Xcode can generate smaller appearances. `ios/legacy-sizes/` contains optional older pixel sizes; do not import them as a second primary icon set. This is the flat asset-catalog route, not an Icon Composer .icon file; dark/clear/tinted appearances need platform-specific design and device review if adopted.

## Android
Copy `android/res/` into the Android app's res directory. Set `android:icon="@mipmap/ic_launcher"` in the application manifest. Legacy PNGs cover mdpi through xxxhdpi. Adaptive v26 resources have separate 108dp foreground/background layers; v33 adds a monochrome layer. Color foreground comes from a transparent re-creation of the approved wink pose; it has small contour differences from the original PNG. Important foreground pixels fit inside a 63.8dp diameter circle within the 66dp protected region. The themed icon uses the vector Lumi silhouette. Background extends to all edges. Circle preview is for review, not a launcher asset.

`android/store/` contains the 512px listing image, which uses the original approved artwork. Adaptive foreground, background and monochrome 1080px sources are included for editing.

## Web
16/32/48px flame favicons; 180px touch icon; 192/512px mascot icons and a starter webmanifest. Update start_url, scope and deployment URLs when installing into a real app. PNG favicons can be linked directly; no ICO is required by this baseline.

## Validation scope
Pixel dimensions, alpha, resource names and protected-region coverage are checked. Xcode compilation, Android builds, launcher devices, actual appearance and store upload have not been run. Device checks belong to game integration. Sources checked 2026-09-26:
- https://developer.apple.com/documentation/xcode/configuring-your-app-icon
- https://developer.android.com/develop/ui/compose/system/icon_design_adaptive
