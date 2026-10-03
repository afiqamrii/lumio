import 'activity_models.dart';
import 'learning_models.dart';

class CatalogValidationException implements Exception {
  const CatalogValidationException(this.errors);
  final List<String> errors;

  @override
  String toString() => 'Learning catalog is invalid:\n${errors.join('\n')}';
}

abstract final class LearningCatalogValidator {
  static void validate(LearningCatalog catalog) {
    final errors = <String>[];
    final skills = <String, LearningSkill>{};
    for (final skill in catalog.skills) {
      if (skills.containsKey(skill.id)) {
        errors.add('Duplicate skill ID: ${skill.id}');
      } else {
        skills[skill.id] = skill;
      }
      if (!_validStableId(skill.id, skill.subject.id)) {
        errors.add('Invalid skill ID: ${skill.id}');
      }
      if (skill.minimumAge < 5 ||
          skill.recommendedAge < skill.minimumAge ||
          skill.recommendedAge > 9) {
        errors.add('Invalid age range for ${skill.id}');
      }
      if (skill.prerequisiteSkillIds.toSet().length !=
          skill.prerequisiteSkillIds.length) {
        errors.add('Duplicate prerequisite on ${skill.id}');
      }
    }
    for (final skill in catalog.skills) {
      for (final prerequisite in skill.prerequisiteSkillIds) {
        if (!skills.containsKey(prerequisite)) {
          errors.add('Unknown prerequisite $prerequisite on ${skill.id}');
        }
        if (prerequisite == skill.id) {
          errors.add('Skill ${skill.id} cannot require itself');
        }
      }
    }
    _findCycles(skills, errors);

    final contentIds = <String>{};
    for (final item in catalog.content) {
      final metadata = item.metadata;
      if (!contentIds.add(metadata.id)) {
        errors.add('Duplicate content ID: ${metadata.id}');
      }
      if (!RegExp(r'^[a-z][a-z0-9_.-]+$').hasMatch(metadata.id)) {
        errors.add('Invalid content ID: ${metadata.id}');
      }
      if (!skills.containsKey(metadata.skillId)) {
        errors.add('Unknown skill ${metadata.skillId} on ${metadata.id}');
      }
      if (!const {'en', 'ms', 'ar'}.contains(metadata.locale)) {
        errors.add('Unsupported locale ${metadata.locale} on ${metadata.id}');
      }
      if (metadata.version < 1 ||
          metadata.minimumAge < 5 ||
          metadata.recommendedAge < metadata.minimumAge ||
          metadata.recommendedAge > 9) {
        errors.add('Invalid metadata on ${metadata.id}');
      }
      if (metadata.locale == 'ar' &&
          metadata.direction != TextDirectionHint.rightToLeft) {
        errors.add('Arabic content must be right-to-left: ${metadata.id}');
      }
      _validateItem(item, errors);
    }
    final activityIds = <String>{};
    for (final activity in ActivityCatalog.activities) {
      if (!activityIds.add(activity.id)) {
        errors.add('Duplicate activity ID: ${activity.id}');
      }
      for (final skillId in activity.skillIds) {
        if (!skills.containsKey(skillId)) {
          errors.add('Unknown skill $skillId on activity ${activity.id}');
        }
      }
    }
    if (errors.isNotEmpty) {
      throw CatalogValidationException(List.unmodifiable(errors));
    }
  }

  static bool _validStableId(String id, String subjectId) =>
      id.startsWith('$subjectId.') &&
      RegExp(r'^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$').hasMatch(id);

  static void _findCycles(
    Map<String, LearningSkill> skills,
    List<String> errors,
  ) {
    final visiting = <String>{};
    final visited = <String>{};

    bool visit(String id) {
      if (visiting.contains(id)) return true;
      if (visited.contains(id)) return false;
      visiting.add(id);
      for (final prerequisite in skills[id]!.prerequisiteSkillIds) {
        if (skills.containsKey(prerequisite) && visit(prerequisite)) {
          return true;
        }
      }
      visiting.remove(id);
      visited.add(id);
      return false;
    }

    for (final id in skills.keys) {
      if (visit(id)) {
        errors.add('Prerequisite cycle contains $id');
        return;
      }
    }
  }

  static void _validateItem(LearningContent item, List<String> errors) {
    if (item.prompt.contains('\uFFFD') ||
        item.prompt.runes.any((rune) => rune < 32 && rune != 10)) {
      errors.add('Invalid Unicode or control text on ${item.metadata.id}');
    }
    if (item.metadata.locale == 'ar' &&
        !RegExp(r'[\u0600-\u06FF]').hasMatch(item.prompt)) {
      errors.add('Arabic content has no Arabic text: ${item.metadata.id}');
    }
    switch (item) {
      case MultipleChoiceContent(:final choices, :final correctChoiceId):
        _validateChoices(item.metadata.id, choices, errors);
        if (!choices.any((choice) => choice.id == correctChoiceId)) {
          errors.add('Correct choice is missing on ${item.metadata.id}');
        }
      case AudioChoiceContent(:final choices, :final correctChoiceId):
        _validateChoices(item.metadata.id, choices, errors);
        if (!choices.any((choice) => choice.id == correctChoiceId)) {
          errors.add('Correct audio choice is missing on ${item.metadata.id}');
        }
      case OrderingContent(:final items, :final correctOrder):
        _validateChoices(item.metadata.id, items, errors);
        if (items.length != correctOrder.length ||
            items
                .map((choice) => choice.id)
                .toSet()
                .difference(correctOrder.toSet())
                .isNotEmpty ||
            correctOrder.toSet().length != correctOrder.length) {
          errors.add('Invalid target order on ${item.metadata.id}');
        }
      case MatchContent(:final pairs):
        if (pairs.length < 2 ||
            pairs.map((pair) => pair.left).toSet().length != pairs.length ||
            pairs.map((pair) => pair.right).toSet().length != pairs.length) {
          errors.add('Invalid matching pairs on ${item.metadata.id}');
        }
      case BuildWordContent(:final targetWord, :final availableLetters):
        final available = [...availableLetters];
        for (final rune in targetWord.replaceAll(' ', '').runes) {
          final letter = String.fromCharCode(rune);
          final index = available.indexWhere(
            (candidate) => candidate.toLowerCase() == letter.toLowerCase(),
          );
          if (index < 0) {
            errors.add('Target cannot be built on ${item.metadata.id}');
            break;
          }
          available.removeAt(index);
        }
      case NumericContent(:final operands, :final operatorSymbol):
        if (operands.isEmpty ||
            !const {'+', '-', '×', '÷'}.contains(operatorSymbol)) {
          errors.add('Invalid numeric content on ${item.metadata.id}');
        }
    }
  }

  static void _validateChoices(
    String id,
    List<ContentChoice> choices,
    List<String> errors,
  ) {
    if (choices.length < 2 || choices.length > 6) {
      errors.add('Content $id must have 2–6 choices');
    }
    if (choices.map((choice) => choice.id).toSet().length != choices.length ||
        choices.map((choice) => choice.label).toSet().length !=
            choices.length) {
      errors.add('Content $id has duplicate choices');
    }
  }
}
