import 'learning_models.dart';

abstract interface class LearningContentRepository {
  Future<LearningCatalog> loadCatalog();
  Future<List<LearningSkill>> getSkillsBySubject(LearningSubject subject);
  Future<LearningSkill?> getSkillById(String id);
  Future<List<LearningContent>> getContentForSkill(
    String skillId, {
    String? learningLocale,
  });
  Future<LearningContent?> getContentById(String id);
  Future<List<LearningSkill>> getPrerequisites(String skillId);
  Future<List<LearningSkill>> getRecommendedStartingSkills({
    required int age,
    required LearningSubject subject,
  });
}
