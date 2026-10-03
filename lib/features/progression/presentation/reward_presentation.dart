import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../domain/progression_models.dart';

extension AchievementPresentation on AchievementId {
  String title(AppLocalizations strings) => switch (this) {
    AchievementId.firstGlow => strings.firstGlowTitle,
    AchievementId.starCollector => strings.starCollectorTitle,
    AchievementId.curiousExplorer => strings.curiousExplorerTitle,
    AchievementId.brightBeginning => strings.brightBeginningTitle,
  };

  String description(AppLocalizations strings) => switch (this) {
    AchievementId.firstGlow => strings.firstGlowDescription,
    AchievementId.starCollector => strings.starCollectorDescription,
    AchievementId.curiousExplorer => strings.curiousExplorerDescription,
    AchievementId.brightBeginning => strings.brightBeginningDescription,
  };

  IconData get icon => switch (this) {
    AchievementId.firstGlow => Icons.auto_awesome_rounded,
    AchievementId.starCollector => Icons.star_rounded,
    AchievementId.curiousExplorer => Icons.explore_rounded,
    AchievementId.brightBeginning => Icons.wb_sunny_rounded,
  };
}
