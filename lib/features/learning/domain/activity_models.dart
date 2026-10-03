import 'package:flutter/foundation.dart';

import 'learning_models.dart';

enum LearningGameType {
  numberRush('number_rush'),
  littleShop('little_shop'),
  pizzaFraction('pizza_fraction'),
  wordCatch('word_catch'),
  wordBuilder('word_builder'),
  storyQuest('story_quest'),
  arabicLetterHunt('arabic_letter_hunt'),
  arabicExplorer('arabic_explorer'),
  roboPath('robo_path'),
  patternFactory('pattern_factory'),
  animalExplorer('animal_explorer'),
  buildABody('build_a_body');

  const LearningGameType(this.id);
  final String id;
}

@immutable
class ContentQuery {
  const ContentQuery({
    this.locales = const [],
    this.difficulties = SkillDifficulty.values,
    this.tags = const [],
  });
  final List<String> locales;
  final List<SkillDifficulty> difficulties;
  final List<String> tags;
}

@immutable
class ActivityDefinition {
  const ActivityDefinition({
    required this.id,
    required this.gameType,
    required this.skillIds,
    required this.worldId,
    required this.title,
    required this.contentQuery,
    this.available = false,
  });
  final String id;
  final LearningGameType gameType;
  final List<String> skillIds;
  final String worldId;
  final String title;
  final ContentQuery contentQuery;
  final bool available;
}

abstract final class ActivityCatalog {
  static const activities = <ActivityDefinition>[
    ActivityDefinition(
      id: 'activity.number_rush.counting',
      gameType: LearningGameType.numberRush,
      skillIds: ['math.counting.1_to_5', 'math.counting.1_to_10'],
      worldId: 'number-kingdom',
      title: 'Number Rush',
      contentQuery: ContentQuery(locales: ['en', 'ms']),
    ),
    ActivityDefinition(
      id: 'activity.little_shop.money',
      gameType: LearningGameType.littleShop,
      skillIds: ['math.money.recognise_malaysia'],
      worldId: 'number-kingdom',
      title: 'Little Shop',
      contentQuery: ContentQuery(locales: ['en', 'ms']),
    ),
    ActivityDefinition(
      id: 'activity.word_builder.english',
      gameType: LearningGameType.wordBuilder,
      skillIds: ['english.spelling.cvc', 'english.spelling.short_words'],
      worldId: 'word-woods',
      title: 'Word Builder',
      contentQuery: ContentQuery(locales: ['en']),
    ),
    ActivityDefinition(
      id: 'activity.word_builder.bm',
      gameType: LearningGameType.wordBuilder,
      skillIds: ['bahasa_melayu.suku_kata.kv', 'bahasa_melayu.suku_kata.kvkv'],
      worldId: 'language-village',
      title: 'Pembina Perkataan',
      contentQuery: ContentQuery(locales: ['ms']),
    ),
    ActivityDefinition(
      id: 'activity.arabic_letter_hunt',
      gameType: LearningGameType.arabicLetterHunt,
      skillIds: ['arabic.letters.isolated', 'arabic.letters.similar'],
      worldId: 'arabic-oasis',
      title: 'Arabic Letter Hunt',
      contentQuery: ContentQuery(locales: ['ar']),
    ),
    ActivityDefinition(
      id: 'activity.pattern_factory',
      gameType: LearningGameType.patternFactory,
      skillIds: ['logic.pattern.ab', 'logic.pattern.aab', 'logic.pattern.abc'],
      worldId: 'logic-lab',
      title: 'Pattern Factory',
      contentQuery: ContentQuery(),
    ),
    ActivityDefinition(
      id: 'activity.animal_explorer',
      gameType: LearningGameType.animalExplorer,
      skillIds: ['discovery.animals.identify', 'discovery.animals.habitat'],
      worldId: 'discovery-island',
      title: 'Animal Explorer',
      contentQuery: ContentQuery(),
    ),
  ];
}

@immutable
class LearningActivityResult {
  const LearningActivityResult({
    required this.activityId,
    required this.skillIds,
    required this.contentItemIds,
    required this.totalItems,
    required this.correctItems,
    required this.duration,
    required this.completed,
    this.metadata = const {},
  }) : assert(totalItems >= 0),
       assert(correctItems >= 0),
       assert(correctItems <= totalItems);

  final String activityId;
  final List<String> skillIds;
  final List<String> contentItemIds;
  final int totalItems;
  final int correctItems;
  final Duration duration;
  final bool completed;
  final Map<String, Object?> metadata;

  double get accuracy => totalItems == 0 ? 0 : correctItems / totalItems;
}
