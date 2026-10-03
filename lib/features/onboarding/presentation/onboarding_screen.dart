import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design_system.dart';
import '../../../core/widgets/lumio_form_controls.dart';
import '../../../core/widgets/lumio_scene.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../profiles/application/profile_store.dart';
import '../../profiles/domain/profiles.dart';
import '../../profiles/presentation/profile_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _parentName = TextEditingController();
  final _parentForm = GlobalKey<FormState>();
  final _childForm = GlobalKey<FormState>();
  ChildDraft _draft = const ChildDraft(
    displayName: '',
    startingAge: 0,
    avatar: ProfileAvatar.spark,
    language: 'en',
  );
  int _step = 0;
  bool _busy = false;
  bool _error = false;
  @override
  void dispose() {
    _parentName.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_busy) return;
    if (_step == 1 && !_parentForm.currentState!.validate()) return;
    if (_step == 2 && !_childForm.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (_step < 3) {
      setState(() => _step++);
      return;
    }
    setState(() {
      _busy = true;
      _error = false;
    });
    try {
      await ref
          .read(profileStoreProvider.notifier)
          .completeSetup(_parentName.text, _draft);
      // Router reacts only after all three setup records commit successfully.
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final title = switch (_step) {
      0 => s.welcomeLumio,
      1 => s.parentSetup,
      2 => s.firstChildTitle,
      _ => s.reviewSetup,
    };
    return PopScope<Object?>(
      canPop: _step == 0 && !_busy,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_busy && _step > 0) setState(() => _step--);
      },
      child: LumioScaffold(
        maxContentWidth: _step == 0 ? 960 : 640,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const LumioLogo(
                  variant: LumioLogoVariant.colorWordmark,
                  width: 110,
                ),
                const SizedBox(width: 20),
                const Spacer(),
                Flexible(
                  flex: 4,
                  child: Text(
                    _step == 0 ? s.tagline : s.stepPosition(_step + 1, 4),
                    textAlign: TextAlign.end,
                    style: LumioTypography.labelMedium.copyWith(
                      color: LumioColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            if (_step > 0) ...[
              const SizedBox(height: 28),
              _SetupProgress(step: _step),
            ],
            SizedBox(height: _step == 0 ? 34 : 32),
            if (_step == 0)
              const _WelcomeContent()
            else ...[
              Text(
                s.setupEyebrow,
                style: LumioTypography.labelMedium.copyWith(
                  color: LumioColors.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              LumioSectionHeading(title: title),
              const SizedBox(height: 24),
              LumioCard(
                elevated: true,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_step == 1) ...[
                      _SetupNote(
                        icon: Icons.shield_outlined,
                        title: s.privacyTitle,
                        description: s.localSetupInfo,
                      ),
                      const SizedBox(height: 28),
                      Form(
                        key: _parentForm,
                        child: LumioFieldGroup(
                          label: s.parentDisplayName,
                          help: s.parentNameHelp,
                          child: Semantics(
                            label: s.parentDisplayName,
                            child: LumioTextField(
                              key: const ValueKey('parentDisplayName'),
                              controller: _parentName,
                              hintText: s.nameHint,
                              icon: Icons.person_outline_rounded,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => _next(),
                              validator: (value) => validateDisplayName(
                                value ?? '',
                                s,
                                optional: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (_step == 2)
                      ChildProfileFields(
                        formKey: _childForm,
                        initial: _draft,
                        onChanged: (draft) => _draft = draft,
                      ),
                    if (_step == 3) ...[
                      _SetupNote(
                        icon: Icons.check_rounded,
                        title: s.profileReady,
                        description: s.reviewInfo,
                      ),
                      const SizedBox(height: 24),
                      ProfileSummary(draft: _draft),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (_error) const ProfileErrorText(),
            Align(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: SizedBox(
                  width: double.infinity,
                  child: LumioButton(
                    label: _step == 0
                        ? s.getStarted
                        : _step == 3
                        ? s.finishSetup
                        : s.continueAction,
                    icon: _step == 3
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    isLoading: _busy,
                    onPressed: _next,
                  ),
                ),
              ),
            ),
            if (_step > 0) ...[
              const SizedBox(height: 8),
              LumioButton(
                label: s.backAction,
                variant: LumioButtonVariant.ghost,
                onPressed: _busy ? null : () => setState(() => _step--),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 15,
                  color: LumioColors.textSecondary,
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    s.storedLocally,
                    textAlign: TextAlign.center,
                    style: LumioTypography.bodySmall.copyWith(
                      color: LumioColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SetupProgress extends StatelessWidget {
  const _SetupProgress({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).stepPosition(step + 1, 4),
    child: ExcludeSemantics(
      child: Row(
        children: [
          for (var i = 0; i < 4; i++)
            Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsetsDirectional.only(end: i == 3 ? 0 : 8),
                decoration: BoxDecoration(
                  color: i <= step
                      ? LumioColors.primary
                      : LumioColors.outlineSubtle,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent();

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, bounds) {
        final wide =
            bounds.maxWidth >= 720 &&
            MediaQuery.textScalerOf(context).scale(16) < 25;
        final introduction = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: LumioColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: LumioColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      s.welcomeEyebrow,
                      style: LumioTypography.labelMedium.copyWith(
                        color: LumioColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              header: true,
              child: Text(
                s.welcomeHeadline,
                style: LumioTypography.displayLarge.copyWith(
                  fontSize: wide ? 46 : 36,
                  height: 1.22,
                  letterSpacing: -1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              s.onboardingIntro,
              style: LumioTypography.bodyMedium.copyWith(
                color: LumioColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (wide)
              Row(
                children: [
                  Expanded(flex: 11, child: introduction),
                  const SizedBox(width: 32),
                  const Expanded(flex: 10, child: LumiScene(height: 330)),
                ],
              )
            else ...[
              introduction,
              const SizedBox(height: 16),
              const LumiScene(height: 240),
            ],
            const SizedBox(height: 20),
            LumioCard(
              padding: const EdgeInsets.all(18),
              radius: BorderRadius.circular(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: LumioColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.explore_outlined,
                      color: LumioColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.welcomeBenefitAge,
                          style: LumioTypography.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.adventureSubtitle,
                          style: LumioTypography.bodySmall.copyWith(
                            color: LumioColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SetupNote extends StatelessWidget {
  const _SetupNote({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: LumioColors.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: LumioColors.primary, size: 26),
      ),
      const SizedBox(height: 16),
      Text(title, style: LumioTypography.headingSmall),
      const SizedBox(height: 8),
      Text(
        description,
        style: LumioTypography.bodySmall.copyWith(
          color: LumioColors.textSecondary,
          height: 1.6,
        ),
      ),
    ],
  );
}
