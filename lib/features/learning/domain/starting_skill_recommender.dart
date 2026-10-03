import 'learning_models.dart';

abstract final class StartingSkillRecommender {
  static List<LearningSkill> recommend({
    required int age,
    required LearningSubject subject,
    required Iterable<LearningSkill> skills,
  }) {
    if (age < 5 || age > 9) {
      throw RangeError.range(age, 5, 9, 'age');
    }
    final candidates = skills.where(
      (skill) =>
          skill.subject == subject &&
          skill.isActive &&
          skill.minimumAge <= age &&
          skill.recommendedAge <= age,
    );
    final available = candidates.toList(growable: false);
    final roots = available
        .where((skill) => skill.prerequisiteSkillIds.isEmpty)
        .toList(growable: false);
    if (age == 5) return roots.take(3).toList();
    if (age == 6) {
      return available
          .where(
            (skill) =>
                skill.difficulty != SkillDifficulty.advanced &&
                skill.prerequisiteSkillIds.length <= 1,
          )
          .take(4)
          .toList();
    }
    return available.take(5).toList();
  }
}
