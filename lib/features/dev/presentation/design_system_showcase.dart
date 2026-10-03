import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/design_system.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'showcase_section.dart';
import 'showcase_tokens.dart';

/// Local presentation samples only; never a game, profile or learning model.
class DesignSystemShowcase extends StatefulWidget {
  const DesignSystemShowcase({super.key, this.onBack});
  final VoidCallback? onBack;

  @override
  State<DesignSystemShowcase> createState() => _DesignSystemShowcaseState();
}

class _DesignSystemShowcaseState extends State<DesignSystemShowcase> {
  int _presses = 0;
  bool _loading = false;
  bool _selected = false;
  bool _reduceMotion = false;
  double _progress = 0.4;
  Timer? _loadingTimer;

  void _previewLoading() {
    setState(() => _loading = true);
    _loadingTimer?.cancel();
    _loadingTimer = Timer(LumioMotion.reward, () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final systemReduced = LumioMotion.reduced(context);
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(disableAnimations: systemReduced || _reduceMotion),
      child: LumioScaffold(
        maxContentWidth: 1120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: LumioSpacing.lg,
              runSpacing: LumioSpacing.md,
              children: [
                if (widget.onBack != null)
                  LumioIconButton(
                    icon: Icons.arrow_back_rounded,
                    label: strings.returnToFoundation,
                    onPressed: widget.onBack,
                  ),
                const LumioLogo(variant: LumioLogoVariant.colorWordmark),
                LumioBadge(
                  label: strings.developmentPreview,
                  tone: LumioBadgeTone.info,
                ),
              ],
            ),
            const SizedBox(height: LumioSpacing.xl),
            LumioCard(
              elevated: true,
              padding: const EdgeInsetsDirectional.all(LumioSpacing.lg),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final introduction = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          strings.showcaseTitle,
                          style: LumioTypography.displayMedium,
                        ),
                      ),
                      const SizedBox(height: LumioSpacing.md),
                      Text(strings.tagline, style: LumioTypography.bodyLarge),
                      const SizedBox(height: LumioSpacing.md),
                      Text(
                        strings.showcaseIntro,
                        style: LumioTypography.bodyMedium.copyWith(
                          color: LumioColors.textSecondary,
                        ),
                      ),
                    ],
                  );
                  final mascot = LumiMascot(
                    size: 180,
                    semanticLabel: strings.mascotHappy,
                  );
                  return constraints.maxWidth >= LayoutBreakpoints.medium
                      ? Row(
                          children: [
                            Expanded(child: introduction),
                            const SizedBox(width: LumioSpacing.xl),
                            mascot,
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            introduction,
                            const SizedBox(height: LumioSpacing.lg),
                            Center(child: mascot),
                          ],
                        );
                },
              ),
            ),
            const SizedBox(height: LumioSpacing.lg),
            LumioCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.reducedMotionLabel,
                          style: LumioTypography.labelLarge,
                        ),
                        const SizedBox(height: LumioSpacing.xs),
                        Text(
                          systemReduced
                              ? strings.systemReducedMotion
                              : strings.reducedMotionDescription,
                          style: LumioTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: LumioSpacing.sm),
                  Semantics(
                    label: strings.reducedMotionLabel,
                    child: Switch(
                      value: systemReduced || _reduceMotion,
                      onChanged: systemReduced
                          ? null
                          : (value) => setState(() => _reduceMotion = value),
                    ),
                  ),
                ],
              ),
            ),
            ShowcaseSection(
              number: '01',
              title: strings.identityTitle,
              description: strings.identityDescription,
              child: ShowcaseGrid(
                children: [
                  _LogoSample(
                    label: strings.primaryLogoLabel,
                    child: const LumioLogo(),
                  ),
                  _LogoSample(
                    label: strings.wordmarkLogoLabel,
                    child: const LumioLogo(
                      variant: LumioLogoVariant.colorWordmark,
                      width: 180,
                    ),
                  ),
                  _LogoSample(
                    label: strings.compactLogoLabel,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: LumioColors.textPrimary,
                        borderRadius: LumioRadius.card,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(LumioSpacing.md),
                        child: LumioLogo(
                          variant: LumioLogoVariant.compactReverse,
                          width: 120,
                        ),
                      ),
                    ),
                  ),
                  LumioCard(
                    child: Wrap(
                      spacing: LumioSpacing.lg,
                      runSpacing: LumioSpacing.md,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        LumiMascot(
                          pose: LumiPose.curious,
                          semanticLabel: strings.mascotCurious,
                          size: 120,
                        ),
                        LumioAvatarFrame(
                          label: strings.avatarPlaceholder,
                          child: const Icon(
                            Icons.face_rounded,
                            color: LumioColors.textPrimary,
                            size: LumioSpacing.xxl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ShowcaseSection(
              number: '02',
              title: strings.paletteTitle,
              description: strings.paletteDescription,
              child: const ShowcasePalette(),
            ),
            ShowcaseSection(
              number: '03',
              title: strings.typographyTitle,
              description: strings.typographyDescription,
              child: const ShowcaseTypography(),
            ),
            ShowcaseSection(
              number: '04',
              title: strings.buttonsTitle,
              description: strings.buttonsDescription,
              child: LumioCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: LumioSpacing.md,
                      runSpacing: LumioSpacing.md,
                      children: [
                        LumioButton(
                          label: strings.tryPress,
                          icon: Icons.touch_app_rounded,
                          onPressed: () => setState(() => _presses++),
                        ),
                        LumioButton(
                          label: strings.secondaryButton,
                          variant: LumioButtonVariant.secondary,
                          onPressed: () => setState(() => _presses++),
                        ),
                        LumioButton(
                          label: strings.outlineButton,
                          variant: LumioButtonVariant.outline,
                          onPressed: () => setState(() => _presses++),
                        ),
                        LumioButton(
                          label: strings.ghostButton,
                          variant: LumioButtonVariant.ghost,
                          onPressed: () => setState(() => _presses++),
                        ),
                        LumioButton(
                          label: strings.previewLoading,
                          isLoading: _loading,
                          onPressed: _previewLoading,
                        ),
                        LumioButton(
                          label: strings.disabledButton,
                          onPressed: null,
                        ),
                        LumioIconButton(
                          icon: Icons.replay_rounded,
                          label: strings.resetPreview,
                          onPressed: () => setState(() => _presses = 0),
                        ),
                        LumioIconButton(
                          icon: Icons.volume_off_rounded,
                          label: strings.disabledIcon,
                          onPressed: null,
                        ),
                      ],
                    ),
                    const SizedBox(height: LumioSpacing.lg),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        strings.pressCount(_presses),
                        style: LumioTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ShowcaseSection(
              number: '05',
              title: strings.cardsTitle,
              description: strings.cardsDescription,
              child: ShowcaseGrid(
                maxColumns: 2,
                children: [
                  LumioCard(
                    elevated: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.calmCardTitle,
                          style: LumioTypography.headingSmall,
                        ),
                        const SizedBox(height: LumioSpacing.sm),
                        Text(
                          strings.calmCardBody,
                          style: LumioTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  LumioCard(
                    selected: _selected,
                    semanticLabel: _selected
                        ? strings.selectedCardTitle
                        : strings.selectableCardTitle,
                    onTap: () => setState(() => _selected = !_selected),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selected
                              ? strings.selectedCardTitle
                              : strings.selectableCardTitle,
                          style: LumioTypography.headingSmall,
                        ),
                        const SizedBox(height: LumioSpacing.sm),
                        Text(
                          strings.selectableCardBody,
                          style: LumioTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ShowcaseSection(
              number: '06',
              title: strings.progressTitle,
              description: strings.progressDescription,
              child: LumioCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LumioProgressBar(
                      value: _progress,
                      label: strings.progressSample,
                    ),
                    const SizedBox(height: LumioSpacing.lg),
                    LumioProgressBar(value: 0, label: strings.progressEmpty),
                    const SizedBox(height: LumioSpacing.lg),
                    LumioProgressBar(value: 1, label: strings.progressComplete),
                    const SizedBox(height: LumioSpacing.lg),
                    LumioButton(
                      label: strings.changeProgress,
                      variant: LumioButtonVariant.secondary,
                      onPressed: () => setState(
                        () => _progress = _progress < 0.5
                            ? 0.5
                            : _progress < 1
                            ? 1
                            : 0,
                      ),
                    ),
                    const SizedBox(height: LumioSpacing.lg),
                    Wrap(
                      spacing: LumioSpacing.sm,
                      runSpacing: LumioSpacing.sm,
                      children: [
                        LumioBadge(label: strings.badgeNeutral),
                        LumioBadge(
                          label: strings.badgeInfo,
                          tone: LumioBadgeTone.info,
                        ),
                        LumioBadge(
                          label: strings.badgeSuccess,
                          tone: LumioBadgeTone.success,
                        ),
                        LumioBadge(
                          label: strings.badgeWarning,
                          tone: LumioBadgeTone.warning,
                        ),
                        LumioBadge(
                          label: strings.badgeError,
                          tone: LumioBadgeTone.error,
                        ),
                        LumioBadge(
                          label: strings.badgeGlow,
                          tone: LumioBadgeTone.glow,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ShowcaseSection(
              number: '07',
              title: strings.tokensTitle,
              description: strings.tokensDescription,
              child: const ShowcaseTokens(),
            ),
            const SizedBox(height: LumioSpacing.xxl),

            const SizedBox(height: LumioSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _LogoSample extends StatelessWidget {
  const _LogoSample({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => LumioCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: LumioTypography.labelMedium),
        const SizedBox(height: LumioSpacing.md),
        Center(child: child),
      ],
    ),
  );
}
