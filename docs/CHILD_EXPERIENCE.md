# Child experience — Phases 4–5

Phase 4 replaces the child placeholders with Lumio's first complete child-facing
journey: Home → Adventure Map → World Landing. Phase 5 adds real local
progression and rewards while still stopping before games and questions.

## Child Home

`ChildHomeScreen` receives the route `childId` and watches the existing
`activeChildProvider(childId)`. The greeting and avatar always come from the
active local `ChildProfile`; there are no demo names or fabricated progress
values. Phase 5 adds the active child's real level, XP, stars and coins.
Continue Adventure opens the map. Adventure and Rewards shortcuts keep
the three-destination child experience obvious.

Phone layout stacks greeting, Lumi hero, CTA and shortcuts. At 720 logical
pixels the hero and shortcuts compose side by side. Long names use two bounded
lines, while the page remains vertically scrollable at system text sizes.

## Adventure Map

`AdventureMapScreen` is a vertically scrollable connected journey, rather than
a subject grid. `AdventurePath` paints one lightweight curved vector path behind
staggered floating destinations. Nodes use Flutter icons, brand colors, small
cloud decorations and no new raster environment assets. This leaves room for
additional destinations without introducing free-pan, zoom, or a heavy scene
engine.

Each `LumioWorldNode` has a large tap surface, title, subject and explicit
status. It reads the active child's progression snapshot and shows real world
stars/completed missions when available. Future locked states retain icon, text,
semantics and friendly feedback rather than relying on color.

## World model and catalog

`LearningWorld` contains a stable ID, visual identity, unlock condition and sort order.
Localized title/subject/description, icon and color are resolved in the
presentation extension. Route IDs are independent of language. The static
catalog evaluates `UnlockCondition` against progression without changing route
or widget contracts.

Phase 5 access policy:

| World | Focus | State |
| --- | --- | --- |
| Number Kingdom | Mathematics | Unlocked |
| Word Woods | English | Unlocked |
| Language Village | Bahasa Melayu | Unlocked |
| Arabic Oasis | Arabic | Unlocked |
| Logic Lab | Logic / computational thinking | Unlocked |
| Discovery Island | General knowledge / science | Unlocked |

All core subjects remain broadly accessible. The progression-ready conditions
are designed to unlock later missions, areas or story content rather than block
whole subjects. See PROGRESSION.md.

World names receive natural Bahasa Melayu translations in the Malay locale.
Stable catalog IDs stay English-like slugs and are never shown to children.

## World Landing and future game entry

An unlocked node pushes `/child/:childId/adventure/:worldId`. The landing screen
shows world identity, localized child-friendly copy and Lumi. Start Adventure
only displays a localized future-games message. It cannot start a game or alter
state. Unknown or future directly opened locked worlds recover safely.

The Start Adventure callback is the future game-entry boundary. A later phase
can replace its message after a game catalog and mission state exist.

## Child navigation

The primary destinations are Home, Adventure and Rewards. Profile management,
settings and analytics remain in Parent Mode. Section changes use named route
replacement and preserve `childId`. World Landing is pushed from Adventure so
back returns to the same map; direct entry falls back to the Adventure route.
The old `/worlds` path redirects to `/adventure` for local development links.

## Lumi, motion and interaction hooks

Child Home uses the approved full-body mascot. Adventure Map uses a small Lumi
guide, and World Landing pairs Lumi with the world landmark. `AnimatedLumi`
runs one light native float on entry and then stops; it does not keep a costly
continuous ticker alive. Reduced motion renders the static asset.

Route transitions, path reveal, button compression and future locked-node response all
use existing `LumioMotion` tokens. Reduced motion removes movement while status,
icons and messages remain available. `ChildInteractionHook` exposes home CTA,
world tap, world entry and locked tap events for a future sound layer.
`RewardInteractionHook` adds star, coin, XP, level-up and achievement events;
neither phase plays placeholder audio.

## Accessibility, errors and performance

World semantics combine localized title, subject and status, with a tap action.
Controls retain at least 56 logical pixels, locked status is explicit, and map
spacing expands at enlarged text sizes. Phone portrait, tablet portrait and
tablet landscape are tested, including 200% text. The child shell continues to
use the established missing/deleted profile redirect and friendly recovery.

The map uses one custom-painted path, simple shapes/icons, bounded static nodes
and `RepaintBoundary` around mascot animation. No giant images, pan/zoom engine,
continuous map animation or new dependency was added.

## Future integration points

- A later mission system chooses the current world for Continue Adventure.
- A later game catalog replaces the Start Adventure development message.
- A future audio service subscribes through `ChildInteractionHook`.
- Future content can apply another `UnlockCondition` without changing stable
  world IDs.
