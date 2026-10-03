import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profiles/application/profile_store.dart';
import '../../profiles/data/local_profile_repository.dart';
import '../data/local_progression_repository.dart';
import '../data/memory_progression_repository.dart';
import '../domain/progression_models.dart';
import '../domain/progression_repository.dart';

final progressionRepositoryProvider = Provider<ProgressionRepository>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  if (profileRepository is LocalProfileRepository) {
    return LocalProgressionRepository(profileRepository.database);
  }
  return MemoryProgressionRepository();
});

final childProgressProvider = FutureProvider.autoDispose
    .family<ProgressionSnapshot, String>((ref, childId) {
      return ref.watch(progressionRepositoryProvider).loadChild(childId);
    });

final progressionControllerProvider = Provider<ProgressionController>(
  ProgressionController.new,
);

class ProgressionController {
  ProgressionController(this.ref);
  final Ref ref;

  ProgressionRepository get _repository =>
      ref.read(progressionRepositoryProvider);

  Future<ProgressionResult> completeMission(
    MissionCompletion completion,
  ) async {
    final result = await _repository.completeMission(completion);
    ref.invalidate(childProgressProvider(completion.childId));
    return result;
  }

  Future<void> resetChild(String childId) async {
    await _repository.resetChild(childId);
    ref.invalidate(childProgressProvider(childId));
  }

  Future<void> resetAll(Iterable<String> childIds) async {
    await _repository.resetAll();
    for (final childId in childIds) {
      ref.invalidate(childProgressProvider(childId));
    }
  }
}
