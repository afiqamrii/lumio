import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/profile_store.dart';
import '../domain/profiles.dart';
import 'profile_widgets.dart';

class ChildrenScreen extends ConsumerStatefulWidget {
  const ChildrenScreen({super.key, this.selector = false});
  final bool selector;
  @override
  ConsumerState<ChildrenScreen> createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends ConsumerState<ChildrenScreen> {
  bool _busy = false;
  bool _error = false;
  Future<void> _delete(ChildProfile child) async {
    if (_busy) return;
    setState(() => _busy = true);
    final s = AppLocalizations.of(context);
    final confirmed = await confirmProfileAction(
      context,
      title: s.deleteTitle,
      description: '${child.displayName}\n\n${s.deleteInfo}',
      confirm: s.confirmDelete,
    );
    if (!mounted) return;
    if (confirmed) {
      try {
        await ref.read(profileStoreProvider.notifier).delete(child.id);
      } catch (_) {
        if (mounted) setState(() => _error = true);
      }
    }
    if (mounted) setState(() => _busy = false);
  }

  void _open(ChildProfile child) => context.goNamed(
    AppRoutes.childHome.name,
    pathParameters: AppRoutes.childParameters(child.id),
  );
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final children = ref.watch(profileStoreProvider).value?.children ?? [];
    final content = ResponsiveContent(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.selector) ...[
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: LumioLogo(
                variant: LumioLogoVariant.colorWordmark,
                width: 120,
              ),
            ),
            const SizedBox(height: LumioSpacing.xl),
          ],
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    widget.selector ? s.chooseChild : s.manageChildren,
                    style: LumioTypography.headingLarge,
                  ),
                ),
              ),
              if (widget.selector) ...[
                const SizedBox(width: 8),
                const ExcludeSemantics(child: LumiMascot(size: 88)),
              ],
            ],
          ),
          const SizedBox(height: LumioSpacing.md),
          if (widget.selector)
            Text(s.chooseChildInfo, style: LumioTypography.bodyMedium),
          const SizedBox(height: LumioSpacing.lg),
          if (_error) const ProfileErrorText(),
          if (children.isEmpty)
            LumioCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LumiMascot(size: 120, semanticLabel: s.mascotHappy),
                  const SizedBox(height: LumioSpacing.md),
                  Text(s.noChildrenTitle, style: LumioTypography.headingMedium),
                  const SizedBox(height: LumioSpacing.md),
                  Text(s.noChildrenInfo, style: LumioTypography.bodyMedium),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final twoColumns =
                    constraints.maxWidth >= LayoutBreakpoints.medium;
                final width = twoColumns
                    ? (constraints.maxWidth - LumioSpacing.md) / 2
                    : constraints.maxWidth;
                return Wrap(
                  spacing: LumioSpacing.md,
                  runSpacing: LumioSpacing.md,
                  children: [
                    for (final child in children)
                      SizedBox(
                        width: width,
                        child: LumioCard(
                          key: ValueKey('profile-${child.id}'),
                          color: widget.selector
                              ? child.avatar.surface
                              : LumioColors.surface,
                          padding: const EdgeInsets.all(24),
                          semanticLabel: widget.selector
                              ? s.selectNamedChild(child.displayName)
                              : null,
                          onTap: widget.selector ? () => _open(child) : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.selector)
                                Row(
                                  children: [
                                    ProfileAvatarView(
                                      avatar: child.avatar,
                                      size: 72,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            child.displayName,
                                            style:
                                                LumioTypography.headingMedium,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            s.ageDescription(child.startingAge),
                                            style: LumioTypography.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded),
                                  ],
                                )
                              else
                                ProfileSummary(draft: child.draft),
                              if (!widget.selector) ...[
                                const SizedBox(height: LumioSpacing.lg),
                                LumioButton(
                                  label: s.selectNamedChild(child.displayName),
                                  onPressed: _busy ? null : () => _open(child),
                                ),
                                const SizedBox(height: LumioSpacing.sm),
                                LumioButton(
                                  label: s.editNamedChild(child.displayName),
                                  variant: LumioButtonVariant.outline,
                                  onPressed: _busy
                                      ? null
                                      : () => context.goNamed(
                                          AppRoutes.editChild.name,
                                          pathParameters:
                                              AppRoutes.childParameters(
                                                child.id,
                                              ),
                                        ),
                                ),
                                const SizedBox(height: LumioSpacing.sm),
                                LumioButton(
                                  label: s.deleteNamedChild(child.displayName),
                                  variant: LumioButtonVariant.ghost,
                                  onPressed: _busy
                                      ? null
                                      : () => _delete(child),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          const SizedBox(height: LumioSpacing.lg),
          Wrap(
            spacing: LumioSpacing.md,
            runSpacing: LumioSpacing.md,
            children: [
              LumioButton(
                label: s.addChild,
                variant: LumioButtonVariant.secondary,
                icon: Icons.add_rounded,
                onPressed: _busy
                    ? null
                    : () => context.goNamed(AppRoutes.newChild.name),
              ),
              if (widget.selector)
                LumioButton(
                  label: s.openParentArea,
                  variant: LumioButtonVariant.ghost,
                  onPressed: () => context.goNamed(AppRoutes.parentHome.name),
                ),
            ],
          ),
        ],
      ),
    );
    return widget.selector
        ? Scaffold(backgroundColor: LumioColors.background, body: content)
        : content;
  }
}
