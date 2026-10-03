# Parent onboarding and local profiles — Phase 3

This phase implements family setup, profile management and profile-aware child
navigation. There is no authentication, cloud sync, gate, learning engine,
adventure map, progress storage, purchases or telemetry.

## Models and minimal data

ParentProfile stores UUID v4 id, nullable displayName, createdAt and updatedAt.
The optional name only personalizes the parent greeting; setup needs no email.
There is one local parent/guardian configuration per app installation. It is not
an authenticated account or a verified guardian identity.

ChildProfile stores UUID v4 id, parentId, displayName, startingAge, avatar,
language, createdAt and updatedAt. The foreign key ties each local child to the
local parent record. IDs and creation times remain stable during edits. Timestamp
values are read as UTC; edits advance updatedAt even within SQLite's second
precision. No selected-session or progress fields are added.

Names are trimmed, required for children, optional for parents, limited to 40
Unicode scalar values, and reject control characters. Unicode, accents and
non-Latin names are accepted. Names are rendered as text and bound through typed
database parameters; they are not SQL or route identifiers.

Starting age is an integer 5–9, selected explicitly. It is an editable initial
placement hint, not a birth date, exact current age, automatic birthday counter
or permanent difficulty lock. Unsupported values are rejected. Adaptive placement
will be independent in its later phase.

Child interface language is en or ms. It applies to child navigation and content,
while exiting restores the parent's device/app language. Later languages need
localization resources and a reviewed schema/catalog extension.

## Avatar strategy and brand inspection

The source package MANIFEST.json, production README, character references and
empty game-structure reservation contain Lumi expressions and application icons,
but no approved catalog of distinct child-profile avatars. Lumi reaction poses
are not repurposed as separate child identities.

Four simple predefined symbol avatars — Spark, Sun, Moon and Leaf — use Flutter
Material icons, LumioAvatarFrame and semantic Lumio colors. They are explicitly
replaceable profile symbols, not new characters or reward state. ProfileAvatar's
stable stored IDs separate selection from icon implementation. No new image,
photo upload, generation, mascot modification or source-brand overwrite occurs.

## Repository and SQLite

ProfileRepository is the aggregate interface; ChildProfileRepository defines
create/update/delete operations. load() returns an immutable ProfileSnapshot of
parent, children and completion, with child(id) lookup. Presentation depends on
these models and the Riverpod store, never on Drift rows or SQL.

LocalProfileRepository uses ProfileDatabase with schema version 1:
- local_parents: UUID primary key and singleton constraint;
- local_children: UUID primary key, parent foreign key and constrained age,
  avatar and language values;
- local_setup: one completion record.

Drift's generated schema is checked in. Regenerate with
`dart run build_runner build`; build.yaml restricts generation to this database.
Foreign keys are enabled after opening. Setup commits parent + first child +
completion in one transaction. A failed write rolls all three back. CRUD inputs
are validated before writes, reads validate malformed stored records, and unknown
IDs never manufacture a replacement profile. A read error offers retry without
silently resetting or discarding records.

drift_flutter opens lumio_profiles.sqlite in the native application documents
directory, with native database execution managed by its platform connector.
The file survives process termination and app updates. Clearing app data or
uninstalling removes local profiles. No Lumio network synchronization exists.
SQLite is not encrypted; OS sandbox, device security and platform backup policy
apply. This is not a claim of encrypted or authenticated storage.

Android and iOS are the product targets. Phase 3 does not provision Drift's web
WASM/worker assets; a web attempt shows the safe local-load error rather than
silently substituting nonpersistent storage. Web persistence is a separate
platform decision, not required for this mobile phase.

## Riverpod and active context

profileRepositoryProvider owns/ closes the database. profileStoreProvider loads
the snapshot and refreshes it after each successful mutation. Load retry is
explicitly user-driven, avoiding automatic background retry loops for malformed
files. A failed post-write reload enters the load-error flow; retry reads the
already committed result.

activeChildProvider(childId) derives an AsyncValue<ChildProfile?> from that
snapshot. ChildShell passes its route ID to this family; future child features
read the same family. The URI is the single source of active identity. There is
no mutable singleton, redundant selection flag or persisted old child session.
Switching routes changes the family context; deleting a referenced profile
refreshes routing into a safe unavailable-profile screen. Parent screens read
the aggregate, never an accidentally retained child selection.

## Onboarding and restoration

Normal debug and release launch: finite brand introduction → real local load →
onboarding when incomplete, otherwise child selector. Restart never silently
resumes Child Mode. Incoming parent/child routes require completed local setup
and existing child records; these checks are not authentication.

Four stages: welcome, optional guardian display name/local-storage explanation,
first child's nickname/starting age/avatar/language, then review and finish.
Drafts remain in widget state until the atomic finish. Back preserves values
between stages; unfinished setup does not create partially saved profiles.

The selector is the bridge into real Child Mode. Parent Children supports add,
edit and confirmed deletion. Deleting the final child is allowed: setup and the
parent remain, and selector/Children show a clear add-child empty state. Editor
back/cancel confirms discarding changed inputs. Parent Settings contains the
local parent display and app ownership information only.

## Development and reset

Both preview flags now default false, including debug. Explicitly opt into the
Phase 2 chooser with LUMIO_NAVIGATION_PREVIEW=true or the Phase 1 gallery with
LUMIO_DESIGN_PREVIEW=true. Preview entry uses real setup/profiles; no synthetic
child record is persisted. Release/profile and production reject these routes.

Debug non-production Parent Settings contains Reset Lumio Local Data. Confirmation
is required. Its transaction deletes child rows, parent and setup completion,
refreshes state and routes to onboarding. It never appears in release/profile or
production. It does not touch source assets or external files.

For safe development verification without resetting existing profiles, run:

```powershell
flutter run --dart-define=LUMIO_PROFILE_SANDBOX=true
```

In debug non-production only, this uses the separate `lumio_profiles_qa.sqlite`
file with the same schema and repository. A visible PROFILE SANDBOX banner
identifies it. Reset affects only the active database. Restarting with no flag
returns to the ordinary database; no data is copied between them. Release/profile
and production ignore this flag. This is a test utility, not multiple-user support.

## Future integration boundaries

A future synced repository can implement the aggregate/domain contracts and
add explicit synchronization metadata through reviewed migrations. Retain IDs,
ownership and creation time when linking a real authenticated parent; do not
recreate all local children or infer account identity from a display name.
There is no email/token/auth-user field until authentication has a real purpose.

Router refresh and top-level redirects remain the future auth integration point.
ChildShell's exit callback is the future parental-gate integration point for
toolbar and OS back. It currently returns clearly to the selector. A later gate
must also handle direct parent links; this phase supplies no access protection.

## Compatibility and checks

The current Flutter 3.38.6 test/meta pins reject newer Drift generators. Compatible
pins are drift/drift_dev 2.31.0, drift_flutter 0.2.8 and build_runner 2.10.5.
uuid 4.6.0 generates stable UUID v4 identifiers. sqlite3 2.9.4 is a direct dev
dependency for real SQLite tests and the Windows test-library override.

On Windows x64 run `./tool/prepare-test-sqlite.ps1` once after pub get. It downloads
the official SQLite 3.53.4 archive into ignored .dart_tool, checks the pinned
SHA-256 and extracts only sqlite3.dll. Its original SHA3 matches the
[official SQLite download page](https://www.sqlite.org/download.html).
Windows winsqlite3 on this host omits foreign keys; tests therefore use the full
library. Linux CI uses system SQLite. This helper is never bundled into the app.

Tests cover actual SQLite CRUD, Unicode/invalid inputs, rollback, corruption,
reopening files, setup/selection/switch/edit/delete/restart/reset, recovery,
production tool exclusion, child locale isolation and scaled phone/tablet forms.
Read PHASE-3-VERIFICATION.md for final gate and native runtime results.
