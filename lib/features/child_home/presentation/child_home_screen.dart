import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../adventure/application/child_interaction_hook.dart';
import '../../adventure/presentation/widgets/animated_lumi.dart';
import '../../profiles/application/profile_store.dart';
import '../../profiles/domain/profiles.dart';
import '../../profiles/presentation/profile_widgets.dart';
import '../../progression/application/progression_store.dart';
import '../../progression/domain/progression_models.dart';

class ChildHomeScreen extends ConsumerWidget {
  const ChildHomeScreen({
    super.key,
    required this.childId,
    this.onInteraction = noChildInteraction,
  });

  final String childId;
  final ChildInteractionHook onInteraction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final child = ref.watch(activeChildProvider(childId)).value;
    if (child == null) {
      return ResponsiveContent(child: _MissingChildContent(strings: strings));
    }
    final progress = ref.watch(childProgressProvider(childId)).value?.progress;

    void openAdventure() {
      onInteraction(ChildInteractionEvent.homeContinue, null);
      context.goNamed(
        AppRoutes.childAdventure.name,
        pathParameters: AppRoutes.childParameters(childId),
      );
    }

    return ResponsiveContent(
      maxWidth: 1120,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide =
              constraints.maxWidth >= 660 &&
              MediaQuery.textScalerOf(context).scale(16) < 25;
          final greeting = _HomeGreeting(
            name: child.displayName,
            avatar: child.avatar,
          );
          final hero = _AdventureHero(
            strings: strings,
            onContinue: openAdventure,
          );
          final shortcuts = _HomeShortcuts(
            strings: strings,
            childId: childId,
            onAdventure: openAdventure,
          );
          if (wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                greeting,
                if (progress != null) ...[
                  const SizedBox(height: 24),
                  _HomeProgressSummary(progress: progress),
                ],
                const SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: hero),
                    const SizedBox(width: 24),
                    Expanded(flex: 4, child: shortcuts),
                  ],
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              greeting,
              if (progress != null) ...[
                const SizedBox(height: 20),
                _HomeProgressSummary(progress: progress),
              ],
              const SizedBox(height: 20),
              hero,
              const SizedBox(height: 28),
              shortcuts,
            ],
          );
        },
      ),
    );
  }
}

class _HomeProgressSummary extends StatelessWidget {
  const _HomeProgressSummary({required this.progress});
  final ChildProgress progress;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return LumioCard(
      padding: const EdgeInsets.all(16),
      radius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _HomeStat(
                icon: Icons.bolt_rounded,
                label: strings.levelValue(progress.level),
              ),
              _HomeStat(
                icon: Icons.star_rounded,
                label: strings.starCount(progress.stars),
              ),
              _HomeStat(
                icon: Icons.monetization_on_rounded,
                label: strings.coinCount(progress.coins),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LumioProgressBar(
            value: progress.levelProgress,
            label: strings.xpToNextLevel(
              progress.xpWithinLevel,
              progress.xpForNextLevel,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeStat extends StatelessWidget {
  const _HomeStat({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: LumioColors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: LumioColors.primary, size: 19),
      ),
      const SizedBox(width: 7),
      Flexible(child: Text(label, style: LumioTypography.labelMedium)),
    ],
  );
}

class _HomeGreeting extends StatelessWidget {
  const _HomeGreeting({required this.name, required this.avatar});

  final String name;
  final ProfileAvatar avatar;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  strings.greetChild(name),
                  style: LumioTypography.headingLarge,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                strings.lumiReady,
                style: LumioTypography.bodyMedium.copyWith(
                  color: LumioColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: LumioColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: LumioColors.outlineSubtle),
          ),
          child: ProfileAvatarView(avatar: avatar, size: 54),
        ),
      ],
    );
  }
}

class _AdventureHero extends StatelessWidget {
  const _AdventureHero({required this.strings, required this.onContinue});

  final AppLocalizations strings;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [LumioColors.lavender, LumioColors.surface, LumioColors.sky],
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: LumioColors.primary.withValues(alpha: .14)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: LumioColors.surface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: LumioColors.outlineSubtle),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: LumioColors.primary,
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      strings.yourAdventure,
                      style: LumioTypography.labelMedium.copyWith(
                        color: LumioColors.primaryPressed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _AdventureOrbit(),
          Semantics(
            header: true,
            child: Text(
              strings.childAdventureHeadline,
              style: LumioTypography.displayMedium,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            strings.childAdventureIntro,
            style: LumioTypography.bodyMedium.copyWith(
              color: LumioColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          LumioButton(
            label: strings.continueAdventure,
            icon: Icons.arrow_forward_rounded,
            onPressed: onContinue,
          ),
        ],
      ),
    ),
  );
}

class _AdventureOrbit extends StatelessWidget {
  const _AdventureOrbit();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 420;
      return SizedBox(
        height: compact ? 124 : 208,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ExcludeSemantics(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth.clamp(
                    0.0,
                    compact ? 210.0 : 280.0,
                  );
                  return Container(
                    width: width,
                    height: width * .52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(width, 120),
                      ),
                      border: Border.all(
                        color: LumioColors.primary.withValues(alpha: .16),
                      ),
                    ),
                    child: Align(
                      alignment: const Alignment(.76, -.76),
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: LumioColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            AnimatedLumi(size: compact ? 118 : 186),
          ],
        ),
      );
    },
  );
}

class _HomeShortcuts extends StatelessWidget {
  const _HomeShortcuts({
    required this.strings,
    required this.childId,
    required this.onAdventure,
  });

  final AppLocalizations strings;
  final String childId;
  final VoidCallback onAdventure;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        header: true,
        child: Text(
          strings.chooseYourPath,
          style: LumioTypography.headingMedium,
        ),
      ),
      const SizedBox(height: 16),
      LumioCard(
        semanticLabel: strings.openAdventureMap,
        onTap: onAdventure,
        radius: BorderRadius.circular(22),
        padding: const EdgeInsets.all(20),
        child: _ShortcutContent(
          icon: Icons.map_rounded,
          color: LumioColors.mint,
          title: strings.adventureDestination,
          body: strings.adventureMapTeaser,
        ),
      ),
      const SizedBox(height: 12),
      LumioCard(
        semanticLabel: strings.openRewards,
        onTap: () => context.goNamed(
          AppRoutes.childRewards.name,
          pathParameters: AppRoutes.childParameters(childId),
        ),
        radius: BorderRadius.circular(22),
        padding: const EdgeInsets.all(20),
        child: _ShortcutContent(
          icon: Icons.auto_awesome_rounded,
          color: LumioColors.lavender,
          title: strings.rewardsDestination,
          body: strings.rewardsTeaser,
        ),
      ),
    ],
  );
}

class _ShortcutContent extends StatelessWidget {
  const _ShortcutContent({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: LumioColors.primaryPressed),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_outward_rounded,
            color: LumioColors.textSecondary,
            size: 22,
          ),
        ],
      ),
      const SizedBox(height: 18),
      Text(title, style: LumioTypography.headingSmall),
      const SizedBox(height: 6),
      Text(
        body,
        style: LumioTypography.bodySmall.copyWith(
          color: LumioColors.textSecondary,
        ),
      ),
    ],
  );
}

class _MissingChildContent extends StatelessWidget {
  const _MissingChildContent({required this.strings});

  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.person_search_rounded,
        size: 72,
        color: LumioColors.primary,
      ),
      const SizedBox(height: 20),
      Text(
        strings.childMissingTitle,
        textAlign: TextAlign.center,
        style: LumioTypography.headingLarge,
      ),
      const SizedBox(height: 8),
      Text(strings.childMissingInfo, textAlign: TextAlign.center),
      const SizedBox(height: 24),
      LumioButton(
        label: strings.selectChild,
        onPressed: () => context.goNamed(AppRoutes.selectChild.name),
      ),
    ],
  );
}
