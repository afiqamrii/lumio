import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:lumio/features/profiles/application/profile_store.dart';
import 'package:lumio/features/profiles/domain/profiles.dart';

/// Deterministic presentation double; SQLite behavior is tested independently.
class TestProfileRepository implements ProfileRepository {
  TestProfileRepository({bool complete = false, List<String>? ids}) {
    final now = DateTime.utc(2026, 9, 26);
    snapshot = ProfileSnapshot(
      onboardingComplete: complete,
      parent: complete
          ? ParentProfile(
              id: 'parent',
              displayName: 'Parent',
              createdAt: now,
              updatedAt: now,
            )
          : null,
      children: [
        if (complete)
          for (final id
              in ids ??
                  [
                    'preview',
                    'incoming_context',
                    'context_42',
                    'context',
                    'rotation_context',
                  ])
            ChildProfile(
              id: id,
              parentId: 'parent',
              displayName: id == 'preview' ? 'Aiman' : id,
              startingAge: 6,
              avatar: ProfileAvatar.sun,
              language: 'en',
              createdAt: now,
              updatedAt: now,
            ),
      ],
    );
  }
  late ProfileSnapshot snapshot;
  bool failLoad = false;
  bool failWrite = false;
  int _nextId = 0;
  @override
  Future<ProfileSnapshot> load() async {
    if (failLoad) throw const ProfileDataException();
    return snapshot;
  }

  @override
  Future<void> completeSetup(String parentName, ChildDraft draft) async {
    if (failWrite) throw const ProfileDataException();
    final now = DateTime.utc(2026, 9, 26);
    snapshot = ProfileSnapshot(
      onboardingComplete: true,
      parent: ParentProfile(
        id: 'parent',
        displayName: parentName.trim().isEmpty ? null : parentName.trim(),
        createdAt: now,
        updatedAt: now,
      ),
      children: [],
    );
    await createChild(draft);
  }

  @override
  Future<ChildProfile> createChild(ChildDraft draft) async {
    if (failWrite) throw const ProfileDataException();
    final valid = draft.validated();
    final now = DateTime.utc(2026, 9, 26);
    final child = ChildProfile(
      id: 'child-${_nextId++}',
      parentId: snapshot.parent!.id,
      displayName: valid.displayName,
      startingAge: valid.startingAge,
      avatar: valid.avatar,
      language: valid.language,
      createdAt: now,
      updatedAt: now,
    );
    snapshot = ProfileSnapshot(
      onboardingComplete: true,
      parent: snapshot.parent,
      children: [...snapshot.children, child],
    );
    return child;
  }

  @override
  Future<ChildProfile> updateChild(String id, ChildDraft draft) async {
    if (failWrite) throw const ProfileDataException();
    final valid = draft.validated();
    final old = snapshot.child(id)!;
    final child = ChildProfile(
      id: old.id,
      parentId: old.parentId,
      displayName: valid.displayName,
      startingAge: valid.startingAge,
      avatar: valid.avatar,
      language: valid.language,
      createdAt: old.createdAt,
      updatedAt: old.updatedAt.add(const Duration(seconds: 1)),
    );
    snapshot = ProfileSnapshot(
      onboardingComplete: true,
      parent: snapshot.parent,
      children: [
        for (final existing in snapshot.children)
          existing.id == id ? child : existing,
      ],
    );
    return child;
  }

  @override
  Future<void> deleteChild(String id) async {
    if (failWrite) throw const ProfileDataException();
    snapshot = ProfileSnapshot(
      onboardingComplete: true,
      parent: snapshot.parent,
      children: snapshot.children.where((child) => child.id != id).toList(),
    );
  }

  @override
  Future<void> reset() async {
    snapshot = ProfileSnapshot(
      onboardingComplete: false,
      parent: null,
      children: [],
    );
  }
}

// Kept fresh per ProviderScope/container so tests never touch device storage.
Override testProfileOverride({bool complete = true}) =>
    profileRepositoryProvider.overrideWithValue(
      TestProfileRepository(complete: complete),
    );
