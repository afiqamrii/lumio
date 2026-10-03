# Learning Content and Skill Engine

## Learning principle

Every Lumio activity must identify the real skill it practises. The learning
engine describes subjects, skills, curated content, and activity mappings. It
does not render games, infer mastery, award progression, or choose content
adaptively.

## Subjects

The six stable machine IDs are `math`, `english`, `bahasa_melayu`, `arabic`,
`logic`, and `discovery`. Display names are localized separately. These IDs are
safe to persist and must not be replaced by translated titles.

## Skill IDs and graph

Skill IDs use lowercase dotted namespaces such as
`math.addition.within_10`. They are deterministic, human-readable, and stable.
Renaming an ID is a data migration, not a copy edit.

Each `LearningSkill` contains its subject, localized title and description,
minimum and recommended ages, internal difficulty, prerequisite IDs, tags, and
active state. A skill may have zero or many prerequisites. Validation rejects
unknown references, duplicates, self-references, and graph cycles.

The initial catalog contains 75 skills: 15 Mathematics skills and 12 skills in
each other subject. It is a focused first graph for planned game packs, not a
complete curriculum.

## Difficulty and age recommendations

Internal difficulty uses `foundation`, `developing`, `confident`, and
`advanced`. These labels are metadata and are not shown to children as ability
judgments.

Age is an initial placement hint. `StartingSkillRecommender` returns active,
known starting nodes appropriate for ages 5–9, but it does not mark anything as
mastered. A child may later work above or below the typical recommendation.

## Typed content

`LearningContent` is a sealed model. Phase 6 supports multiple choice,
matching pairs, ordering, word or letter assembly, numeric answers, and audio
choice by stable asset ID.

Shared `ContentMetadata` contains a stable ID, skill ID, internal difficulty,
learning locale, age recommendation, tags, version, lifecycle status, and text
direction. Type-specific fields stay on concrete classes instead of one large
nullable data object.

## Local storage and repository

Curated JSON files live under `assets/content/`, one per subject. The files are
human-readable, versioned with the application, work offline, and avoid one
large cross-subject document.

`LocalLearningContentRepository` loads the six assets once, caches the parsed
future, combines them into one catalog, and validates the result before making
it available. Parsing errors include the source filename. Widgets and future
games consume the repository instead of reading assets directly.

Repository queries support subject skills, skill lookup, content by skill,
content by ID, prerequisites, explicit learning-locale filters, and age-based
starting recommendations.

## Validation

`LearningCatalogValidator` fails fast for:

- duplicate or malformed skill and content IDs
- invalid subjects, difficulty values, statuses, ages, or locales
- unknown, duplicate, self-referencing, or cyclic prerequisites
- content that refers to unknown skills
- duplicate or unknown activity skill mappings
- missing correct choices, duplicate choices, or unreasonable option counts
- invalid ordering targets or matching pairs
- words that cannot be built from the supplied letters
- invalid numeric operators or operands
- malformed/control text and invalid Arabic direction or missing Arabic script

The full catalog is validated automatically when loaded, in domain tests, and
from the debug Learning Content Browser.

## Initial content

The initial catalog contains 108 curated examples:

| Subject | Items |
| --- | ---: |
| Mathematics | 24 |
| English | 18 |
| Bahasa Melayu | 18 |
| Arabic | 18 |
| Logic | 15 |
| Discovery | 15 |

These items exercise several skills and typed formats without attempting to
build a full curriculum or game bank.

## Sessions and answer evaluation

`LearningSessionBuilder` accepts a child ID, activity definition, supported
skill ID, requested count, and deterministic integer seed. It filters active
items by skill and the activity's locale, difficulty, and tag query, then uses
a seeded shuffle. The same inputs produce the same ordered IDs.

Selection never repeats an item within a session. When fewer eligible items
exist than requested, the builder returns all eligible items without looping or
throwing. Building a session has no persistence or reward side effects.

`AnswerEvaluator` centrally evaluates choice IDs, matching maps, ordered ID
lists, normalized word strings, and numeric answers. It returns correctness, an
expected answer/reference, and a feedback localization key. Pedagogical hints
and generated feedback are outside Phase 6.

## Game types and activities

`LearningGameType` provides stable IDs for planned games without referring to
Flutter widget classes. `ActivityDefinition` maps an activity to a game type,
one or more skills, a world, and a content query. Activities remain unavailable
until their playable game phase is implemented.

## UI language and learning language

Application localization and learning-content locale are independent. A parent
can use a Bahasa Melayu UI while a child practises English. Repository methods
only filter learning language when the caller explicitly supplies a locale.

Arabic items use Unicode and content-level right-to-left direction. The content
browser wraps the Arabic prompt itself in RTL direction without forcing the app
UI into RTL. Noto Sans Arabic remains available for future game presentation.

## Activity results, mastery, and adaptive learning

`LearningActivityResult` is a transport contract for activity ID, skill IDs,
content IDs, totals, correctness, duration, completion, and small extensible
metadata. It is not persisted in Phase 6.

Future games can emit this result for progression, mastery, and parent insight
systems. Stable skill and content IDs support later tracking of attempts,
correctness, response time, hints, repeated mistakes, confidence, and mastery.
Adaptive selection can later consume mastery through a separate policy. It
must not be embedded in the deterministic repository or equate age with skill.

## Progression boundary

The learning engine answers what was practised and whether answers were
correct. The Phase 5 progression engine decides rewards after a future game
produces a completed activity result. Loading content, validating a catalog, or
building a test session never grants XP, stars, or coins.

## Development browser

In a debug development build, open Parent Settings and select **Learning
Content Browser**. Choose a subject and skill to inspect IDs, internal
difficulty, prerequisites, type, learning locale, and prompts. **Build Test
Session** creates up to five deterministic items. Rebuild the same seed or use
another seed to inspect selection behavior. **Validate Learning Catalog** runs
the same fail-fast validator used at load time and in tests.

The route and entry action are not registered in release/profile builds or in
the production environment.

