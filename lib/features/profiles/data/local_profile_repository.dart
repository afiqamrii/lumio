import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../domain/profiles.dart';
import 'profile_database.dart';

class LocalProfileRepository implements ProfileRepository {
  LocalProfileRepository(this.database, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;
  final ProfileDatabase database;
  final DateTime Function() _clock;
  static const _uuid = Uuid();

  ChildProfile _child(ChildRow row) {
    try {
      final avatar = ProfileAvatar.values.byName(row.avatarId);
      final draft = ChildDraft(
        displayName: row.displayName,
        startingAge: row.startingAge,
        avatar: avatar,
        language: row.language,
      ).validated();
      if (draft.displayName != row.displayName ||
          !Uuid.isValidUUID(fromString: row.id) ||
          row.updatedAt.isBefore(row.createdAt)) {
        throw const ProfileDataException();
      }
      return ChildProfile(
        id: row.id,
        parentId: row.parentId,
        displayName: row.displayName,
        startingAge: row.startingAge,
        avatar: avatar,
        language: row.language,
        createdAt: row.createdAt.toUtc(),
        updatedAt: row.updatedAt.toUtc(),
      );
    } catch (_) {
      throw const ProfileDataException();
    }
  }

  @override
  Future<ProfileSnapshot> load() => database.transaction(() async {
    final parents = await database.select(database.localParents).get();
    final rows =
        await (database.select(database.localChildren)..orderBy([
              (table) => OrderingTerm.asc(table.createdAt),
              (table) => OrderingTerm.asc(table.id),
            ]))
            .get();
    final setup = await database.select(database.localSetup).getSingleOrNull();
    final complete = setup?.completed ?? false;
    if (parents.length > 1 ||
        (complete && parents.isEmpty) ||
        (!complete && (parents.isNotEmpty || rows.isNotEmpty))) {
      throw const ProfileDataException();
    }
    ParentProfile? parent;
    if (parents.isNotEmpty) {
      final row = parents.single;
      if (!Uuid.isValidUUID(fromString: row.id) ||
          (row.displayName != null &&
              (row.displayName!.trim().isEmpty ||
                  row.displayName!.runes.length > 40)) ||
          row.updatedAt.isBefore(row.createdAt)) {
        throw const ProfileDataException();
      }
      parent = ParentProfile(
        id: row.id,
        displayName: row.displayName,
        createdAt: row.createdAt.toUtc(),
        updatedAt: row.updatedAt.toUtc(),
      );
    }
    if (rows.any((row) => row.parentId != parent?.id)) {
      throw const ProfileDataException();
    }
    return ProfileSnapshot(
      onboardingComplete: complete,
      parent: parent,
      children: rows.map(_child).toList(),
    );
  });

  @override
  Future<void> completeSetup(String parentName, ChildDraft firstChild) async {
    final draft = firstChild.validated();
    final name = parentName.trim();
    if (name.runes.length > 40 || RegExp(r'[\x00-\x1F\x7F]').hasMatch(name)) {
      throw const ProfileValidationException();
    }
    await database.transaction(() async {
      if ((await load()).onboardingComplete) {
        throw const ProfileValidationException();
      }
      final now = _clock().toUtc();
      final parentId = _uuid.v4();
      await database
          .into(database.localParents)
          .insert(
            LocalParentsCompanion.insert(
              id: parentId,
              displayName: Value(name.isEmpty ? null : name),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _insert(draft, parentId, now);
      await database
          .into(database.localSetup)
          .insert(
            LocalSetupCompanion.insert(id: const Value(1), completed: true),
          );
    });
  }

  Future<ChildProfile> _insert(
    ChildDraft draft,
    String parentId,
    DateTime now,
  ) async {
    final id = _uuid.v4();
    await database
        .into(database.localChildren)
        .insert(
          LocalChildrenCompanion.insert(
            id: id,
            parentId: parentId,
            displayName: draft.displayName,
            startingAge: draft.startingAge,
            avatarId: draft.avatar.name,
            language: draft.language,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return _child(
      (await (database.select(
        database.localChildren,
      )..where((table) => table.id.equals(id))).getSingle()),
    );
  }

  @override
  Future<ChildProfile> createChild(ChildDraft draft) =>
      database.transaction(() async {
        final valid = draft.validated();
        final snapshot = await load();
        if (!snapshot.onboardingComplete) {
          throw const ProfileValidationException();
        }
        return _insert(valid, snapshot.parent!.id, _clock().toUtc());
      });

  @override
  Future<ChildProfile> updateChild(
    String id,
    ChildDraft draft,
  ) => database.transaction(() async {
    final valid = draft.validated();
    final existing = await (database.select(
      database.localChildren,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    if (existing == null) throw const ProfileMissingException();
    _child(existing);
    final now = _clock().toUtc();
    // SQLite's default date storage is seconds; keep edits strictly monotonic.
    final updated =
        now.isAfter(existing.updatedAt.add(const Duration(seconds: 1)))
        ? now
        : existing.updatedAt.add(const Duration(seconds: 1));
    await (database.update(
      database.localChildren,
    )..where((table) => table.id.equals(id))).write(
      LocalChildrenCompanion(
        displayName: Value(valid.displayName),
        startingAge: Value(valid.startingAge),
        avatarId: Value(valid.avatar.name),
        language: Value(valid.language),
        updatedAt: Value(updated),
      ),
    );
    return _child(
      (await (database.select(
        database.localChildren,
      )..where((table) => table.id.equals(id))).getSingle()),
    );
  });

  @override
  Future<void> deleteChild(String id) async {
    final count = await (database.delete(
      database.localChildren,
    )..where((table) => table.id.equals(id))).go();
    if (count == 0) throw const ProfileMissingException();
  }

  @override
  Future<void> reset() => database.transaction(() async {
    await database.delete(database.localChildren).go();
    await database.delete(database.localParents).go();
    await database.delete(database.localSetup).go();
  });
}
