import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../data/local_profile_repository.dart';
import '../data/profile_database.dart';
import '../domain/profiles.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final database = AppConfig.fromEnvironment().profileSandboxEnabled
      ? ProfileDatabase.sandbox()
      : ProfileDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return LocalProfileRepository(database);
});

final profileStoreProvider =
    AsyncNotifierProvider<ProfileStore, ProfileSnapshot>(
      ProfileStore.new,
      retry: (_, _) => null,
    );

class ProfileStore extends AsyncNotifier<ProfileSnapshot> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);
  @override
  Future<ProfileSnapshot> build() =>
      ref.watch(profileRepositoryProvider).load();

  Future<void> _refresh() async {
    try {
      state = AsyncData(await _repository.load());
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }

  Future<void> completeSetup(String parent, ChildDraft child) async {
    await _repository.completeSetup(parent, child);
    await _refresh();
  }

  Future<void> create(ChildDraft child) async {
    await _repository.createChild(child);
    await _refresh();
  }

  Future<void> edit(String id, ChildDraft child) async {
    await _repository.updateChild(id, child);
    await _refresh();
  }

  Future<void> delete(String id) async {
    await _repository.deleteChild(id);
    await _refresh();
  }

  Future<void> reset() async {
    await _repository.reset();
    await _refresh();
  }
}

/// URI identity is authoritative. No second mutable selection can go stale.
/// Read this family with the current shell's childId throughout Child Mode.
final activeChildProvider = Provider.autoDispose
    .family<AsyncValue<ChildProfile?>, String>(
      (ref, id) => ref
          .watch(profileStoreProvider)
          .whenData((snapshot) => snapshot.child(id)),
    );
