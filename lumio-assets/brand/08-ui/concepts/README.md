# Lumio UI concept v1

Four separate mobile screen concepts, matching the selected mascot, wordmark and purple/gold/turquoise direction. Status: for visual review. Generated with built-in image generation; these are raster mockups, not a working app, editable UI components or final accessibility-verified screens.

## Screens and intended behavior

### 01 — Child home
A personalized welcome, optional daily adventure progress, floating Number Kingdom map, earned stars and one main Play action. The current map node and Play next adventure button open the same next activity. Completed nodes can be replayed; incomplete future nodes explain their sequence when tapped. Explore worlds opens subject selection. Bottom navigation: Adventure, Discover and My stars. Parents opens a parent gate before adult settings or account controls.

### 02 — Counting game
Five stars are displayed; answer options are 4, 5 and 6. The mockup shows 5 selected before validation. Tapping each star should mark it as counted and optionally speak the count, without awarding duplicate progress. Selecting an option enables Check answer. Correct response offers a brief supportive reaction and advances the activity. An incorrect response preserves the question and offers another try or hint, with no penalty/lives. Need a hint guides the child to count one at a time; X pauses and lets them resume or return to map. Speaker toggle controls audio and does not remove visible instructions.

The progress bar shows question 3 of 5; only after all five questions does this example move to the completion screen. Counts and answer checking must be implemented using real data, not pixels in the mockup.

### 03 — Activity complete
Celebrate effort, then offer Back to map, Take a break or Play again. Example progression: home starts at 24 earned stars and 1 of 3 activities; this completion gives +3 to reach 27 and 2 of 3. These are illustrative design values, not a finalized reward economy. Apply completion rewards once per eligible activity attempt using unique attempt IDs. Replay reward policy remains to be decided; it must not duplicate the same completion event. Back to map and close return home. Take a break pauses/ends the session without guilt; no auto-advance countdown.

### 04 — Parent overview
Quiet surfaces, profile selection, period selector, learning time/activity/day summaries, strengths and practice suggestions, goal, sound/motion and profile settings. All displayed personal data and metrics are fictional examples; “Afiq, Age 7” is a demo child, not a statement about the owner. Sample data is explicitly labeled. Learning status claims need defined evidence before implementation; they are placeholder copy here. Return to child mode exits parent space. Overview, Progress, Profiles and Settings navigation must be implemented separately.

## Proposed UI rules

- Design mobile layouts against a 390-wide logical viewport with responsive scrolling, safe areas and 20–24 spacing at sides; PNG dimensions are not UI layout dimensions.
- Proposed child primary controls: at least 56 logical pixels tall; avoid tiny icon-only actions and use labels where helpful.
- Use exact CSS/JSON color tokens in ../../05-colors when implementing; generated screenshots contain gradients and color drift and do not establish new palette values.
- Use live text and vector/native controls; never ship these full screenshots as the interactive interface. Final fonts remain to be selected and checked for language coverage.
- English copy is illustrative. English, Bahasa Melayu and Arabic need layout testing; Arabic requires a deliberate RTL implementation and appropriately licensed fonts, not automatic image mirroring.
- Focus screen artwork away from question content. Do not decorate counting activities with extra countable objects that could confuse the task.
- Keep sound optional, support text alternatives, and replace bounces/confetti with static states in reduced-motion mode.
- Pair correct/incorrect status with clear copy and an icon, not color alone. Use lesson accuracy without shame or competition.
- Parent mode is reached through an adult gate; purchases and account settings remain in parent space. No gate implementation exists yet.

## Suggested motion direction

Home: restrained idle blink and occasional tail motion, subtle current-node pulse. Game: short tactile press feedback and one count response per object. Completion: brief celebration, then settle. Parent: quiet, minimal transitions. All timings and motion must be tuned in a working prototype; no animations were delivered in this stage.

## Visual QA and production limits

Inspected all four renders for spelling, screen structure and key content. Five countable stars and selected answer 5 are visible. Completion examples agree with home totals. Parent data is labeled as sample. These checks do not establish actual touch targets, screen-reader support, responsive layout or contrast compliance. Recheck all of those in implementation. Mascot art has minor generated pose/proportion variation (including tail orientation in the game); use approved source geometry for final character production. Flatten excessive glossy button/illustration effects if they distract from the chosen 2D character direction.

## Outstanding work from earlier stages

Individual reaction cutouts were requested after the expression sheet, then work moved on to UI. Only the labeled sheet is currently included; nine separate reaction assets remain pending. The consolidated brand guideline was skipped when the owner moved to UI and remains pending, as do vector masters and platform icon exports. Do not mark those complete.

## Included files

Four standalone PNG screen concepts, exact generation prompts, this interaction guide, and gallery.html for viewing the screens side by side locally. The gallery is a static review aid, not the app prototype.
