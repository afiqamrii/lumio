import 'package:flutter/foundation.dart';

enum LearningSubject {
  mathematics('math'),
  english('english'),
  bahasaMelayu('bahasa_melayu'),
  arabic('arabic'),
  logic('logic'),
  discovery('discovery');

  const LearningSubject(this.id);
  final String id;

  static LearningSubject parse(String id) => values.firstWhere(
    (subject) => subject.id == id,
    orElse: () => throw FormatException('Unknown subject ID: $id'),
  );
}

enum SkillDifficulty { foundation, developing, confident, advanced }

enum ContentStatus { draft, active, disabled }

enum TextDirectionHint { leftToRight, rightToLeft }

@immutable
class LocalizedLearningText {
  const LocalizedLearningText(this.values);

  factory LocalizedLearningText.fromJson(Object? source, String field) {
    if (source is! Map<String, dynamic>) {
      throw FormatException('$field must be a locale-to-text object.');
    }
    final values = <String, String>{};
    for (final entry in source.entries) {
      if (entry.value is! String || (entry.value as String).trim().isEmpty) {
        throw FormatException('$field.${entry.key} must be non-empty text.');
      }
      values[entry.key] = (entry.value as String).trim();
    }
    if (!values.containsKey('en') || !values.containsKey('ms')) {
      throw FormatException('$field must include en and ms text.');
    }
    return LocalizedLearningText(Map.unmodifiable(values));
  }

  final Map<String, String> values;

  String resolve(String locale) => values[locale] ?? values['en']!;
}

@immutable
class LearningSkill {
  const LearningSkill({
    required this.id,
    required this.subject,
    required this.code,
    required this.title,
    required this.description,
    required this.minimumAge,
    required this.recommendedAge,
    required this.difficulty,
    required this.prerequisiteSkillIds,
    required this.tags,
    required this.isActive,
  });

  factory LearningSkill.fromJson(Map<String, dynamic> json) => LearningSkill(
    id: _requiredString(json, 'id'),
    subject: LearningSubject.parse(_requiredString(json, 'subjectId')),
    code: _requiredString(json, 'code'),
    title: LocalizedLearningText.fromJson(json['title'], 'title'),
    description: LocalizedLearningText.fromJson(
      json['description'],
      'description',
    ),
    minimumAge: _requiredInt(json, 'minimumAge'),
    recommendedAge: _requiredInt(json, 'recommendedAge'),
    difficulty: _enumByName(
      SkillDifficulty.values,
      _requiredString(json, 'difficulty'),
      'difficulty',
    ),
    prerequisiteSkillIds: _stringList(json, 'prerequisiteSkillIds'),
    tags: _stringList(json, 'tags'),
    isActive: json['isActive'] as bool? ?? true,
  );

  final String id;
  final LearningSubject subject;
  final String code;
  final LocalizedLearningText title;
  final LocalizedLearningText description;
  final int minimumAge;
  final int recommendedAge;
  final SkillDifficulty difficulty;
  final List<String> prerequisiteSkillIds;
  final List<String> tags;
  final bool isActive;
}

@immutable
class ContentMetadata {
  const ContentMetadata({
    required this.id,
    required this.skillId,
    required this.difficulty,
    required this.locale,
    required this.minimumAge,
    required this.recommendedAge,
    required this.tags,
    required this.version,
    required this.status,
    required this.direction,
  });

  factory ContentMetadata.fromJson(Map<String, dynamic> json) {
    final locale = _requiredString(json, 'locale');
    return ContentMetadata(
      id: _requiredString(json, 'id'),
      skillId: _requiredString(json, 'skillId'),
      difficulty: _enumByName(
        SkillDifficulty.values,
        _requiredString(json, 'difficulty'),
        'difficulty',
      ),
      locale: locale,
      minimumAge: _requiredInt(json, 'minimumAge'),
      recommendedAge: _requiredInt(json, 'recommendedAge'),
      tags: _stringList(json, 'tags'),
      version: _requiredInt(json, 'version'),
      status: _enumByName(
        ContentStatus.values,
        _requiredString(json, 'status'),
        'status',
      ),
      direction: json['direction'] == null
          ? (locale == 'ar'
                ? TextDirectionHint.rightToLeft
                : TextDirectionHint.leftToRight)
          : _enumByName(
              TextDirectionHint.values,
              _requiredString(json, 'direction'),
              'direction',
            ),
    );
  }

  final String id;
  final String skillId;
  final SkillDifficulty difficulty;
  final String locale;
  final int minimumAge;
  final int recommendedAge;
  final List<String> tags;
  final int version;
  final ContentStatus status;
  final TextDirectionHint direction;
}

sealed class LearningContent {
  const LearningContent({required this.metadata, required this.prompt});

  factory LearningContent.fromJson(Map<String, dynamic> json) {
    final metadata = ContentMetadata.fromJson(json);
    final prompt = _requiredString(json, 'prompt');
    return switch (_requiredString(json, 'type')) {
      'multiple_choice' => MultipleChoiceContent(
        metadata: metadata,
        prompt: prompt,
        choices: _choiceList(json, 'choices'),
        correctChoiceId: _requiredString(json, 'correctChoiceId'),
      ),
      'matching' => MatchContent(
        metadata: metadata,
        prompt: prompt,
        pairs: _matchPairs(json, 'pairs'),
      ),
      'ordering' => OrderingContent(
        metadata: metadata,
        prompt: prompt,
        items: _choiceList(json, 'items'),
        correctOrder: _stringList(json, 'correctOrder'),
      ),
      'build_word' => BuildWordContent(
        metadata: metadata,
        prompt: prompt,
        targetWord: _requiredString(json, 'targetWord'),
        availableLetters: _stringList(json, 'availableLetters'),
      ),
      'numeric' => NumericContent(
        metadata: metadata,
        prompt: prompt,
        operands: _numberList(json, 'operands'),
        operatorSymbol: _requiredString(json, 'operator'),
        answer: _requiredNumber(json, 'answer'),
      ),
      'audio_choice' => AudioChoiceContent(
        metadata: metadata,
        prompt: prompt,
        audioAssetId: _requiredString(json, 'audioAssetId'),
        choices: _choiceList(json, 'choices'),
        correctChoiceId: _requiredString(json, 'correctChoiceId'),
      ),
      final type => throw FormatException('Unknown content type: $type'),
    };
  }

  final ContentMetadata metadata;
  final String prompt;
  String get type;
}

@immutable
class ContentChoice {
  const ContentChoice({required this.id, required this.label});
  final String id;
  final String label;
}

final class MultipleChoiceContent extends LearningContent {
  const MultipleChoiceContent({
    required super.metadata,
    required super.prompt,
    required this.choices,
    required this.correctChoiceId,
  });
  final List<ContentChoice> choices;
  final String correctChoiceId;
  @override
  String get type => 'multiple_choice';
}

@immutable
class MatchPair {
  const MatchPair({required this.left, required this.right});
  final String left;
  final String right;
}

final class MatchContent extends LearningContent {
  const MatchContent({
    required super.metadata,
    required super.prompt,
    required this.pairs,
  });
  final List<MatchPair> pairs;
  @override
  String get type => 'matching';
}

final class OrderingContent extends LearningContent {
  const OrderingContent({
    required super.metadata,
    required super.prompt,
    required this.items,
    required this.correctOrder,
  });
  final List<ContentChoice> items;
  final List<String> correctOrder;
  @override
  String get type => 'ordering';
}

final class BuildWordContent extends LearningContent {
  const BuildWordContent({
    required super.metadata,
    required super.prompt,
    required this.targetWord,
    required this.availableLetters,
  });
  final String targetWord;
  final List<String> availableLetters;
  @override
  String get type => 'build_word';
}

final class NumericContent extends LearningContent {
  const NumericContent({
    required super.metadata,
    required super.prompt,
    required this.operands,
    required this.operatorSymbol,
    required this.answer,
  });
  final List<num> operands;
  final String operatorSymbol;
  final num answer;
  @override
  String get type => 'numeric';
}

final class AudioChoiceContent extends LearningContent {
  const AudioChoiceContent({
    required super.metadata,
    required super.prompt,
    required this.audioAssetId,
    required this.choices,
    required this.correctChoiceId,
  });
  final String audioAssetId;
  final List<ContentChoice> choices;
  final String correctChoiceId;
  @override
  String get type => 'audio_choice';
}

@immutable
class LearningCatalog {
  const LearningCatalog({required this.skills, required this.content});
  final List<LearningSkill> skills;
  final List<LearningContent> content;
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('$key must be non-empty text.');
  }
  return value.trim();
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int) throw FormatException('$key must be an integer.');
  return value;
}

num _requiredNumber(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! num) throw FormatException('$key must be a number.');
  return value;
}

List<String> _stringList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List || value.any((item) => item is! String)) {
    throw FormatException('$key must be a text list.');
  }
  return List.unmodifiable(value.cast<String>());
}

List<num> _numberList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List || value.any((item) => item is! num)) {
    throw FormatException('$key must be a number list.');
  }
  return List.unmodifiable(value.cast<num>());
}

T _enumByName<T extends Enum>(List<T> values, String name, String field) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  throw FormatException('Unknown $field: $name');
}

List<ContentChoice> _choiceList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) throw FormatException('$key must be a list.');
  return List.unmodifiable(
    value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw FormatException('$key entries must be objects.');
      }
      return ContentChoice(
        id: _requiredString(item, 'id'),
        label: _requiredString(item, 'label'),
      );
    }),
  );
}

List<MatchPair> _matchPairs(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) throw FormatException('$key must be a list.');
  return List.unmodifiable(
    value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw FormatException('$key entries must be objects.');
      }
      return MatchPair(
        left: _requiredString(item, 'left'),
        right: _requiredString(item, 'right'),
      );
    }),
  );
}
