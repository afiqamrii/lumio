import 'dart:math';

import 'activity_models.dart';
import 'learning_models.dart';

class LearningSession {
  const LearningSession({
    required this.childId,
    required this.activityId,
    required this.skillId,
    required this.seed,
    required this.items,
  });
  final String childId;
  final String activityId;
  final String skillId;
  final int seed;
  final List<LearningContent> items;
}

class LearningSessionBuilder {
  const LearningSessionBuilder();

  LearningSession build({
    required String childId,
    required ActivityDefinition activity,
    required String skillId,
    required Iterable<LearningContent> content,
    required int itemCount,
    required int seed,
  }) {
    if (itemCount < 1) throw ArgumentError.value(itemCount, 'itemCount');
    if (!activity.skillIds.contains(skillId)) {
      throw ArgumentError('Activity ${activity.id} does not support $skillId.');
    }
    final eligible = content.where((item) {
      final metadata = item.metadata;
      return metadata.status == ContentStatus.active &&
          metadata.skillId == skillId &&
          activity.contentQuery.difficulties.contains(metadata.difficulty) &&
          (activity.contentQuery.locales.isEmpty ||
              activity.contentQuery.locales.contains(metadata.locale)) &&
          (activity.contentQuery.tags.isEmpty ||
              activity.contentQuery.tags.every(metadata.tags.contains));
    }).toList();
    eligible.shuffle(Random(seed));
    return LearningSession(
      childId: childId,
      activityId: activity.id,
      skillId: skillId,
      seed: seed,
      items: List.unmodifiable(eligible.take(itemCount)),
    );
  }
}
