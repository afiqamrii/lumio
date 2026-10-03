# Architecture — Phases 0–6

## Repository layout

```text
lib/
  main.dart
  app/                           bootstrap, font licenses, app/system-UI composition
  core/
    config/                      immutable public config and debug tool gates
    constants/                   selected runtime brand asset references
    errors/                      safe error classification
    routing/                     route definitions, provider-owned router, motion pages
    theme/                       existing palette/type/spacing/shape/shadow/motion system
    widgets/                     existing components, adaptive frame, honest placeholders
    design_system.dart           Phase 1 public component exports
  features/
    startup/presentation/        finite Flutter introduction
    foundation/presentation/     preserved Phase 0 holding screen
    dev/presentation/            mode chooser and preserved design showcase
    parent_shell/presentation/   parent destinations and real local management
    child_shell/presentation/    child destinations and selected local profile
    child_home/presentation/     profile/progression-aware Home and Rewards
    learning/domain/             subjects, skills, typed content and sessions
    learning/application/        cached catalog provider
    learning/data/               validated local JSON repository
    learning/presentation/       debug-only content browser
    progression/domain/         XP, stars, coins, unlocks and achievements
    progression/application/    explicit actions and per-child providers
    progression/data/           Drift and deterministic memory repositories
    adventure/                   world model/catalog, map, nodes and landing pages
    onboarding/presentation/     four-stage local setup
    profiles/                    domain, Drift repository, state and profile forms
    route_error/presentation/    friendly recovery
  l10n/                          English/BM ARBs; generated output ignored
  services/                      debug logging boundary
assets/brand/                    unchanged selected artwork/fonts/licenses
assets/content/                  curated per-subject learning catalogs
test/core/, test/design_system/, test/navigation/, test/profiles/, test/learning/
docs/                            design, navigation and verification records
android/, ios/, web/             existing platform scaffolds and launcher resources
lumio-assets/                    intact source-of-truth package
```

Phase 3 adds immutable local profiles, a repository boundary, a Drift database
and real setup state. Phase 4 adds a static world catalog and child presentation.
Phase 5 adds local progression through explicit application actions and normalized
Drift tables; it adds no games, cloud sync or backend
initialization. Shared widgets are
presentation infrastructure; mode-specific destinations remain inside their
own shells.

## Composition and lifetime

Main awaits bootstrap. Bootstrap validates AppConfig, installs the existing error
hooks, registers font licenses, opts Android into edge-to-edge and starts
ProviderScope. LumioApp uses the existing light theme/localization and annotates
system bars for readable dark icons on light brand surfaces.

The autoDispose router family now takes fixed immutable AppConfig instead of a
single preview Boolean. This necessary Phase 2 extension independently gates
navigation entry and design gallery. Both previews now require explicit debug opt-in; normal startup uses persisted local setup. Release/profile and production cannot register either development route.
Locale, responsive layout and lifecycle changes do not recreate the router.

BootstrapScreen's owned finite timer performs a presentation handoff only.
It cancels on disposal/non-resumed lifecycle and completes once on resume.
Incoming navigation removes startup and its timer; no deferred handoff can
overwrite a newer route. Actual local database loading occurs separately at /entry; there is no session authentication or fake API.

## Navigation boundaries

See [NAVIGATION.md](NAVIGATION.md) for paths/names, parameters, transitions,
back policy and future authentication/parental-gate integration.

Public routes use the root Navigator. Independent ShellRoutes create parent
and child Navigators. Each mode owns its destinations and callbacks; the shared
AdaptiveShellFrame handles layout, focus, semantics and reusable interactions.
Sections derive from the URI, using goNamed replacements without branch stacks.
Child context travels in the childId path parameter and survives tab changes,
rotation and resume. Its format check is not authorization.

Nested content has its own semantic container so the Navigator's route semantics
cannot hide the shell header/back control. The frame's PopScope handles section
back → mode home; Child Home exits to the real selector. Parent Home uses
ordinary platform exit, or returns to an explicitly enabled debug chooser.
A future gate coordinator can replace the development exit and protect router
boundaries; no current callback claims to be a security gate.

## Brand, layout and motion

The Phase 1 design system, assets and licensed offline fonts remain the source
for all styling. No duplicated palette or animation framework is added.
Navigation actions reuse LumioActionSurface, with 56px targets, selected state,
checkmark, visible focus and stable paint compression.

Parent mode uses calm white/mist; child mode uses cream/violet, larger existing
navigation labels and the selected child avatar. Width >=840 or short landscape uses a
scrolling rail; other layouts use four parent/three child bottom destinations.
Header captions, natural-height wrapped labels and bounded scrolling content
preserve system text scaling. Original content gutters/breakpoints remain.

Route pages use Phase 1 timing/easing through native Flutter fade, small slide or
scale. disableAnimations/accessibleNavigation removes these transitions.
Orientation remains unlocked; SafeArea protects system insets.
English/BM labels are generated from ARBs, with the existing Arabic font foundation.

## Error/logging boundary and verification

The existing AppError/AppLogger boundaries are preserved. Unknown routes use
curious Lumi, friendly localized text and a safe replacement action. Fixed debug
event/type/stack diagnostics remain; URLs/child values are not displayed or logged
as user messages. Actual go_router error state remains inspectable in the debugger.

Tests retain Phase 0/1 coverage and add startup, lifecycle, mode entry/sections,
replacement stacks, back behavior, header/selected semantics, malformed routes,
context retention, tool gating and scaled/rotated layouts. Recorded runtime
checks and platform limits are in [PHASE-3-VERIFICATION.md](PHASE-3-VERIFICATION.md).


## Phase 3 domain/data boundary

features/onboarding holds four-stage setup presentation. features/profiles contains domain models/interfaces, data/ProfileDatabase + generated schema + LocalProfileRepository, application/ProfileStore + activeChildProvider(id), and profile/selector/editor/settings presentation. See PROFILES.md.

The router listens to the profile snapshot through a small refresh bridge, preserving its instance and shell Navigators. Parent tabs remain independent of child state. Child routes supply the provider family identity; locale overrides cover child content without hiding shell header semantics. Setup consistency/missing-ID checks are not authentication.

Drift schema v1 has parent/child/setup tables, UUID identities, foreign keys and constrained catalogs. Initial setup is atomic. UI calls repository-backed store mutations; database APIs never appear in presentation. No old child session is automatically restored after restart. Future account linking/sync can replace the repository boundary with reviewed migrations while preserving IDs.

Verification now includes real SQLite rollback/corruption/file-reopen tests and end-to-end setup/CRUD/selection/restart/reset widget flows. Current records are in PHASE-3-VERIFICATION.md; previous phase reports remain history.
