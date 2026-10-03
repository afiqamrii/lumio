import 'package:flutter/material.dart';
import '../../../core/design_system.dart';
import '../../../core/widgets/lumio_form_controls.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/profiles.dart';

extension AvatarPresentation on ProfileAvatar {
  IconData get icon => switch (this) {
    ProfileAvatar.spark => Icons.auto_awesome_rounded,
    ProfileAvatar.sun => Icons.wb_sunny_rounded,
    ProfileAvatar.moon => Icons.nightlight_round,
    ProfileAvatar.leaf => Icons.eco_rounded,
  };
  Color get surface => switch (this) {
    ProfileAvatar.spark => LumioColors.lavender,
    ProfileAvatar.sun => LumioColors.butter,
    ProfileAvatar.moon => LumioColors.sky,
    ProfileAvatar.leaf => LumioColors.mint,
  };
  String label(AppLocalizations strings) => switch (this) {
    ProfileAvatar.spark => strings.avatarSpark,
    ProfileAvatar.sun => strings.avatarSun,
    ProfileAvatar.moon => strings.avatarMoon,
    ProfileAvatar.leaf => strings.avatarLeaf,
  };
}

class ProfileAvatarView extends StatelessWidget {
  const ProfileAvatarView({super.key, required this.avatar, this.size = 80});
  final ProfileAvatar avatar;
  final double size;
  @override
  Widget build(BuildContext context) => Semantics(
    label: avatar.label(AppLocalizations.of(context)),
    image: true,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LumioColors.surface, avatar.surface],
        ),
        borderRadius: BorderRadius.circular(size * .32),
        border: Border.all(color: LumioColors.surface, width: 2),
        boxShadow: [
          BoxShadow(
            color: LumioColors.textPrimary.withValues(alpha: .06),
            blurRadius: size * .2,
            offset: Offset(0, size * .05),
          ),
        ],
      ),
      child: Icon(
        avatar.icon,
        size: size * .46,
        color: LumioColors.textPrimary,
      ),
    ),
  );
}

/// Custom form presentation retains native text editing and form validation.
class ChildProfileFields extends StatefulWidget {
  const ChildProfileFields({
    super.key,
    required this.formKey,
    required this.onChanged,
    this.initial,
    this.enabled = true,
  });
  final GlobalKey<FormState> formKey;
  final ChildDraft? initial;
  final ValueChanged<ChildDraft> onChanged;
  final bool enabled;
  @override
  State<ChildProfileFields> createState() => _ChildProfileFieldsState();
}

class _ChildProfileFieldsState extends State<ChildProfileFields> {
  late final TextEditingController _name;
  int? _age;
  ProfileAvatar _avatar = ProfileAvatar.spark;
  String _language = 'en';
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial?.displayName);
    final initialAge = widget.initial?.startingAge;
    _age = initialAge != null && initialAge >= 5 && initialAge <= 9
        ? initialAge
        : null;
    _avatar = widget.initial?.avatar ?? ProfileAvatar.spark;
    _language = widget.initial?.language ?? 'en';
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _changed() => widget.onChanged(
    ChildDraft(
      displayName: _name.text,
      startingAge: _age ?? 0,
      avatar: _avatar,
      language: _language,
    ),
  );
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LumioFieldGroup(
            label: s.nicknameLabel,
            help: s.nicknameHelp,
            child: Semantics(
              label: s.nicknameLabel,
              child: LumioTextField(
                key: const ValueKey('childNickname'),
                controller: _name,
                enabled: widget.enabled,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                hintText: s.nicknameHint,
                icon: Icons.face_outlined,
                onChanged: (_) => _changed(),
                validator: (value) => validateDisplayName(value ?? '', s),
              ),
            ),
          ),
          const _FormSectionDivider(),
          LumioFieldGroup(
            label: s.startingAgeLabel,
            help: s.ageHelp,
            child: FormField<int>(
              key: const ValueKey('startingAge'),
              initialValue: _age,
              enabled: widget.enabled,
              validator: (age) => age == null ? s.ageRequired : null,
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, bounds) {
                      final scale =
                          MediaQuery.textScalerOf(context).scale(18) / 18;
                      final columns = bounds.maxWidth >= 312 && scale < 1.6
                          ? 5
                          : 3;
                      final width =
                          (bounds.maxWidth - (columns - 1) * 8) / columns;
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (var age = 5; age <= 9; age++)
                            SizedBox(
                              width: width,
                              child: LumioFormChoice(
                                key: ValueKey('age-$age'),
                                label: '$age',
                                compact: true,
                                selected: _age == age,
                                onTap: widget.enabled
                                    ? () {
                                        field.didChange(age);
                                        setState(() => _age = age);
                                        _changed();
                                      }
                                    : null,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          field.errorText!,
                          style: LumioTypography.bodySmall.copyWith(
                            color: LumioColors.error,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const _FormSectionDivider(),
          LumioFieldGroup(
            label: s.avatarTitle,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
                final columns = constraints.maxWidth >= 300 && scale < 1.4
                    ? 4
                    : 2;
                final width =
                    (constraints.maxWidth - (columns - 1) * 8) / columns;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final avatar in ProfileAvatar.values)
                      SizedBox(
                        width: width,
                        child: LumioFormChoice(
                          label: avatar.label(s),
                          selected: _avatar == avatar,
                          leading: ProfileAvatarView(avatar: avatar, size: 44),
                          onTap: widget.enabled
                              ? () {
                                  setState(() => _avatar = avatar);
                                  _changed();
                                }
                              : null,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const _FormSectionDivider(),
          LumioFieldGroup(
            key: const ValueKey('childLanguage'),
            label: s.childLanguageLabel,
            child: LayoutBuilder(
              builder: (context, bounds) {
                final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
                final width = bounds.maxWidth >= 300 && scale < 1.5
                    ? (bounds.maxWidth - 8) / 2
                    : bounds.maxWidth;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final language in ['en', 'ms'])
                      SizedBox(
                        width: width,
                        child: LumioFormChoice(
                          label: language == 'en'
                              ? s.englishLanguage
                              : s.malayLanguage,
                          selected: _language == language,
                          onTap: widget.enabled
                              ? () {
                                  setState(() => _language = language);
                                  _changed();
                                }
                              : null,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FormSectionDivider extends StatelessWidget {
  const _FormSectionDivider();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 24),
    child: Divider(height: 1, color: LumioColors.outlineSubtle),
  );
}

String? validateDisplayName(
  String value,
  AppLocalizations s, {
  bool optional = false,
}) {
  final name = value.trim();
  if (name.isEmpty && !optional) return s.nicknameRequired;
  if (name.runes.length > 40) return s.nameTooLong;
  if (RegExp(r'[\x00-\x1F\x7F]').hasMatch(name)) return s.nameInvalid;
  return null;
}

class ProfileSummary extends StatelessWidget {
  const ProfileSummary({super.key, required this.draft});
  final ChildDraft draft;
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LumioColors.primaryContainer, LumioColors.surface],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LumioColors.outlineSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatarView(avatar: draft.avatar, size: 68),
          const SizedBox(height: 18),
          Text(draft.displayName.trim(), style: LumioTypography.headingMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ProfileDetail(
                icon: Icons.cake_outlined,
                label: s.ageDescription(draft.startingAge),
              ),
              _ProfileDetail(
                icon: Icons.language_rounded,
                label: draft.language == 'ms'
                    ? s.malayLanguage
                    : s.englishLanguage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  const _ProfileDetail({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: LumioColors.surface,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: LumioColors.primary),
        const SizedBox(width: 7),
        Flexible(child: Text(label, style: LumioTypography.bodySmall)),
      ],
    ),
  );
}

Future<bool> confirmProfileAction(
  BuildContext context, {
  required String title,
  required String description,
  required String confirm,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final s = AppLocalizations.of(dialogContext);
        return AlertDialog(
          scrollable: true,
          title: Text(title),
          content: SingleChildScrollView(child: Text(description)),
          actions: [
            LumioButton(
              label: s.cancelAction,
              variant: LumioButtonVariant.ghost,
              onPressed: () => Navigator.pop(dialogContext, false),
            ),
            LumioButton(
              label: confirm,
              onPressed: () => Navigator.pop(dialogContext, true),
            ),
          ],
        );
      },
    ) ??
    false;

class ProfileErrorText extends StatelessWidget {
  const ProfileErrorText({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Padding(
      padding: const EdgeInsets.only(bottom: LumioSpacing.md),
      child: Text(
        AppLocalizations.of(context).profileSaveError,
        style: LumioTypography.bodyMedium.copyWith(color: LumioColors.error),
      ),
    ),
  );
}
