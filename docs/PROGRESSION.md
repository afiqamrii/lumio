# Progression and rewards — Phase 5

Phase 5 provides a reusable, local-first reward foundation for future learning
activities. Rewards recognize learning, effort, mastery and exploration. Lumio
does not punish absence, remove streaks, sell currency, reward raw screen time,
or use random and gambling-like mechanics.

## Progression model

`ChildProgress` belongs to one immutable child ID and contains XP, total best
stars, current coin balance, unique completed activities and timestamps. Level
is derived from XP instead of stored separately, which prevents inconsistent
state. Profile fields remain in `ChildProfile`.

New or migrated children begin at Level 1 with zero XP, stars and coins. A
progress row is created lazily when that child's progression is first read.

## XP and level curve

The cumulative XP threshold for level `L` is:

```text
25 × (L - 1) × (L + 2)
```

This produces Level 1 = 0 XP, Level 2 = 100 XP, Level 3 = 250 XP and Level 4 =
450 XP. The cost of each level rises by 50 XP, so the curve is understandable
and easy to tune without large totals. `ChildProgress` exposes XP within the
current level, XP required for the next level and a normalized progress value.

Initial development balance gives 20 XP for the first completion of a unique
mission. Replay does not grant repeat XP. These values live in
`ProgressionConfig`; they are development values, not final product economics.

## Stars and replay behavior

A mission result contains one, two or three stars. `mission_best_results` keeps
the best result per child and mission. Global and world star totals only change
by the improvement:

```text
First result: 1 star  → total +1
Replay:       1 star  → total +0
Improvement:  3 stars → total +2
Worse replay: 2 stars → total +0
```

All valid attempts remain in attempt history, including replays, while mastery
summaries remain stable. Replaying one mission cannot infinitely farm stars,
XP or coins.

## Coins and transaction ledger

The first completion of a unique mission grants two base coins plus the earned
stars. Every coin change has a `RewardTransaction` with child, type, positive
amount, source type, source ID and timestamp. Spending uses the same repository
boundary, rejects non-positive amounts and cannot make a balance negative.

There is no store, inventory, real-money purchase, random reward or monetization
connection. The ledger is preparation for safe cosmetics in a later phase.

## Completion processing and idempotency

Widgets submit an explicit `MissionCompletion` action through
`ProgressionController`. `LocalProgressionRepository.completeMission` executes
the entire operation in one database transaction:

1. validate the event;
2. reject an already-recorded globally unique event ID;
3. calculate the per-mission best-star difference;
4. record the attempt and attempt number;
5. update the best result when appropriate;
6. add eligible XP, stars and coins;
7. append the coin transaction;
8. derive world progress;
9. evaluate and persist newly earned achievements;
10. return `ProgressionResult` for presentation.

Retrying the same event ID returns a duplicate result with zero new rewards.
Unique database keys also protect the mission event, coin source and earned
achievement records. This is the local foundation for future offline retries
and cloud reconciliation.

## Mission and world progress

`MissionCompletion` is generic and contains no learning content. Attempts are
separate from `MissionBestResult`. `WorldProgress` is computed from best results
and reports unique completed missions, best stars and last played time. It can
calculate a completion percentage when a future content catalog supplies a
mission count; Phase 5 does not invent one.

The Adventure Map reads the child's progression snapshot. Nodes may show real
stars and completed-adventure counts after activity simulation. No fake
completion percentages are displayed.

## Unlock conditions

The sealed `UnlockCondition` foundation includes:

- `AlwaysUnlocked`
- `MinimumLevel`
- `MinimumStars`
- `MissionCompleted`
- `MinimumWorldMissions`

All six current core learning worlds use `AlwaysUnlocked`, giving children broad
subject access. Later progression should usually open missions, areas, story
chapters and cosmetics instead of blocking whole subjects.

## Achievements

Definitions are separate from per-child earned state. Phase 5 includes:

- **First Glow** — complete the first adventure
- **Star Collector** — earn 10 stars
- **Curious Explorer** — try activities in three learning worlds
- **Bright Beginning** — reach Level 2

Each earned record has one child ID and earned timestamp. A composite database
key and engine check ensure it is returned as newly unlocked only once.

## Multi-child isolation

Every progress, attempt, best result, transaction and achievement row includes
the owning child ID. Queries and updates always filter by it. Foreign keys use
cascade deletion so deleting one child removes only that child's progression.
Switching route child IDs causes Home, Adventure and Rewards to read the correct
family provider immediately.

## Persistence schema and migration

Database schema version 2 adds normalized tables:

- `child_progresses`
- `mission_attempts`
- `mission_best_results`
- `reward_transactions`
- `child_achievements`

The version 1 → 2 migration only creates these tables. Existing parent, child
and setup rows are preserved. Tests create a real version 1 database, migrate
it, verify the profile, and load fresh progression. Full local reset still
removes profiles; the debug-only progression reset clears only reward tables.

For future cloud sync, child IDs, event IDs and transaction source IDs remain
stable. Attempts are append-only, best results are deterministic summaries, and
event/source uniqueness makes retry reconciliation possible. Server authority,
accounts and networking are intentionally absent.

## Reward presentation and hooks

Child Home shows level, stars, coins and progress toward the next level while
keeping Continue Adventure primary. Rewards shows Lumi, an accessible XP bar,
totals and earned achievement cards. Counts and status remain understandable
without color, sound or motion. Animations use existing `LumioMotion` durations
and become immediate when reduced motion is enabled.

`RewardInteractionHook` exposes star, coin, XP, level-up and achievement events
for future audio. Phase 5 includes no placeholder sound.

## Debug progression simulator

In development debug builds, open a child and select **Rewards**. The simulator
allows a world and one-to-three-star result, then submits a fixed debug mission
through the production progression action. **Retry Same Event** resubmits the
same event ID to demonstrate idempotency. Select another world to simulate a
different mission. The panel shows the returned reward delta and opens brief
Lumi celebrations for level-ups and new achievements.

The simulator and progression-reset control are excluded from production and
release behavior through `AppConfig.debugToolsEnabled`.
