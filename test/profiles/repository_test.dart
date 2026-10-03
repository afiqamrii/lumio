import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/features/profiles/data/local_profile_repository.dart';
import 'package:lumio/features/profiles/data/profile_database.dart';
import 'package:lumio/features/profiles/domain/profiles.dart';

const draft = ChildDraft(
  displayName: ' Aiman ',
  startingAge: 6,
  avatar: ProfileAvatar.sun,
  language: 'en',
);

void main() {
  late ProfileDatabase database;
  late LocalProfileRepository repo;
  setUp(() {
    database = ProfileDatabase(NativeDatabase.memory());
    repo = LocalProfileRepository(
      database,
      clock: () => DateTime.utc(2026, 9, 26),
    );
  });
  tearDown(() => database.close());

  test('atomic setup persists parent, first child, and completion', () async {
    expect((await repo.load()).onboardingComplete, isFalse);
    await repo.completeSetup(' Parent ', draft);
    final state = await repo.load();
    expect(state.onboardingComplete, isTrue);
    expect(state.parent!.displayName, 'Parent');
    final child = state.children.single;
    expect(child.displayName, 'Aiman');
    expect(child.parentId, state.parent!.id);
    expect(child.createdAt.isUtc, isTrue);
    expect(child.id, matches(RegExp(r'^[0-9a-f-]{36}$')));
    await expectLater(
      repo.completeSetup('', draft),
      throwsA(isA<ProfileValidationException>()),
    );
    expect((await repo.load()).children, hasLength(1));
  });

  test('invalid input never partially completes setup', () async {
    for (final invalid in [
      const ChildDraft(
        displayName: ' ',
        startingAge: 5,
        avatar: ProfileAvatar.sun,
        language: 'en',
      ),
      const ChildDraft(
        displayName: 'A',
        startingAge: 4,
        avatar: ProfileAvatar.sun,
        language: 'en',
      ),
      const ChildDraft(
        displayName: 'A',
        startingAge: 10,
        avatar: ProfileAvatar.sun,
        language: 'en',
      ),
      const ChildDraft(
        displayName: 'A',
        startingAge: 5,
        avatar: ProfileAvatar.sun,
        language: 'unknown',
      ),
      ChildDraft(
        displayName: 'a' * 41,
        startingAge: 5,
        avatar: ProfileAvatar.sun,
        language: 'en',
      ),
    ]) {
      await expectLater(
        repo.completeSetup('', invalid),
        throwsA(isA<ProfileValidationException>()),
      );
      final state = await repo.load();
      expect(state.parent, isNull);
      expect(state.children, isEmpty);
      expect(state.onboardingComplete, isFalse);
    }
    await repo.completeSetup(
      '',
      const ChildDraft(
        displayName: 'نور-é',
        startingAge: 5,
        avatar: ProfileAvatar.leaf,
        language: 'ms',
      ),
    );
    expect((await repo.load()).parent!.displayName, isNull);
  });

  test(
    'create, edit and delete preserve identity, creation time and ownership',
    () async {
      await repo.completeSetup('', draft);
      final second = await repo.createChild(
        const ChildDraft(
          displayName: 'Sofia',
          startingAge: 9,
          avatar: ProfileAvatar.moon,
          language: 'ms',
        ),
      );
      final edited = await repo.updateChild(second.id, draft);
      expect(edited.id, second.id);
      expect(edited.parentId, second.parentId);
      expect(edited.createdAt, second.createdAt);
      expect(edited.updatedAt.isAfter(second.updatedAt), isTrue);
      await repo.deleteChild(second.id);
      final first = (await repo.load()).children.single;
      await repo.deleteChild(first.id);
      final empty = await repo.load();
      expect(empty.onboardingComplete, isTrue);
      expect(empty.children, isEmpty);
      await expectLater(
        repo.updateChild(second.id, draft),
        throwsA(isA<ProfileMissingException>()),
      );
      await repo.createChild(draft);
      await repo.reset();
      expect((await repo.load()).parent, isNull);
      expect((await repo.load()).onboardingComplete, isFalse);
    },
  );

  test(
    'schema transaction rollback leaves first run unchanged on write failure',
    () async {
      await database.customStatement(
        "CREATE TRIGGER reject_setup BEFORE INSERT ON local_setup BEGIN SELECT RAISE(ABORT, 'test failure'); END",
      );
      await expectLater(repo.completeSetup('', draft), throwsA(anything));
      expect((await repo.load()).parent, isNull);
      expect((await repo.load()).children, isEmpty);
    },
  );

  test('malformed stored profile fails safely without erasing data', () async {
    await repo.completeSetup('', draft);
    await database.customStatement('PRAGMA ignore_check_constraints = ON');
    await database.customStatement(
      "UPDATE local_children SET avatar_id = 'unknown'",
    );
    await expectLater(repo.load(), throwsA(isA<ProfileDataException>()));
    expect((await database.select(database.localChildren).get()), hasLength(1));
  });

  test('file-backed profiles and setup survive close and reopen', () async {
    final folder = await Directory.systemTemp.createTemp('lumio-profile-test-');
    final file = File('${folder.path}/profiles.sqlite');
    final firstDb = ProfileDatabase(NativeDatabase(file));
    final firstRepo = LocalProfileRepository(firstDb);
    await firstRepo.completeSetup('Parent', draft);
    await firstRepo.createChild(draft);
    final before = await firstRepo.load();
    await firstDb.close();
    final secondDb = ProfileDatabase(NativeDatabase(file));
    try {
      final restored = await LocalProfileRepository(secondDb).load();
      expect(restored.onboardingComplete, isTrue);
      expect(restored.parent!.id, before.parent!.id);
      expect(
        restored.children.map((child) => child.id),
        before.children.map((child) => child.id),
      );
    } finally {
      await secondDb.close();
      await folder.delete(recursive: true);
    }
  });
}
