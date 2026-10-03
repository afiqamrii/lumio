import 'package:flutter/foundation.dart';

import '../../progression/domain/progression_models.dart';
import '../../progression/domain/unlock_condition.dart';

enum LearningWorldVisual {
  numberKingdom,
  wordWoods,
  languageVillage,
  arabicOasis,
  logicLab,
  discoveryIsland,
}

/// Stable world identity with a progression-ready access condition.
@immutable
class LearningWorld {
  const LearningWorld({
    required this.id,
    required this.visual,
    required this.unlockCondition,
    required this.sortOrder,
  });

  final String id;
  final LearningWorldVisual visual;
  final UnlockCondition unlockCondition;
  final int sortOrder;

  bool canEnter(ProgressionSnapshot snapshot) =>
      unlockCondition.isMet(UnlockContext(snapshot: snapshot));
}
