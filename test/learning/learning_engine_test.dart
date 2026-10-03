import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/features/learning/data/local_learning_content_repository.dart';
import 'package:lumio/features/learning/domain/activity_models.dart';
import 'package:lumio/features/learning/domain/answer_evaluator.dart';
import 'package:lumio/features/learning/domain/learning_catalog_validator.dart';
import 'package:lumio/features/learning/domain/learning_models.dart';
import 'package:lumio/features/learning/domain/learning_session_builder.dart';
import 'package:lumio/features/learning/domain/starting_skill_recommender.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LearningCatalog catalog;

  setUpAll(() async {
    catalog = await LocalLearningContentRepository().loadCatalog();
  });

  test('catalog has unique valid skills and the intended subject coverage', () {
    LearningCatalogValidator.validate(catalog);
    expect(catalog.skills.map((skill) => skill.id).toSet(), hasLength(75));
    expect(
      catalog.content.map((item) => item.metadata.id).toSet(),
      hasLength(108),
    );
    expect(_skillCounts(catalog), {
      LearningSubject.mathematics: 15,
      LearningSubject.english: 12,
      LearningSubject.bahasaMelayu: 12,
      LearningSubject.arabic: 12,
      LearningSubject.logic: 12,
      LearningSubject.discovery: 12,
    });
    expect(_contentCounts(catalog), {
      LearningSubject.mathematics: 24,
      LearningSubject.english: 18,
      LearningSubject.bahasaMelayu: 18,
      LearningSubject.arabic: 18,
      LearningSubject.logic: 15,
      LearningSubject.discovery: 15,
    });
  });

  test('all prerequisites exist and graph rejects cycles and duplicates', () {
    final first = _skill(
      'math.test.first',
      prerequisites: ['math.test.second'],
    );
    final second = _skill(
      'math.test.second',
      prerequisites: ['math.test.first'],
    );
    expect(
      () => LearningCatalogValidator.validate(
        LearningCatalog(skills: [first, second], content: const []),
      ),
      throwsA(isA<CatalogValidationException>()),
    );
    final duplicated = _skill(
      'math.test.duplicate',
      prerequisites: ['math.test.first', 'math.test.first'],
    );
    expect(
      () => LearningCatalogValidator.validate(
        LearningCatalog(
          skills: [_skill('math.test.first'), duplicated],
          content: const [],
        ),
      ),
      throwsA(isA<CatalogValidationException>()),
    );
  });

  test('parser accepts valid files and rejects malformed content', () async {
    final source = await rootBundle.loadString('assets/content/arabic.json');
    final parsed = LocalLearningContentRepository.parseCatalogFile(source);
    expect(parsed.skills, hasLength(12));
    expect(parsed.content, hasLength(18));
    expect(
      () => LocalLearningContentRepository.parseCatalogFile('{"skills": []}'),
      throwsFormatException,
    );
    expect(
      () => LocalLearningContentRepository.parseCatalogFile('not json'),
      throwsFormatException,
    );
  });

  test('invalid multiple choice item is rejected', () {
    final item = MultipleChoiceContent(
      metadata: _metadata('math.test.bad', 'math.test.skill'),
      prompt: 'Choose one.',
      choices: const [
        ContentChoice(id: 'a', label: 'One'),
        ContentChoice(id: 'b', label: 'Two'),
      ],
      correctChoiceId: 'missing',
    );
    expect(
      () => LearningCatalogValidator.validate(
        LearningCatalog(skills: [_skill('math.test.skill')], content: [item]),
      ),
      throwsA(isA<CatalogValidationException>()),
    );
  });

  test('English, BM and Arabic load independently of the UI locale', () {
    final locales = catalog.content.map((item) => item.metadata.locale).toSet();
    expect(locales, containsAll(['en', 'ms', 'ar']));
    final arabic = catalog.content.where(
      (item) => item.metadata.locale == 'ar',
    );
    expect(arabic, isNotEmpty);
    expect(
      arabic.every(
        (item) => item.metadata.direction == TextDirectionHint.rightToLeft,
      ),
      isTrue,
    );
    expect(arabic.any((item) => item.prompt.contains('اختر')), isTrue);
  });

  test('every supported age receives only known starter recommendations', () {
    final known = catalog.skills.map((skill) => skill.id).toSet();
    for (var age = 5; age <= 9; age++) {
      for (final subject in LearningSubject.values) {
        final result = StartingSkillRecommender.recommend(
          age: age,
          subject: subject,
          skills: catalog.skills,
        );
        expect(result, isNotEmpty, reason: '$subject at age $age');
        expect(result.every((skill) => known.contains(skill.id)), isTrue);
        expect(result.every((skill) => skill.subject == subject), isTrue);
      }
    }
    final ageFive = StartingSkillRecommender.recommend(
      age: 5,
      subject: LearningSubject.mathematics,
      skills: catalog.skills,
    );
    final ageSeven = StartingSkillRecommender.recommend(
      age: 7,
      subject: LearningSubject.mathematics,
      skills: catalog.skills,
    );
    expect(ageSeven.length, greaterThan(ageFive.length));
    expect(
      ageSeven.map((skill) => skill.id),
      contains('math.counting.1_to_10'),
    );
  });

  test('session builder filters, is deterministic and handles scarcity', () {
    const activity = ActivityDefinition(
      id: 'test.addition',
      gameType: LearningGameType.numberRush,
      skillIds: ['math.addition.within_5'],
      worldId: 'number-kingdom',
      title: 'Test',
      contentQuery: ContentQuery(locales: ['en']),
    );
    final first = const LearningSessionBuilder().build(
      childId: 'child-a',
      activity: activity,
      skillId: 'math.addition.within_5',
      content: catalog.content,
      itemCount: 20,
      seed: 42,
    );
    final repeated = const LearningSessionBuilder().build(
      childId: 'child-a',
      activity: activity,
      skillId: 'math.addition.within_5',
      content: catalog.content,
      itemCount: 20,
      seed: 42,
    );
    expect(first.items, hasLength(2));
    expect(
      first.items.map((item) => item.metadata.id),
      orderedEquals(repeated.items.map((item) => item.metadata.id)),
    );
    expect(first.items.map((item) => item.metadata.id).toSet(), hasLength(2));
    expect(
      first.items.every(
        (item) => item.metadata.skillId == 'math.addition.within_5',
      ),
      isTrue,
    );
  });

  test(
    'generic answer evaluation supports choice, ordering, numeric and word',
    () {
      final choice = catalog.content.whereType<MultipleChoiceContent>().first;
      expect(
        AnswerEvaluator.evaluate(choice, choice.correctChoiceId).correct,
        isTrue,
      );
      expect(AnswerEvaluator.evaluate(choice, 'wrong').correct, isFalse);

      final ordering = catalog.content.whereType<OrderingContent>().first;
      expect(
        AnswerEvaluator.evaluate(ordering, ordering.correctOrder).correct,
        isTrue,
      );
      expect(
        AnswerEvaluator.evaluate(
          ordering,
          ordering.correctOrder.reversed.toList(),
        ).correct,
        isFalse,
      );

      final numeric = catalog.content.whereType<NumericContent>().first;
      expect(AnswerEvaluator.evaluate(numeric, numeric.answer).correct, isTrue);

      final word = catalog.content.whereType<BuildWordContent>().first;
      expect(
        AnswerEvaluator.evaluate(word, word.targetWord.toUpperCase()).correct,
        isTrue,
      );
    },
  );
}

Map<LearningSubject, int> _skillCounts(LearningCatalog catalog) => {
  for (final subject in LearningSubject.values)
    subject: catalog.skills.where((skill) => skill.subject == subject).length,
};

Map<LearningSubject, int> _contentCounts(LearningCatalog catalog) {
  final subjectBySkill = {
    for (final skill in catalog.skills) skill.id: skill.subject,
  };
  return {
    for (final subject in LearningSubject.values)
      subject: catalog.content
          .where((item) => subjectBySkill[item.metadata.skillId] == subject)
          .length,
  };
}

LearningSkill _skill(String id, {List<String> prerequisites = const []}) =>
    LearningSkill(
      id: id,
      subject: LearningSubject.mathematics,
      code: id.split('.').skip(1).join('_'),
      title: const LocalizedLearningText({'en': 'Test', 'ms': 'Ujian'}),
      description: const LocalizedLearningText({
        'en': 'Test skill.',
        'ms': 'Kemahiran ujian.',
      }),
      minimumAge: 5,
      recommendedAge: 5,
      difficulty: SkillDifficulty.foundation,
      prerequisiteSkillIds: prerequisites,
      tags: const ['test'],
      isActive: true,
    );

ContentMetadata _metadata(String id, String skillId) => ContentMetadata(
  id: id,
  skillId: skillId,
  difficulty: SkillDifficulty.foundation,
  locale: 'en',
  minimumAge: 5,
  recommendedAge: 5,
  tags: const ['test'],
  version: 1,
  status: ContentStatus.active,
  direction: TextDirectionHint.leftToRight,
);
