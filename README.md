# Lumio

**Play. Learn. Glow.** A standalone product by **Nexura Labs**.

Flutter application for children aged 5–9, developed one tested phase at a time.
Phases 0–6 are complete. The repository now includes **Phase 6: Learning
Content & Skill Engine** with six subject catalogs, a validated skill graph,
typed local learning content, deterministic sessions and a debug catalog
browser. No actual learning games, cloud sync, purchases, advertising or
analytics are included.

## Quick start

Use Flutter 3.38.6 stable (Dart 3.10.7) or a compatible stable SDK.

```sh
flutter pub get
flutter run -d <device-id>
```

Android and iOS are the product targets; web is a local development smoke-test
target. iOS development requires macOS and Xcode.

- [Development workflow and phase acceptance](docs/DEVELOPMENT.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Brand asset assessment](docs/BRAND-ASSETS.md)
- [Design system](docs/DESIGN_SYSTEM.md)
- [Phase 3 UI redesign and verification](docs/UI-REDESIGN.md)
- [Navigation architecture](docs/NAVIGATION.md)
- [Profiles and local persistence](docs/PROFILES.md)
- [Phase 4 child experience](docs/CHILD_EXPERIENCE.md)
- [Phase 5 progression and rewards](docs/PROGRESSION.md)
- [Phase 5 verification](docs/PHASE-5-VERIFICATION.md)
- [Phase 6 learning engine](docs/LEARNING_ENGINE.md)
- [Learning content authoring](docs/CONTENT_AUTHORING.md)
- [Phase 6 verification](docs/PHASE-6-VERIFICATION.md)
- [Phase 4 verification](docs/PHASE-4-VERIFICATION.md)
- [Phase 3 verification](docs/PHASE-3-VERIFICATION.md)
- [Phase 2 verification history](docs/PHASE-2-VERIFICATION.md)
- [Phase 1 verification history](docs/PHASE-1-VERIFICATION.md)
- [Phase 0 verification history](docs/PHASE-0-VERIFICATION.md)
- [Original brand package](lumio-assets/README.md)

Permanent Android application ID and iOS bundle ID: **my.nexuralabs.lumio**.
The public product name remains **Lumio**.

Normal debug/release builds show a short introduction, then real first-run onboarding or child selection. The preview chooser/gallery require explicit debug flags. See docs/PROFILES.md and docs/NAVIGATION.md.

After `flutter pub get`, regenerate the database with `dart run build_runner build`.
On Windows x64, prepare the full test SQLite library once with `./tool/prepare-test-sqlite.ps1` before `flutter test`.

Phase 5 can run on the Android Pixel emulator. For an isolated local setup
preview, use `--dart-define=LUMIO_PROFILE_SANDBOX=true` in debug; see
[PROFILES.md](docs/PROFILES.md). Normal startup uses your ordinary local database.
