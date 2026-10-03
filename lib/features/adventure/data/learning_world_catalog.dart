import '../../progression/domain/unlock_condition.dart';
import '../domain/learning_world.dart';

/// Stable world catalog. Core learning subjects stay broadly available.
abstract final class LearningWorldCatalog {
  static const worlds = <LearningWorld>[
    LearningWorld(
      id: 'number-kingdom',
      visual: LearningWorldVisual.numberKingdom,
      unlockCondition: AlwaysUnlocked(),
      sortOrder: 0,
    ),
    LearningWorld(
      id: 'word-woods',
      visual: LearningWorldVisual.wordWoods,
      unlockCondition: AlwaysUnlocked(),
      sortOrder: 1,
    ),
    LearningWorld(
      id: 'language-village',
      visual: LearningWorldVisual.languageVillage,
      unlockCondition: AlwaysUnlocked(),
      sortOrder: 2,
    ),
    LearningWorld(
      id: 'arabic-oasis',
      visual: LearningWorldVisual.arabicOasis,
      unlockCondition: AlwaysUnlocked(),
      sortOrder: 3,
    ),
    LearningWorld(
      id: 'logic-lab',
      visual: LearningWorldVisual.logicLab,
      unlockCondition: AlwaysUnlocked(),
      sortOrder: 4,
    ),
    LearningWorld(
      id: 'discovery-island',
      visual: LearningWorldVisual.discoveryIsland,
      unlockCondition: AlwaysUnlocked(),
      sortOrder: 5,
    ),
  ];

  static LearningWorld? byId(String id) {
    for (final world in worlds) {
      if (world.id == id) return world;
    }
    return null;
  }
}
