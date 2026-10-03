# Learning Content Authoring

Lumio learning content is curated for children aged 5–9. Every item must teach
or practise an identified skill. Content must not contain advertising, links,
social prompts, mature or frightening themes, unnecessary violence, or requests
for personal information.

## Add a skill

1. Open the appropriate file in `assets/content/`.
2. Add a skill with a stable dotted ID beginning with the file's subject ID,
   for example `math.addition.within_20`.
3. Add a stable snake-case `code`.
4. Supply non-empty `en` and `ms` title and description values.
5. Choose internal difficulty, minimum age, recommended age, tags, and active
   state.
6. Add only known prerequisite IDs and keep the graph acyclic.
7. Add or update tests when introducing new structure or behavior.

Never change an existing skill ID to improve wording. Update its localized
title or description instead. Changing an ID requires a migration plan because
future progress and mastery records will refer to it.

## Add a prerequisite

Add the existing stable skill ID to `prerequisiteSkillIds`. The prerequisite
should represent knowledge needed before the new skill, not merely a preferred
screen order. Run validation to catch unknown IDs, duplicates, self-links, and
cycles.

## Add a content item

1. Place the item in the content array of the correct subject file.
2. Create a unique stable ID under that subject and skill namespace.
3. Reference a known skill.
4. Set internal difficulty, learning locale, age guidance, tags, version, and
   status.
5. Choose a supported type and supply only that type's fields.
6. Write a concrete, unambiguous, age-appropriate prompt.
7. Check spelling, cultural context, mathematical correctness, duplicate
   options, and whether exactly one intended answer exists.
8. Increment `version` when the educational meaning or expected answer changes.

Use `active` for reviewed content, `draft` while authoring, and `disabled` when
an item must remain addressable but should not enter sessions.

## Type-specific fields

- `multiple_choice`: `choices` and `correctChoiceId`
- `audio_choice`: stable `audioAssetId`, `choices`, and `correctChoiceId`
- `matching`: two or more unique `pairs`
- `ordering`: unique `items` and `correctOrder` containing every item ID once
- `build_word`: `targetWord` and enough `availableLetters` to build it
- `numeric`: `operands`, supported `operator`, and numeric `answer`

Choice IDs are stored as answers; visible labels may later be translated
without changing correctness records.

## Add a translation or learning language

Skill titles and descriptions currently require English and Bahasa Melayu. Add
another locale entry without removing those baselines.

Content locale describes the language being practised, not the application's
UI locale. Create a distinct content item when a translated prompt changes the
learning experience. Arabic items must contain valid Arabic Unicode and use
`rightToLeft`; do not switch the whole application direction for one prompt.

Keep Arabic examples conservative and obtain linguistic review before adding
advanced grammar, vocalization-dependent answers, or pronunciation claims.

## Add an activity mapping

Add an `ActivityDefinition` to `ActivityCatalog` with a stable activity ID,
`LearningGameType`, known skill IDs, matching Adventure world ID, development
title, and any locale, difficulty, or tag filters in `ContentQuery`.

Leave `available` false until its game is implemented and accepted. Do not
reference widget classes or award progression from the mapping.

## Validate changes

Run:

```powershell
flutter test test/learning
flutter analyze
```

In a debug app, open **Parent Settings → Learning Content Browser**, inspect the
changed subject, generate sessions with repeated and different seeds, and run
**Validate Learning Catalog**. Validation errors must be fixed rather than
silenced.

