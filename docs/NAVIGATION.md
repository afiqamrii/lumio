# Lumio navigation — Phases 2–5

Phase 2 supplied separate shells and native motion pages. Phase 3 added real
local setup/profile routing. Phase 4 adds the child Adventure flow, and Phase 5
connects per-child progression without changing those route boundaries. See
PROFILES.md, CHILD_EXPERIENCE.md and PROGRESSION.md.

## Route definitions

AppRoutes contains immutable path/name pairs. Use goNamed/pushNamed with those
names and childParameters(id), rather than scattered strings or interpolated IDs.

| Path | Name / behavior |
| --- | --- |
| / | bootstrap: finite official-brand introduction |
| /entry | entry: actual local load/retry boundary, then state-based redirect |
| /onboarding | onboarding: four stages, atomic completion |
| /select-child | selectChild: existing profiles or add-child empty state |
| /parent | parent: redirects to parentHome |
| /parent/home | parentHome: local family greeting and selection/management actions |
| /parent/children | parentChildren: real add/edit/delete/selection |
| /parent/children/new | newChild: dedicated editor outside the tab shell |
| /parent/children/:childId/edit | editChild: dedicated editor preserving identity |
| /parent/progress | parentProgress: later-phase placeholder |
| /parent/settings | parentSettings: local parent/app info, debug-only confirmed reset |
| /child/:childId | child: redirects to the same child's home |
| /child/:childId/home | childHome: real greeting, Lumi hero and Continue Adventure |
| /child/:childId/adventure | childAdventure: connected six-world map |
| /child/:childId/adventure/:worldId | worldLanding: guarded world preview and future game-entry boundary |
| /child/:childId/worlds | legacy redirect to the same child's Adventure Map |
| /child/:childId/rewards | childRewards: real level, XP, stars, coins and achievements |
| /child-unavailable | childUnavailable: missing/deleted profile recovery |
| /lost | lost: branded route recovery specimen |
| /welcome | welcome: preserved Phase 0 holding screen, no longer normal launch |
| /dev | development: explicit debug preview chooser |
| /dev/design-system | designSystem: explicit debug Phase 1 gallery |

## Lifetime and redirects

The Riverpod autoDispose router family still owns one GoRouter per fixed AppConfig.
It listens to profileStoreProvider through a small ChangeNotifier refresh bridge;
profile updates refresh redirects without recreating the router or its stacks.
The provider and database have owned disposal. Layout/locale changes never create
new routing state.

The finite 700ms introduction hands off to /entry; local SQLite loading is real
work and has its own friendly loading/error/retry screen. A failed load does not
clear data. Normal startup chooses /onboarding if incomplete, otherwise
/select-child. It never resumes the previous child session automatically.

Parent/child/selector/editor links require loaded, completed local setup. Child
and editor IDs must exist in that snapshot. Structurally malformed IDs recover
to /lost; missing/deleted IDs recover to /child-unavailable. These are local
consistency checks, not authentication or an implemented parental gate.

## Separate shells and back behavior

Public routes and form editors use the root Navigator. ParentShell and ChildShell
retain separate ShellRoute Navigators. Each mode owns destinations/callbacks;
AdaptiveShellFrame shares responsive layout only. Section selection is URI-driven.
goNamed replaces sections; repeated taps do not grow duplicate tab stacks.
Only the optional design gallery uses pushNamed from the chooser.

Parent sections: Home, Children, Progress, Settings. Back from a non-home section
returns to Parent Home. In normal mode, Home retains platform exit behavior;
explicit debug preview can return to the preview chooser.

Child sections: Home, Adventure, Rewards. Back from a section returns to that
child's Home. A World Landing page is pushed from Adventure, so back first
returns to the map. Home's clearly labeled Exit Child Mode and OS back return
to the selector. This callback is the future parental-gate boundary. A later
gate must also protect direct parent routes. No PIN/challenge is present now.

Editors return to Children; changed drafts require discard confirmation and
saving temporarily disables navigation. Deletion always confirms. Removing the
final child leaves a usable add-child state, with parent/setup preserved.
Onboarding back moves to the previous stage without discarding the draft.

## Active identity and future details

ChildShell reads activeChildProvider(childId). Route identity is authoritative;
there is no singleton mutable selection or persisted old session. Its child
language applies to content and navigation while parent language remains separate.
Localized content is isolated from header semantics so the mode/back controls
remain available to assistive technology.

IDs are bounded ASCII opaque route identifiers; persisted child IDs are UUID v4.
Use explicit named parameter maps. World IDs come from the stable catalog and
availability is evaluated from the active child's progression snapshot. Future
`/child/:childId/game/:gameId` routes remain intentionally
absent. Future account
readiness/ownership checks belong in the top-level redirect and reviewed domain
state, not in widgets or display names. Cloud linking must preserve local IDs.

## Responsive presentation, transitions and lifecycle

Width >=840 uses a scrolling side rail. Short landscape (width > height,
height <600) also uses the rail; other layouts use bottom destinations. Bounded
720px scrolling surfaces keep tablet content readable. Profile grids use two
columns only when content width >=600; otherwise one. SafeArea, unlocked
orientation and existing gutters/breakpoints remain.

Phase 1 durations/easing supply public fade, parent subtle slide/fade and child
small scale/fade. Reduced motion/accessibleNavigation removes transitions.
Selected navigation retains its destination icon with a check marker and semantic state. The redesigned phone dock scrolls horizontally with enlarged text; desktop/short-landscape rails scroll vertically. Presentation details are in UI-REDESIGN.md.
Forms/confirmation dialogs scroll at large text scales and labels are not capped.

Bootstrap owns/cancels its finite timer on pause/disposal and hands off once after
resume. Incoming navigation cannot be overwritten by a stale timer. Profile writes
are transactional; there is no session refresh/backend lifecycle work.

Android edge-to-edge and app-level light system-bar styling from Phase 2 remain.
SafeArea protects controls. iOS gestures/system bars require device review on macOS.
See [Flutter PopScope API](https://api.flutter.dev/flutter/widgets/PopScope-class.html)
and [edge-to-edge guidance](https://docs.flutter.dev/release/breaking-changes/default-systemuimode-edge-to-edge).

## Development entry

Both preview flags now default false. Normal debug and release use real profiles:

```sh
flutter run
# Explicit Phase 2 chooser:
flutter run --dart-define=LUMIO_NAVIGATION_PREVIEW=true
# Explicit Phase 1 gallery:
flutter run --dart-define=LUMIO_DESIGN_PREVIEW=true
```

Release/profile and production never register development routes, even with
flags true. The preview chooser's parent/child buttons use real setup and selector
routes. The old synthetic preview child context is removed. Debug non-production
Settings offers a confirmed local reset; release has no reset control.

`/dev/learning-content` is registered only when debug tools are enabled. It is
available from Parent Settings and, with navigation preview enabled, from the
development entry screen. Release/profile and production routers do not expose
it.

## Recovery and verification

Unknown routes retain curious Lumi and a safe Back to Lumio action, returning
through /entry. Fixed debug error/type/stack diagnostics remain available without
showing raw paths, names or exceptions to users. Local-load errors use explicit
retry and never silently replace saved data.

Tests cover prior shell/lifecycle behavior plus setup guards, real profile
selection, child Home → Adventure → World Landing, temporary locks,
deleted/malformed IDs, locale isolation and scaled/rotated layouts. See
CHILD_EXPERIENCE.md and PROGRESSION.md for Phase 4–5 decisions.

For an isolated native onboarding/CRUD/reset preview, use the debug-only
`LUMIO_PROFILE_SANDBOX=true` flag documented in [PROFILES.md](PROFILES.md).
