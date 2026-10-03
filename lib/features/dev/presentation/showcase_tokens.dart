import 'package:flutter/material.dart';

import '../../../core/design_system.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'showcase_section.dart';

class ShowcasePalette extends StatelessWidget {
  const ShowcasePalette({super.key});

  @override
  Widget build(BuildContext context) => ShowcaseGrid(
    minTileWidth: 120,
    maxColumns: 4,
    children: [
      for (final entry in LumioPalette.values.entries)
        LumioCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: LumioSpacing.xxl,
                decoration: BoxDecoration(
                  color: entry.value,
                  borderRadius: BorderRadius.circular(LumioRadius.small),
                  border: Border.all(color: LumioColors.outline),
                ),
              ),
              const SizedBox(height: LumioSpacing.sm),
              Text(entry.key, style: LumioTypography.labelMedium),
              Text(
                '#${entry.value.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                style: LumioTypography.bodySmall.copyWith(
                  color: LumioColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

class ShowcaseTypography extends StatelessWidget {
  const ShowcaseTypography({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final roles = <String, TextStyle>{
      'displayLarge': LumioTypography.displayLarge,
      'displayMedium': LumioTypography.displayMedium,
      'headingLarge': LumioTypography.headingLarge,
      'headingMedium': LumioTypography.headingMedium,
      'headingSmall': LumioTypography.headingSmall,
      'bodyLarge': LumioTypography.bodyLarge,
      'bodyMedium': LumioTypography.bodyMedium,
      'bodySmall': LumioTypography.bodySmall,
      'labelLarge': LumioTypography.labelLarge,
      'labelMedium': LumioTypography.labelMedium,
      'numberLarge': LumioTypography.numberLarge,
    };
    return LumioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in roles.entries)
            Padding(
              padding: const EdgeInsetsDirectional.only(
                bottom: LumioSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.key} · ${entry.value.fontSize?.round()}',
                    style: LumioTypography.labelMedium.copyWith(
                      color: LumioColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: LumioSpacing.xs),
                  Text(
                    entry.key == 'numberLarge'
                        ? strings.numberSample
                        : entry.key.startsWith('display')
                        ? strings.badgeGlow
                        : strings.typeSample,
                    style: entry.value,
                  ),
                ],
              ),
            ),
          Text(strings.arabicSampleLabel, style: LumioTypography.labelMedium),
          const SizedBox(height: LumioSpacing.sm),
          Text(
            strings.arabicSample,
            textDirection: TextDirection.rtl,
            style: LumioTypography.arabicBody,
          ),
        ],
      ),
    );
  }
}

class ShowcaseTokens extends StatelessWidget {
  const ShowcaseTokens({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    const spacing = {
      'xs': LumioSpacing.xs,
      'sm': LumioSpacing.sm,
      'md': LumioSpacing.md,
      'lg': LumioSpacing.lg,
      'xl': LumioSpacing.xl,
      'xxl': LumioSpacing.xxl,
    };
    const radii = {
      'small': LumioRadius.small,
      'medium': LumioRadius.medium,
      'large': LumioRadius.large,
    };
    return ShowcaseGrid(
      children: [
        LumioCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.spacingLabel, style: LumioTypography.headingSmall),
              const SizedBox(height: LumioSpacing.md),
              for (final entry in spacing.entries)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    bottom: LumioSpacing.sm,
                  ),
                  child: Wrap(
                    spacing: LumioSpacing.md,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: entry.value,
                        height: LumioSpacing.sm,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            color: LumioColors.primary,
                            borderRadius: LumioRadius.button,
                          ),
                        ),
                      ),
                      Text(
                        '${entry.key} · ${entry.value.round()}',
                        style: LumioTypography.labelMedium,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        LumioCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.radiusLabel, style: LumioTypography.headingSmall),
              const SizedBox(height: LumioSpacing.md),
              Wrap(
                spacing: LumioSpacing.md,
                runSpacing: LumioSpacing.md,
                children: [
                  for (final entry in radii.entries)
                    Column(
                      children: [
                        Container(
                          width: 72,
                          height: LumioSpacing.childTouchTarget,
                          decoration: BoxDecoration(
                            color: LumioColors.primaryContainer,
                            borderRadius: BorderRadius.circular(entry.value),
                            border: Border.all(color: LumioColors.primary),
                          ),
                        ),
                        const SizedBox(height: LumioSpacing.sm),
                        Text(
                          '${entry.key}\n${entry.value.round()}',
                          style: LumioTypography.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        LumioCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.motionLabel, style: LumioTypography.headingSmall),
              const SizedBox(height: LumioSpacing.md),
              for (final label in [
                strings.motionPress,
                strings.motionFeedback,
                strings.motionTransition,
                strings.motionReaction,
                strings.motionReward,
              ])
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    bottom: LumioSpacing.sm,
                  ),
                  child: Text(label, style: LumioTypography.bodySmall),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
