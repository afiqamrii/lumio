import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../../core/widgets/lumio_action_surface.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/learning_store.dart';
import '../domain/activity_models.dart';
import '../domain/learning_catalog_validator.dart';
import '../domain/learning_models.dart';
import '../domain/learning_session_builder.dart';

/// Development-only catalog inspector. The router never registers this screen
/// in release/profile builds or production configuration.
class LearningContentBrowserScreen extends ConsumerStatefulWidget {
  const LearningContentBrowserScreen({super.key});

  @override
  ConsumerState<LearningContentBrowserScreen> createState() =>
      _LearningContentBrowserScreenState();
}

class _LearningContentBrowserScreenState
    extends ConsumerState<LearningContentBrowserScreen> {
  LearningSubject _subject = LearningSubject.mathematics;
  String? _skillId;
  int _seed = 6042;
  LearningSession? _session;
  String? _validationMessage;
  bool _validationError = false;

  void _selectSubject(LearningSubject subject) {
    setState(() {
      _subject = subject;
      _skillId = null;
      _session = null;
    });
  }

  void _selectSkill(String skillId) {
    setState(() {
      _skillId = skillId;
      _session = null;
    });
  }

  void _buildSession(LearningCatalog catalog, {required bool newSeed}) {
    final skillId = _skillId;
    if (skillId == null) return;
    final seed = newSeed ? _seed + 1 : _seed;
    final activity = ActivityDefinition(
      id: 'debug.catalog.$skillId',
      gameType: _gameTypeFor(_subject),
      skillIds: [skillId],
      worldId: _worldFor(_subject),
      title: 'Catalog test session',
      contentQuery: const ContentQuery(),
    );
    final session = const LearningSessionBuilder().build(
      childId: 'debug-content-browser',
      activity: activity,
      skillId: skillId,
      content: catalog.content,
      itemCount: 5,
      seed: seed,
    );
    setState(() {
      _seed = seed;
      _session = session;
    });
  }

  void _validate(LearningCatalog catalog) {
    final strings = AppLocalizations.of(context);
    try {
      LearningCatalogValidator.validate(catalog);
      setState(() {
        _validationError = false;
        _validationMessage = strings.catalogValid;
      });
    } on CatalogValidationException catch (error) {
      setState(() {
        _validationError = true;
        _validationMessage = strings.catalogInvalid(error.errors.join(' · '));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final catalog = ref.watch(learningCatalogProvider);
    return LumioScaffold(
      maxContentWidth: 980,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              LumioIconButton(
                label: MaterialLocalizations.of(context).backButtonTooltip,
                icon: Icons.arrow_back_rounded,
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: LumioSpacing.md),
              Expanded(
                child: Text(
                  strings.learningContentBrowser,
                  style: LumioTypography.headingMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: LumioSpacing.lg),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: LumioBadge(label: strings.debugOnly),
          ),
          const SizedBox(height: LumioSpacing.md),
          Text(
            strings.learningContentBrowserIntro,
            style: LumioTypography.bodyLarge,
          ),
          const SizedBox(height: LumioSpacing.xl),
          catalog.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => LumioCard(
              color: LumioColors.peach,
              child: Text(strings.catalogLoadError('$error')),
            ),
            data: (value) => _CatalogBody(
              catalog: value,
              subject: _subject,
              selectedSkillId: _skillId,
              session: _session,
              validationMessage: _validationMessage,
              validationError: _validationError,
              onSubject: _selectSubject,
              onSkill: _selectSkill,
              onBuild: () => _buildSession(value, newSeed: false),
              onSameSeed: () => _buildSession(value, newSeed: false),
              onNewSeed: () => _buildSession(value, newSeed: true),
              onValidate: () => _validate(value),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({
    required this.catalog,
    required this.subject,
    required this.selectedSkillId,
    required this.session,
    required this.validationMessage,
    required this.validationError,
    required this.onSubject,
    required this.onSkill,
    required this.onBuild,
    required this.onSameSeed,
    required this.onNewSeed,
    required this.onValidate,
  });

  final LearningCatalog catalog;
  final LearningSubject subject;
  final String? selectedSkillId;
  final LearningSession? session;
  final String? validationMessage;
  final bool validationError;
  final ValueChanged<LearningSubject> onSubject;
  final ValueChanged<String> onSkill;
  final VoidCallback onBuild;
  final VoidCallback onSameSeed;
  final VoidCallback onNewSeed;
  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final skills = catalog.skills
        .where((skill) => skill.subject == subject)
        .toList(growable: false);
    final selected = skills
        .where((skill) => skill.id == selectedSkillId)
        .firstOrNull;
    final effective = selected ?? skills.first;
    final content = catalog.content
        .where((item) => item.metadata.skillId == effective.id)
        .toList(growable: false);
    if (selectedSkillId == null) {
      scheduleMicrotask(() => onSkill(effective.id));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.selectSubject, style: LumioTypography.headingSmall),
        const SizedBox(height: LumioSpacing.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final entry in LearningSubject.values)
              _SelectionPill(
                label: _subjectName(strings, entry),
                selected: subject == entry,
                onTap: () => onSubject(entry),
              ),
          ],
        ),
        const SizedBox(height: LumioSpacing.xl),
        LayoutBuilder(
          builder: (context, bounds) {
            final skillList = _SkillList(
              skills: skills,
              selectedId: effective.id,
              locale: locale,
              onSkill: onSkill,
            );
            final detail = _SkillDetail(
              skill: effective,
              content: content,
              locale: locale,
              onBuild: onBuild,
            );
            if (bounds.maxWidth < 720) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CompactSkillPicker(
                    skills: skills,
                    selectedId: effective.id,
                    locale: locale,
                    onSkill: onSkill,
                  ),
                  const SizedBox(height: 20),
                  detail,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 300, child: skillList),
                const SizedBox(width: 20),
                Expanded(child: detail),
              ],
            );
          },
        ),
        if (session case final session?) ...[
          const SizedBox(height: LumioSpacing.xl),
          _SessionCard(
            session: session,
            onSameSeed: onSameSeed,
            onNewSeed: onNewSeed,
          ),
        ],
        const SizedBox(height: LumioSpacing.xl),
        LumioCard(
          color: LumioColors.mint,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LumioButton(
                label: strings.validateLearningCatalog,
                icon: Icons.fact_check_outlined,
                variant: LumioButtonVariant.outline,
                onPressed: onValidate,
              ),
              if (validationMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  validationMessage!,
                  style: LumioTypography.bodyMedium.copyWith(
                    color: validationError
                        ? LumioColors.error
                        : LumioColors.success,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectionPill extends StatelessWidget {
  const _SelectionPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => LumioActionSurface(
    label: label,
    onTap: onTap,
    background: selected ? LumioColors.primary : LumioColors.surface,
    foreground: selected ? LumioColors.onPrimary : LumioColors.textPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    radius: BorderRadius.circular(999),
    child: Text(
      label,
      style: LumioTypography.labelMedium.copyWith(
        color: selected ? LumioColors.onPrimary : LumioColors.textPrimary,
      ),
    ),
  );
}

class _CompactSkillPicker extends StatelessWidget {
  const _CompactSkillPicker({
    required this.skills,
    required this.selectedId,
    required this.locale,
    required this.onSkill,
  });
  final List<LearningSkill> skills;
  final String selectedId;
  final String locale;
  final ValueChanged<String> onSkill;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.skillsTitle, style: LumioTypography.headingSmall),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final skill in skills) ...[
                _SelectionPill(
                  label: skill.title.resolve(locale),
                  selected: skill.id == selectedId,
                  onTap: () => onSkill(skill.id),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SkillList extends StatelessWidget {
  const _SkillList({
    required this.skills,
    required this.selectedId,
    required this.locale,
    required this.onSkill,
  });
  final List<LearningSkill> skills;
  final String selectedId;
  final String locale;
  final ValueChanged<String> onSkill;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.skillsTitle, style: LumioTypography.headingSmall),
        const SizedBox(height: 10),
        for (final skill in skills) ...[
          LumioActionSurface(
            label: skill.title.resolve(locale),
            onTap: () => onSkill(skill.id),
            background: skill.id == selectedId
                ? LumioColors.lavender
                : LumioColors.surface,
            foreground: LumioColors.textPrimary,
            padding: const EdgeInsets.all(14),
            radius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.title.resolve(locale),
                  style: LumioTypography.labelMedium,
                ),
                const SizedBox(height: 4),
                Text(skill.id, style: LumioTypography.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _SkillDetail extends StatelessWidget {
  const _SkillDetail({
    required this.skill,
    required this.content,
    required this.locale,
    required this.onBuild,
  });
  final LearningSkill skill;
  final List<LearningContent> content;
  final String locale;
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return LumioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            skill.title.resolve(locale),
            style: LumioTypography.headingMedium,
          ),
          const SizedBox(height: 6),
          SelectableText(skill.id, style: LumioTypography.bodySmall),
          const SizedBox(height: 12),
          Text(skill.description.resolve(locale)),
          const SizedBox(height: 14),
          Text(
            '${strings.difficultyLabel}: ${skill.difficulty.name}',
            style: LumioTypography.labelMedium,
          ),
          const SizedBox(height: 6),
          Text(
            '${strings.prerequisitesLabel}: ${skill.prerequisiteSkillIds.isEmpty ? strings.noPrerequisites : skill.prerequisiteSkillIds.join(', ')}',
            style: LumioTypography.bodySmall,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.contentItemsTitle,
                  style: LumioTypography.headingSmall,
                ),
              ),
              LumioBadge(label: strings.contentCount(content.length)),
            ],
          ),
          const SizedBox(height: 10),
          for (final item in content) ...[
            _ContentTile(item: item),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 10),
          LumioButton(
            label: strings.buildTestSession,
            icon: Icons.shuffle_rounded,
            onPressed: content.isEmpty ? null : onBuild,
          ),
        ],
      ),
    );
  }
}

class _ContentTile extends StatelessWidget {
  const _ContentTile({required this.item});
  final LearningContent item;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final rtl = item.metadata.direction == TextDirectionHint.rightToLeft;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LumioColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              LumioBadge(label: item.type),
              LumioBadge(label: item.metadata.locale),
            ],
          ),
          const SizedBox(height: 8),
          Directionality(
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            child: Text(item.prompt, style: LumioTypography.bodyMedium),
          ),
          const SizedBox(height: 4),
          Text(
            '${strings.contentTypeLabel}: ${item.metadata.id}',
            style: LumioTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    required this.onSameSeed,
    required this.onNewSeed,
  });
  final LearningSession session;
  final VoidCallback onSameSeed;
  final VoidCallback onNewSeed;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return LumioCard(
      color: LumioColors.lavender,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.testSessionTitle(session.seed),
            style: LumioTypography.headingSmall,
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < session.items.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('${index + 1}. ${session.items[index].metadata.id}'),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              LumioButton(
                label: strings.sameSeed,
                variant: LumioButtonVariant.outline,
                onPressed: onSameSeed,
              ),
              LumioButton(
                label: strings.anotherSeed,
                variant: LumioButtonVariant.secondary,
                onPressed: onNewSeed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _subjectName(AppLocalizations strings, LearningSubject subject) =>
    switch (subject) {
      LearningSubject.mathematics => strings.mathSubject,
      LearningSubject.english => strings.englishSubject,
      LearningSubject.bahasaMelayu => strings.malaySubject,
      LearningSubject.arabic => strings.arabicSubject,
      LearningSubject.logic => strings.logicSubject,
      LearningSubject.discovery => strings.scienceSubject,
    };

LearningGameType _gameTypeFor(LearningSubject subject) => switch (subject) {
  LearningSubject.mathematics => LearningGameType.numberRush,
  LearningSubject.english ||
  LearningSubject.bahasaMelayu => LearningGameType.wordBuilder,
  LearningSubject.arabic => LearningGameType.arabicLetterHunt,
  LearningSubject.logic => LearningGameType.patternFactory,
  LearningSubject.discovery => LearningGameType.animalExplorer,
};

String _worldFor(LearningSubject subject) => switch (subject) {
  LearningSubject.mathematics => 'number-kingdom',
  LearningSubject.english => 'word-woods',
  LearningSubject.bahasaMelayu => 'language-village',
  LearningSubject.arabic => 'arabic-oasis',
  LearningSubject.logic => 'logic-lab',
  LearningSubject.discovery => 'discovery-island',
};
