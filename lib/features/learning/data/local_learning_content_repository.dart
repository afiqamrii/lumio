import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/learning_catalog_validator.dart';
import '../domain/learning_content_repository.dart';
import '../domain/learning_models.dart';
import '../domain/starting_skill_recommender.dart';

class LocalLearningContentRepository implements LearningContentRepository {
  LocalLearningContentRepository({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  static const assetPaths = <String>[
    'assets/content/math.json',
    'assets/content/english.json',
    'assets/content/bahasa_melayu.json',
    'assets/content/arabic.json',
    'assets/content/logic.json',
    'assets/content/discovery.json',
  ];

  final AssetBundle _bundle;
  Future<LearningCatalog>? _cachedCatalog;

  @override
  Future<LearningCatalog> loadCatalog() =>
      _cachedCatalog ??= _loadAndValidate();

  Future<LearningCatalog> _loadAndValidate() async {
    final skills = <LearningSkill>[];
    final content = <LearningContent>[];
    for (final path in assetPaths) {
      final source = await _bundle.loadString(path);
      final catalog = parseCatalogFile(source, sourceName: path);
      skills.addAll(catalog.skills);
      content.addAll(catalog.content);
    }
    final result = LearningCatalog(
      skills: List.unmodifiable(skills),
      content: List.unmodifiable(content),
    );
    LearningCatalogValidator.validate(result);
    return result;
  }

  static LearningCatalog parseCatalogFile(
    String source, {
    String sourceName = 'catalog',
  }) {
    try {
      final decoded = jsonDecode(source);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Catalog root must be an object.');
      }
      final rawSkills = decoded['skills'];
      final rawContent = decoded['content'];
      if (rawSkills is! List || rawContent is! List) {
        throw const FormatException(
          'Catalog requires skills and content lists.',
        );
      }
      return LearningCatalog(
        skills: List.unmodifiable(
          rawSkills.map((entry) {
            if (entry is! Map<String, dynamic>) {
              throw const FormatException('Skill entries must be objects.');
            }
            return LearningSkill.fromJson(entry);
          }),
        ),
        content: List.unmodifiable(
          rawContent.map((entry) {
            if (entry is! Map<String, dynamic>) {
              throw const FormatException('Content entries must be objects.');
            }
            return LearningContent.fromJson(entry);
          }),
        ),
      );
    } on FormatException catch (error) {
      throw FormatException('$sourceName: ${error.message}');
    }
  }

  @override
  Future<List<LearningSkill>> getSkillsBySubject(
    LearningSubject subject,
  ) async => (await loadCatalog()).skills
      .where((skill) => skill.subject == subject && skill.isActive)
      .toList(growable: false);

  @override
  Future<LearningSkill?> getSkillById(String id) async {
    for (final skill in (await loadCatalog()).skills) {
      if (skill.id == id) return skill;
    }
    return null;
  }

  @override
  Future<List<LearningContent>> getContentForSkill(
    String skillId, {
    String? learningLocale,
  }) async => (await loadCatalog()).content
      .where(
        (item) =>
            item.metadata.skillId == skillId &&
            item.metadata.status == ContentStatus.active &&
            (learningLocale == null || item.metadata.locale == learningLocale),
      )
      .toList(growable: false);

  @override
  Future<LearningContent?> getContentById(String id) async {
    for (final item in (await loadCatalog()).content) {
      if (item.metadata.id == id) return item;
    }
    return null;
  }

  @override
  Future<List<LearningSkill>> getPrerequisites(String skillId) async {
    final catalog = await loadCatalog();
    final skill = catalog.skills
        .where((entry) => entry.id == skillId)
        .firstOrNull;
    if (skill == null) return const [];
    final byId = {for (final entry in catalog.skills) entry.id: entry};
    return skill.prerequisiteSkillIds
        .map((id) => byId[id])
        .whereType<LearningSkill>()
        .toList(growable: false);
  }

  @override
  Future<List<LearningSkill>> getRecommendedStartingSkills({
    required int age,
    required LearningSubject subject,
  }) async => StartingSkillRecommender.recommend(
    age: age,
    subject: subject,
    skills: (await loadCatalog()).skills,
  );
}
