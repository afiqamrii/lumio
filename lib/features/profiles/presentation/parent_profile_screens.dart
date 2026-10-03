import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/lumio_action_surface.dart';
import '../../../core/widgets/lumio_scene.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../progression/application/progression_store.dart';
import '../application/profile_store.dart';
import 'profile_widgets.dart';

class ParentHomeScreen extends ConsumerWidget {
  const ParentHomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final parent = ref.watch(profileStoreProvider).value?.parent;

    final children = ref.watch(profileStoreProvider).value?.children ?? [];
    return ResponsiveContent(
      maxWidth: 720,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (children.isNotEmpty) ...[
            LumioCard(
              radius: BorderRadius.circular(16),
              padding: const EdgeInsets.all(12),
              semanticLabel: s.selectChild,
              onTap: () => context.goNamed(AppRoutes.selectChild.name),
              child: Row(
                children: [
                  ProfileAvatarView(avatar: children.first.avatar, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          children.first.displayName,
                          style: LumioTypography.headingSmall,
                        ),
                        Text(
                          s.ageDescription(children.first.startingAge),
                          style: LumioTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.expand_more_rounded,
                    color: LumioColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [LumioColors.midnight, Color(0xFF38376B)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.auto_awesome_outlined,
                  color: LumioColors.secondaryContainer,
                  size: 24,
                ),
                const SizedBox(height: 22),
                Text(
                  parent?.displayName == null
                      ? s.localDataTitle
                      : s.greetParent(parent!.displayName!),
                  style: LumioTypography.bodySmall.copyWith(
                    color: LumioColors.onPrimary.withValues(alpha: .78),
                  ),
                ),
                const SizedBox(height: 8),
                Semantics(
                  header: true,
                  child: Text(
                    s.parentOverviewTitle,
                    style: LumioTypography.headingLarge.copyWith(
                      color: LumioColors.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  s.progressNotStarted,
                  style: LumioTypography.bodySmall.copyWith(
                    color: LumioColors.onPrimary.withValues(alpha: .78),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, bounds) {
              final cards = [
                _OverviewStat(
                  label: s.learningTimeLabel,
                  icon: Icons.schedule_rounded,
                ),
                _OverviewStat(
                  label: s.activitiesLabel,
                  icon: Icons.auto_stories_rounded,
                ),
                _OverviewStat(
                  label: s.daysExploredLabel,
                  icon: Icons.auto_awesome_rounded,
                ),
              ];
              if (bounds.maxWidth < 300 ||
                  MediaQuery.textScalerOf(context).scale(14) > 20) {
                return Column(
                  children: [
                    for (final card in cards)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(width: double.infinity, child: card),
                      ),
                  ],
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(child: cards[i]),
                    ],
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(s.learningSnapshot, style: LumioTypography.headingSmall),
          const SizedBox(height: 8),
          LumioCard(
            radius: BorderRadius.circular(16),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _OverviewRow(
                  title: s.mathSubject,
                  icon: Icons.calculate_outlined,
                  status: s.laterPhase,
                ),
                const Divider(height: 1, color: LumioColors.outlineSubtle),
                _OverviewRow(
                  title: s.englishSubject,
                  icon: Icons.auto_stories_outlined,
                  status: s.laterPhase,
                ),
                const Divider(height: 1, color: LumioColors.outlineSubtle),
                _OverviewRow(
                  title: s.malaySubject,
                  icon: Icons.chat_bubble_outline_rounded,
                  status: s.laterPhase,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          LumioCard(
            color: LumioColors.lavender,
            radius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.wb_sunny_rounded,
                  color: LumioColors.warning,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.firstDiscoveryTitle,
                        style: LumioTypography.headingSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.firstDiscoveryInfo,
                        style: LumioTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(s.familySettingsTitle, style: LumioTypography.headingSmall),
          const SizedBox(height: 8),
          LumioCard(
            radius: BorderRadius.circular(16),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _OverviewRow(
                  title: s.manageChildren,
                  icon: Icons.people_outline_rounded,
                  onTap: () => context.goNamed(AppRoutes.parentChildren.name),
                ),
                const Divider(height: 1, color: LumioColors.outlineSubtle),
                _OverviewRow(
                  title: s.progressDestination,
                  icon: Icons.insights_rounded,
                  onTap: () => context.goNamed(AppRoutes.parentProgress.name),
                ),
                const Divider(height: 1, color: LumioColors.outlineSubtle),
                _OverviewRow(
                  title: s.settingsDestination,
                  icon: Icons.settings_outlined,
                  onTap: () => context.goNamed(AppRoutes.parentSettings.name),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LumioButton(
            label: s.selectChild,
            icon: Icons.play_arrow_rounded,
            onPressed: () => context.goNamed(AppRoutes.selectChild.name),
          ),
        ],
      ),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  const _OverviewStat({required this.label, required this.icon});
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => LumioCard(
    radius: BorderRadius.circular(16),
    padding: const EdgeInsets.all(12),
    child: SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Icon(icon, color: LumioColors.primary, size: 26),
          const SizedBox(height: 6),
          Text('—', style: LumioTypography.headingMedium),
          Text(
            label,
            style: LumioTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _OverviewRow extends StatelessWidget {
  const _OverviewRow({
    required this.title,
    required this.icon,
    this.status,
    this.onTap,
  });
  final String title;
  final IconData icon;
  final String? status;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Icon(icon, size: 22, color: LumioColors.primary),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: LumioTypography.labelMedium)),
        const SizedBox(width: 8),
        if (status != null)
          Flexible(
            child: Text(
              status!,
              style: LumioTypography.bodySmall.copyWith(
                color: LumioColors.primaryPressed,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        if (onTap != null)
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: LumioColors.textSecondary,
          ),
      ],
    );
    if (onTap == null) {
      return Padding(padding: const EdgeInsets.all(12), child: content);
    }
    return LumioActionSurface(
      label: title,
      onTap: onTap,
      background: LumioColors.transparent,
      foreground: LumioColors.textPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      radius: BorderRadius.circular(14),
      child: content,
    );
  }
}

class ParentSettingsScreen extends ConsumerStatefulWidget {
  const ParentSettingsScreen({super.key, required this.debugTools});
  final bool debugTools;
  @override
  ConsumerState<ParentSettingsScreen> createState() =>
      _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends ConsumerState<ParentSettingsScreen> {
  bool _busy = false;
  bool _error = false;
  Future<void> _reset() async {
    if (_busy || !widget.debugTools) return;
    setState(() => _busy = true);
    final s = AppLocalizations.of(context);
    final confirmed = await confirmProfileAction(
      context,
      title: s.resetTitle,
      description: s.resetInfo,
      confirm: s.confirmReset,
    );
    if (!mounted) return;
    if (confirmed) {
      try {
        await ref.read(profileStoreProvider.notifier).reset();
      } catch (_) {
        if (mounted) setState(() => _error = true);
      }
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _resetProgression() async {
    if (_busy || !widget.debugTools) return;
    setState(() {
      _busy = true;
      _error = false;
    });
    final s = AppLocalizations.of(context);
    final confirmed = await confirmProfileAction(
      context,
      title: s.resetProgressionTitle,
      description: s.resetProgressionInfo,
      confirm: s.resetProgressionData,
    );
    if (!mounted) return;
    if (confirmed) {
      try {
        final children = ref.read(profileStoreProvider).value?.children ?? [];
        await ref
            .read(progressionControllerProvider)
            .resetAll(children.map((child) => child.id));
      } catch (_) {
        if (mounted) setState(() => _error = true);
      }
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final parent = ref.watch(profileStoreProvider).value?.parent;
    return ResponsiveContent(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LumioSectionHeading(title: s.settingsDestination),
          const SizedBox(height: 24),
          LumioCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: LumioColors.lavender,
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: LumioColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(s.localParentLabel, style: LumioTypography.headingSmall),
                if (parent?.displayName != null) ...[
                  const SizedBox(height: LumioSpacing.sm),
                  Text(parent!.displayName!, style: LumioTypography.bodyLarge),
                ],
                const SizedBox(height: LumioSpacing.sm),
                Text(s.storedLocally, style: LumioTypography.bodyMedium),
                const SizedBox(height: LumioSpacing.lg),
                const Divider(color: LumioColors.outlineSubtle),
                const SizedBox(height: 20),
                Text(s.privacyTitle, style: LumioTypography.headingSmall),
                const SizedBox(height: 8),
                Text(s.privacyInfo, style: LumioTypography.bodyMedium),
                const SizedBox(height: 24),
                Text(s.appInfo, style: LumioTypography.labelMedium),
                const SizedBox(height: 4),
                Text(
                  s.productOwner,
                  style: LumioTypography.bodySmall.copyWith(
                    color: LumioColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (widget.debugTools) ...[
            const SizedBox(height: LumioSpacing.lg),
            Text(s.debugToolsTitle, style: LumioTypography.headingSmall),
            const SizedBox(height: LumioSpacing.md),
            if (_error) const ProfileErrorText(),
            LumioButton(
              label: s.learningContentBrowser,
              icon: Icons.menu_book_rounded,
              variant: LumioButtonVariant.secondary,
              onPressed: _busy
                  ? null
                  : () => context.pushNamed(AppRoutes.learningContent.name),
            ),
            const SizedBox(height: 10),
            LumioButton(
              label: s.resetProgressionData,
              variant: LumioButtonVariant.outline,
              onPressed: _busy ? null : _resetProgression,
            ),
            const SizedBox(height: 10),
            LumioButton(
              label: s.resetLocalData,

              variant: LumioButtonVariant.outline,
              onPressed: _busy ? null : _reset,
            ),
          ],
        ],
      ),
    );
  }
}
