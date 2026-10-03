import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system.dart';
import '../../../core/routing/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/profile_store.dart';
import '../domain/profiles.dart';
import 'profile_widgets.dart';

class ChildEditorScreen extends ConsumerStatefulWidget {
  const ChildEditorScreen({super.key, this.childId});
  final String? childId;
  @override
  ConsumerState<ChildEditorScreen> createState() => _ChildEditorScreenState();
}

class _ChildEditorScreenState extends ConsumerState<ChildEditorScreen> {
  final _form = GlobalKey<FormState>();
  ChildDraft? _draft;
  bool _dirty = false;
  bool _busy = false;
  bool _error = false;
  bool _confirming = false;
  Future<void> _leave() async {
    if (_busy || _confirming) return;
    _confirming = true;
    final s = AppLocalizations.of(context);
    final discard =
        !_dirty ||
        await confirmProfileAction(
          context,
          title: s.unsavedTitle,
          description: s.unsavedInfo,
          confirm: s.discardAction,
        );
    _confirming = false;
    if (mounted && discard) context.goNamed(AppRoutes.parentChildren.name);
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final existing = widget.childId == null
        ? null
        : ref.read(profileStoreProvider).value?.child(widget.childId!);
    final draft = _draft ?? existing?.draft;
    if (draft == null) return;
    setState(() {
      _busy = true;
      _error = false;
    });
    try {
      final store = ref.read(profileStoreProvider.notifier);
      if (widget.childId == null) {
        await store.create(draft);
      } else {
        await store.edit(widget.childId!, draft);
      }
      if (mounted) context.goNamed(AppRoutes.parentChildren.name);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final existing = widget.childId == null
        ? null
        : ref.watch(profileStoreProvider).value?.child(widget.childId!);
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave();
      },
      child: LumioScaffold(
        maxContentWidth: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                LumioIconButton(
                  icon: Icons.arrow_back_rounded,
                  label: s.backAction,
                  onPressed: _busy ? null : _leave,
                ),
                const SizedBox(width: 12),
                const LumioLogo(
                  variant: LumioLogoVariant.colorWordmark,
                  width: 100,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Semantics(
              header: true,
              child: Text(
                widget.childId == null ? s.addChild : s.editChild,
                style: LumioTypography.headingLarge,
              ),
            ),
            const SizedBox(height: LumioSpacing.lg),
            LumioCard(
              padding: const EdgeInsets.all(24),
              child: ChildProfileFields(
                formKey: _form,
                initial: existing?.draft,
                enabled: !_busy,
                onChanged: (draft) {
                  _draft = draft;
                  _dirty = true;
                },
              ),
            ),
            const SizedBox(height: LumioSpacing.lg),
            if (_error) const ProfileErrorText(),
            LumioButton(
              label: s.saveProfile,
              isLoading: _busy,
              onPressed: _save,
            ),
            const SizedBox(height: LumioSpacing.sm),
            LumioButton(
              label: s.cancelAction,
              variant: LumioButtonVariant.ghost,
              onPressed: _busy ? null : _leave,
            ),
          ],
        ),
      ),
    );
  }
}
