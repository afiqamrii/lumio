import 'progression_models.dart';

abstract interface class ProgressionRepository {
  Future<ProgressionSnapshot> loadChild(String childId);
  Future<ProgressionResult> completeMission(MissionCompletion completion);
  Future<RewardTransaction> spendCoins({
    required String childId,
    required int amount,
    required String sourceType,
    required String sourceId,
  });
  Future<void> resetChild(String childId);
  Future<void> resetAll();
}
