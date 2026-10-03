import 'package:flutter/material.dart';

import '../../../core/design_system.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/learning_world.dart';

extension LearningWorldPresentation on LearningWorld {
  String title(AppLocalizations strings) => switch (visual) {
    LearningWorldVisual.numberKingdom => strings.numberWorld,
    LearningWorldVisual.wordWoods => strings.wordWorld,
    LearningWorldVisual.languageVillage => strings.languageWorld,
    LearningWorldVisual.arabicOasis => strings.arabicWorld,
    LearningWorldVisual.logicLab => strings.logicWorld,
    LearningWorldVisual.discoveryIsland => strings.discoveryWorld,
  };

  String subject(AppLocalizations strings) => switch (visual) {
    LearningWorldVisual.numberKingdom => strings.mathSubject,
    LearningWorldVisual.wordWoods => strings.englishSubject,
    LearningWorldVisual.languageVillage => strings.malaySubject,
    LearningWorldVisual.arabicOasis => strings.arabicSubject,
    LearningWorldVisual.logicLab => strings.logicSubject,
    LearningWorldVisual.discoveryIsland => strings.scienceSubject,
  };

  String description(AppLocalizations strings) => switch (visual) {
    LearningWorldVisual.numberKingdom => strings.numberWorldLanding,
    LearningWorldVisual.wordWoods => strings.wordWorldLanding,
    LearningWorldVisual.languageVillage => strings.languageWorldLanding,
    LearningWorldVisual.arabicOasis => strings.arabicWorldLanding,
    LearningWorldVisual.logicLab => strings.logicWorldLanding,
    LearningWorldVisual.discoveryIsland => strings.discoveryWorldLanding,
  };

  IconData get icon => switch (visual) {
    LearningWorldVisual.numberKingdom => Icons.castle_rounded,
    LearningWorldVisual.wordWoods => Icons.menu_book_rounded,
    LearningWorldVisual.languageVillage => Icons.holiday_village_rounded,
    LearningWorldVisual.arabicOasis => Icons.nights_stay_rounded,
    LearningWorldVisual.logicLab => Icons.precision_manufacturing_rounded,
    LearningWorldVisual.discoveryIsland => Icons.travel_explore_rounded,
  };

  Color get color => switch (visual) {
    LearningWorldVisual.numberKingdom => LumioColors.peach,
    LearningWorldVisual.wordWoods => LumioColors.mint,
    LearningWorldVisual.languageVillage => LumioColors.butter,
    LearningWorldVisual.arabicOasis => LumioColors.lavender,
    LearningWorldVisual.logicLab => LumioColors.sky,
    LearningWorldVisual.discoveryIsland => LumioColors.cloudSoft,
  };

  Color get accent => switch (visual) {
    LearningWorldVisual.numberKingdom => const Color(0xFFE36C52),
    LearningWorldVisual.wordWoods => const Color(0xFF21896A),
    LearningWorldVisual.languageVillage => const Color(0xFFC77818),
    LearningWorldVisual.arabicOasis => LumioColors.primaryPressed,
    LearningWorldVisual.logicLab => const Color(0xFF3976B8),
    LearningWorldVisual.discoveryIsland => const Color(0xFF16858A),
  };
}
